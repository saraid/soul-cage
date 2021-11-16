class LatticedDocument
  class Page
    def self.paths
      Lattice.current.root.glob('pages/**/*.page')
    end

    def self.all
      @all ||= paths.map(&method(:new))
    end

    def initialize(filename)
      @filename = filename
      @document = LatticedDocument.new(source_with_inclusions)
    end
    attr_reader :document
    attr_accessor :cards

    def source_with_inclusions
      [ inclusions, File.read(@filename) ].join($/ * 2)
    end

    def inclusions
      Lattice.current.cards.map do |card|
        "*[#{card.reference.to_s.capitalize}]: #{card.as_abbreviation}"
      end.join($/)
    end

    def output_filename
      @filename
        .relative_path_from(Lattice.current.root)
        .sub(%r{^pages}, 'docs')
        .sub_ext('.html')
        .yield_self(&Lattice.current.root.method(:join))
    end

    def html
      document.to_html
    end
  end
end
