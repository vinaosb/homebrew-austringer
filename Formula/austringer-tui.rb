class AustringerTui < Formula
  desc "Terminal user interface for the austringer daemon (ratatui)"
  homepage "https://vinaosb.github.io/austringer/"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-tui-aarch64-apple-darwin.tar.xz"
      sha256 "b603d1cfc39694be6669c51e8bb7d9a5032d5542932ef8878b1005a6f8703ae5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-tui-x86_64-apple-darwin.tar.xz"
      sha256 "25057bb72a116745deef9d4d752bab5e9b94de58db0e1e0598f4a28a6bea211a"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "0fd6e6d34b5260e46b06fe304e43537535468afaed7fe9cb70c4f229534acb3c"
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
      bin.install "austringer-tui"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "austringer-tui"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "austringer-tui"
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
