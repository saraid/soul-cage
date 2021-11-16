class LatticedDocument
  class Converter < Kramdown::Converter::Html
    def cards
      Lattice.instance.cards
    end
  end
end
