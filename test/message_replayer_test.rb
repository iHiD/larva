require File.expand_path('../test_helper', __FILE__)

module Larva
  class MessageReplayerTest < Minitest::Test

    def setup
      @topic_name = 'my-topic'

      @original_url = 'http://mock-sqs/my-topic-queue'
      @failed_url = 'http://mock-sqs/my-topic-queue-failed'

      original_queue = stub(url: @original_url)
      failed_queue = stub(url: @failed_url)

      subscription = stub(queue: original_queue, failed_queue: failed_queue)
      Propono::QueueSubscription.expects(:create).with(@topic_name).returns(subscription)

      aws_options = stub()
      Propono.expects(:aws_options).returns(aws_options)

      @sqs = mock()
      Fog::AWS::SQS.expects(:new).with(aws_options).returns(@sqs)
    end

    def test_reprocess_failed_when_no_messages_on_queue
      stub_sqs_response = stub(body: {'Message' => []})
      @sqs.expects(:receive_message).with(@failed_url, {'MaxNumberOfMessages' => 1}).returns(stub_sqs_response)

      replayer = MessageReplayer.new(@topic_name)
      assert_raises StandardError do
        replayer.reprocess_failed(1)
      end
    end

    def test_should_request_message_count_from_sqs
      stub_sqs_response = stub(body: {'Message' => []})
      @sqs.expects(:receive_message).with(@failed_url, {'MaxNumberOfMessages' => 7}).returns(stub_sqs_response)

      replayer = MessageReplayer.new(@topic_name)
      begin
        replayer.reprocess_failed(7)
      rescue
      end
    end

    def test_reprocess_failed_when_single_message_on_queue
      receipt_handle = 'my-receipt-handle'
      @message = { 'ReceiptHandle' => receipt_handle }
      @message_to_replay = {}
      @parsed_msg = stub(to_json_with_exception: @message_to_replay)

      # Stub out the message parsing in Propono
      Propono::SqsMessage.stubs(:new).with(@message).returns(@parsed_msg)

      stub_sqs_response = stub(body: {'Message' => [@message]})
      @sqs.stubs(:receive_message).with(@failed_url, {'MaxNumberOfMessages' => 1}).returns(stub_sqs_response)
      @sqs.expects(:send_message).with(@original_url, @message_to_replay)
      @sqs.expects(:delete_message).with(@failed_url, receipt_handle)

      replayer = MessageReplayer.new(@topic_name)
      replayer.reprocess_failed(1)
    end

  end
end

