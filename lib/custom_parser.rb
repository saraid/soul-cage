require 'kramdown'
require 'gemoji'

require_relative './emoji_parser'

module Kramdown
  module Parser
    class CustomParser < Kramdown::Parser::Kramdown
      include EmojiParser

      def initialize(source, options)
        super

        @span_parsers.unshift(:emoji)
      end
    end
  end
end
