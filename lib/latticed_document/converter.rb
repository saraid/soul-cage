class LatticedDocument
  class Converter < Kramdown::Converter::Html
    def cards
      Lattice.cards
    end
  end
end
