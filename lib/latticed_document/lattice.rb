class LatticedDocument
  class Lattice
    def self.generate!
      new
    end

    def initialize
      @cards = Card.all
      @pages = Page.all
    end
    attr_reader :cards, :pages
  end
end
