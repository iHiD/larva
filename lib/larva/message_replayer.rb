module Larva
  class MessageReplayer

    def self.reprocess_failed(topic_name, count=1)
      new(topic_name).reprocess_failed(count)
    end

    def initialize(topic_name)
      @topic_name = topic_name
    end

    def reprocess_failed(count)
      Filum.logger.info "Reprocessing #{count} message(s) for topic: #{@topic_name}"

      subscription = Propono::QueueSubscription.create(@topic_name)
      original_url = subscription.queue.url
      failed_url = subscription.failed_queue.url

      sqs = Fog::AWS::SQS.new(Propono.aws_options)
      response = sqs.receive_message( failed_url, {'MaxNumberOfMessages' => count.to_i} )
      messages = response.body['Message']
      if messages.empty?
        raise StandardError.new "Message empty"
      else
        messages.each do |msg|
          sqs_message = Propono::SqsMessage.new(msg)
          Filum.logger.info "Message : #{sqs_message}"
          sqs.send_message(original_url, sqs_message.to_json_with_exception(StandardError.new "Fake Exception"))
          sqs.delete_message(failed_url, msg['ReceiptHandle'])
        end
      end
    end
  end
end
