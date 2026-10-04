class Vectrize < Formula
  desc "Local and fast semantic search over folders of Markdown documents, built for you and your AI agents."
  homepage "https://github.com/pablofrr/vectrize"
  version "0.2.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pablofrr/vectrize/releases/download/v0.2.1/vectrize-aarch64-apple-darwin.tar.xz"
    sha256 "797fa7628fedf0861618dcfeebd491795fcb99b600d18b1fb39a2b4b46a25a52"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.1/vectrize-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac3a84941099595fc4bc642f095aa002c3bdf9645ddc12bd9a021c0484a86350"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.1/vectrize-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bd13211409a288f91eb94df09a8e9643d64b1bfca14e1446de13f437a548b1a5"
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
