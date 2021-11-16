class LatticedDocument
  class Parser < Kramdown::Parser::Kramdown
    require_relative 'parser/emoji_parser'
    include EmojiParser
  end
end
