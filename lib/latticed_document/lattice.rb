class LatticedDocument
  class Lattice
    def self.generate!
      new.generate!
    end

    def self.generating(lattice)
      @current = lattice
      yield if block_given?
      @current = nil
    end

    def self.current
      @current
    end

    def initialize(root = Pathname.new(`git rev-parse --show-toplevel`.chomp))
      @root = root
    end
    attr_reader :root

    def cards
      @cards ||= root.glob('cards/**/*.card').map(&Card.method(:new))
    end

    def pages
      @pages ||= root.glob('pages/**/*.page').map(&Page.method(:new))
    end

    def generate!
      self.class.generating(self) do
        pages.each do |page|
          File.open(page.output_filename, 'w') do |f|
            $stderr.puts f.inspect
            f.write(page.html)
          end
        end
      end
    end
  end
end
