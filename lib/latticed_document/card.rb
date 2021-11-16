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
      @filename.relative_path_from(Lattice.current.root).sub(%r{cards/}, '').sub(%r{\.card$}, '')
    end

    def html_id
      @filename
        .relative_path_from(Lattice.current.root)
        .sub(%r{^cards/}, '')
        .sub(%r{\.card$}, '')
    end

    def html
      document.to_html.yield_self do |html|
        %Q{<div id="card-#{html_id.to_s.gsub('/', '-')}" class="card character">#{html}</div>}
      end
    end
  end
end
