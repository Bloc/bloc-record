module BlocRecord
  module Utility
    extend self

    def underscore(camel_cased_word)
       string = camel_cased_word.gsub(/::/, '/')
       string.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
       string.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
       string.tr!("-", "_")
       string.downcase
    end
    def sql_strings(value)
      case value
      when String
        "'#{value}'"
      when Numeric
        value.to_s
      else
        "null"
      end
    end

    def convert_keys(options)
      options.keys.each {|k| options[k.to_s] = options.delete(k) if k.kind_of?(Symbol)}
      options
    end
  end
end
