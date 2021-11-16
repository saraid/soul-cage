class LatticedDocument
  class Converter < Kramdown::Converter::Html
    def cards
      Lattice.current.cards
    end
  end
end
