class Vectrize < Formula
  desc "Local and fast semantic search over folders of Markdown documents, built for you and your AI agents."
  homepage "https://github.com/pablofrr/vectrize"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pablofrr/vectrize/releases/download/v0.2.2/vectrize-aarch64-apple-darwin.tar.xz"
    sha256 "738406e459099b20725f41f9e0a86f2d9486113b60bfc034b8aea9fbcac2cc77"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.2/vectrize-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "30cc7cdef7c99a3480ee92935f90763fc196f6a3b652fe14194288110bd6a2bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.2/vectrize-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a748ad93819ecc77d9d72c547773d7186742dd7f1d5ec8910b88cd385c4a9fee"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "vectrize"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "vectrize"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "vectrize"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
