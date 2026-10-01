class Vectrize < Formula
  desc "Local semantic search over folders of Markdown documents, for the terminal and AI agents"
  homepage "https://github.com/pablofrr/vectrize"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pablofrr/vectrize/releases/download/v0.2.0/vectrize-aarch64-apple-darwin.tar.xz"
    sha256 "0fe3e4417071a3600b5fcd10d05bb185ab0733ba4279d0eb1f015d4277632cb6"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.0/vectrize-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4e2b41624d34619137230a1bb1bcbb5b34e85a0b6982c4f786c259ec1f4bb10d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.0/vectrize-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fbae1b124f9a759e5c623fe36782f74579e829f70aadf8af5c8e4d9f644cf17d"
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
