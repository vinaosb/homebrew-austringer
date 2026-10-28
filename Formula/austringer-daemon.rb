class AustringerDaemon < Formula
  desc "The austringer engine daemon: sessions, routing, permissions, cost budgets"
  homepage "https://vinaosb.github.io/austringer/"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "665d4f09633e2f1dc11a238988f75906ba4dd6b94a37f2674d27b279b28d48db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "fa828f85f523511ba7eebe9a7ebcca42780e6766b314e617b4f22ff7b75c5151"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-daemon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b4f203111506c62edbef09164427d4558440f81fd468f58feb54fe3b8ce4cdee"
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
      bin.install "austringer-daemon"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "austringer-daemon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "austringer-daemon"
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
