class LatticedDocument
  class Parser < Kramdown::Parser::Kramdown
    require_relative 'parser/emoji_parser'
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
