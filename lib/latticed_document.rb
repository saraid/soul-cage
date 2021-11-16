require 'kramdown'
require 'pathname'

class LatticedDocument < Kramdown::Document
  def self.root
    Pathname.new(`git rev-parse --show-toplevel`.chomp)
  end

  def initialize(source, options = {})
    @options = Kramdown::Options.merge(options.merge({ template: 'templates/default.template' })).freeze
    @root, @warnings = Parser.parse(source, @options)
  end

  def to_html
    output, warnings = Converter.convert(@root, @options)
    @warnings.concat(warnings)
    output
  end
end

require_relative 'latticed_document/converter'
require_relative 'latticed_document/parser'

require_relative 'latticed_document/lattice'
require_relative 'latticed_document/card'
require_relative 'latticed_document/page'
