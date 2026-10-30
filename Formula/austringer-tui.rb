class AustringerTui < Formula
  desc "Terminal user interface for the austringer daemon (ratatui)"
  homepage "https://vinaosb.github.io/austringer/"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.3/austringer-tui-aarch64-apple-darwin.tar.xz"
      sha256 "b321967c77d9a3c5041172da196076868348bc44181538ab7f2cb221f603c77d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.3/austringer-tui-x86_64-apple-darwin.tar.xz"
      sha256 "415d2e566e55a909bf131c444b6d2279899ec56f9349f4bb4f22aea2c21d251e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vinaosb/austringer/releases/download/v0.1.3/austringer-tui-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f4ed87942f31d2bf9812955ff28a0f40ed8ce1bc580aaa689605accba46ad533"
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
