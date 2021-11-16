require_relative './custom_parser'

Dir.chdir(`git rev-parse --show-toplevel`.chomp)

kramdown_options = {
  input: 'CustomParser',
  template: 'templates/default.template'
}

cards = Dir.glob('cards/**/*.card').map do |input_filename|
  card_reference = input_filename.sub(%r{cards/}, '').sub(%r{\.card$}, '')
  source_text = File.read(input_filename)
  document = Kramdown::Document.new(source_text)
  html = document.to_html.yield_self do |html|
    %Q{<div id="card-#{card_reference.gsub('/', '-')}" class="card character">#{html}</div>}
  end

  [card_reference, html]
end.to_h


Dir.glob('pages/**/*.page').each do |input_filename|
  source_text = File.read(input_filename)
  output_filename = input_filename.yield_self do |filename|
    parts = filename.split('/')
    parts[0] = 'docs'
    parts[-1] = parts[-1].sub(/\.page$/, '.html')
    parts.join('/')
  end

  document = Kramdown::CustomDocument.new(source_text, kramdown_options)
  Kramdown::Converter::CustomConverter.cards = cards
  File.open(output_filename, 'w') { |f| f.write(document.to_custom_converter) }
end

