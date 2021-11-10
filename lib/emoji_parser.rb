module EmojiParser
  # emoji parsing stolen entirely from kramdown/parser-gfm

  EMOJI_NAMES   = Emoji.all.flat_map(&:aliases).freeze
  REGISTRY      = EMOJI_NAMES.zip(EMOJI_NAMES).to_h.freeze
  EMOJI_PATTERN = /:(\w+):/

  DEFAULT_ASSET_PATH = 'https://github.githubassets.com/images/icons/emoji'

  def self.included(klass)
    klass.define_parser(:emoji, EMOJI_PATTERN, ':')
  end

  def initialize(source, options)
    super

    @span_parsers.unshift(:emoji)
  end

  def parse_emoji
    start_line_number = @src.current_line_number
    result = @src.scan(EMOJI_PATTERN)
    name = @src.captures[0]

    return add_text(result) unless REGISTRY.key?(name)

    el = Kramdown::Parser::Kramdown::Element.new(:img, nil, nil, location: start_line_number)
    # Based on the attributes rendered by `jemoji` plugin on GitHub Pages.
    el.attr.update(
      'class'  => 'emoji',
      'title'  => result,
      'alt'    => result,
      'src'    => emoji_src(name),
      'height' => '20',
      'width'  => '20'
    )
    @tree.children << el
  end

  def emoji_src(name)
    base = @options.dig(:gfm_emoji_opts, :asset_path) || DEFAULT_ASSET_PATH
    File.join(base, Emoji.find_by_alias(name).image_filename)
  end
end
