require 'kramdown'
require 'gemoji'

require_relative './emoji_parser'

module Kramdown
  class CustomDocument < Document
    def initialize(source, options = {})
      super
    end
  end

  module Parser
    class CustomParser < Kramdown::Parser::Kramdown
      include EmojiParser

      def initialize(source, options)
        super

        @source = "#{inclusions}\n\n#{source}"

        @span_parsers.unshift(:emoji)
      end

      def inclusions
        <<~INCLUSIONS
        *[Samael]: characters/samael
        *[Cobalt]: characters/cobalt
        INCLUSIONS
      end
    end
  end

  module Converter
    class CustomConverter < ::Kramdown::Converter::Html
      self.singleton_class.attr_accessor :cards

      def initialize(root, options)
        super

        @cards = self.class.cards
      end
      attr_reader :cards
    end
  end
end
