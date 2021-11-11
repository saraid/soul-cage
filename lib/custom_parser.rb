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

  module Converter
    class CustomConverter < ::Kramdown::Converter::Html
      def initialize(root, options)
        super

        @cards = {}
      end
      attr_reader :cards

      def convert_abbreviation(el, _indent)
        title = @root.options[:abbrev_defs][el.value]
        attr = @root.options[:abbrev_attr][el.value].dup
        attr['title'] = title unless title.empty?

        body = el.value
        if title.match(%r{characters/\w+})
          @cards[title] ||=
            File.join(`git rev-parse --show-toplevel`.chomp, "cards/#{title}.card")
              .yield_self(&File.method(:read))
              .yield_self(&::Kramdown::Document.method(:new))
              .to_html
              .yield_self { |html| %Q{<div id="card-#{title.gsub('/', '-')}" class="card character">#{html}</div>} }
        end

        format_as_span_html("abbr", attr, body)
      end
    end
  end
end
