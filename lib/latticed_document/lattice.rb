class LatticedDocument
  class Lattice
    def self.generate!
      (@instance = new).generate!
    end

    def self.instance
      @instance
    end

    def initialize
      @cards = Card.all
      @pages = Page.all
    end
    attr_reader :cards, :pages

    def generate!
      pages.each do |page|
        File.open(page.output_filename, 'w') do |f|
          $stderr.puts f.inspect
          f.write(page.html)
        end
      end
    end
  end
end
