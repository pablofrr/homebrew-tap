class Vectrize < Formula
  desc "Local semantic search over folders of Markdown documents, for the terminal and AI agents"
  homepage "https://github.com/pablofrr/vectrize"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/pablofrr/vectrize/releases/download/v0.1.0/vectrize-aarch64-apple-darwin.tar.xz"
    sha256 "b38a02e6776e68a6414352bab833c97e44ae7ee6716714c2fb2eb85fe23d543d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.1.0/vectrize-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6fea6bc00b4079890954b6c745c2bdbbd1e8db69181a8be60868c3eb8dba12f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/pablofrr/vectrize/releases/download/v0.1.0/vectrize-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9bb8d12bdd8890969dcbdc01d708f70b98004515a46675cd42128a868b6edf4b"
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
