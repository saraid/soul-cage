class LatticedDocument
  class Card
    def self.paths
      LatticedDocument.root.glob('cards/**/*.card')
    end

    def self.all
      @all ||= paths.map(&method(:new))
    end

    def initialize(filename)
      @filename = filename
      @document = Kramdown::Document.new(File.read(filename))
    end
    attr_reader :document

    def reference
      @filename.basename.sub(%r{\.card$}, '')
    end

    def as_abbreviation
      @filename.sub(%r{cards/}, '').sub(%r{\.card$}, '')
    end

    def html
      document.to_html.yield_self do |html|
        %Q{<div id="card-#{card_reference.gsub('/', '-')}" class="card character">#{html}</div>}
      end
    end
  end
end
