class Object
  def blank?
    respond_to?(:empty?) ? !!empty? : !self
  end
end

class String
  def camelize(first_letter = :upper)
    case first_letter
    when :upper
      Larva::Utils.camelize(self, true)
    when :lower
      Larva::Utils.camelize(self, false)
    end
  end
end

module Larva
  module Utils
    def self.camelize(term, uppercase_first_letter = true)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }
      string.gsub!('/', '::')
      string
    end
  end
end
