require_relative './custom_parser'

Dir.chdir(`git rev-parse --show-toplevel`.chomp)
pages = `find pages -name \*.page`.split($/)

kramdown_options = {
  input: 'CustomParser',
  template: 'templates/default.template'
}

pages.each do |input_filename|
  source_text = File.read(input_filename)
  output_filename = input_filename.yield_self do |filename|
    parts = filename.split('/')
    parts[0] = 'docs'
    parts[-1] = parts[-1].sub(/\.page$/, '.html')
    parts.join('/')
  end

  document = Kramdown::Document.new(source_text, kramdown_options)
  File.open(output_filename, 'w') { |f| f.write(document.to_custom_converter) }
end

