require_relative './latticed_document'

LatticedDocument::Lattice.generate!(root: Pathname.new(`git rev-parse --show-toplevel`.chomp))
