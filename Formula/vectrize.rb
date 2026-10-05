class Vectrize < Formula
  desc "Local and fast semantic search over folders of Markdown documents, built for you and your AI agents."
  homepage "https://vectrize.com"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pablofrr/vectrize/releases/download/v0.2.3/vectrize-aarch64-apple-darwin.tar.xz"
    sha256 "c92599313af4b165df8d5cc85cbd2a72aee7921ebf2512ba1b3219be3924e203"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.3/vectrize-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "537b85c19e3f4a1cca9014152cffd43cefe4de01065e1ccfcb97fe256fd4fb1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.2.3/vectrize-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "24faed469bfa85a75b5d5d08b8bf51ca101457eadc63d205592c583d3430bee8"
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
