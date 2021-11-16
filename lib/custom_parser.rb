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
      def self.cards
        @cards
      end

      def self.cards=(result)
        @cards = result
      end

      def initialize(root, options)
        super

        @cards = self.class.cards
      end
      attr_reader :cards

      def convert_abbreviation(el, _indent)
        title = @root.options[:abbrev_defs][el.value]
        attr = @root.options[:abbrev_attr][el.value].dup
        attr['title'] = title unless title.empty?

        format_as_span_html("abbr", attr, el.value)
      end
    end
  end
end
