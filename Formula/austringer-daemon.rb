class AustringerDaemon < Formula
  desc "The austringer engine daemon: sessions, routing, permissions, cost budgets"
  homepage "https://vinaosb.github.io/austringer/"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.3/austringer-daemon-aarch64-apple-darwin.tar.xz"
      sha256 "6db3975c6fc1a168719555837f7c5ffe817e03ddf6890dd4fe95b218608572aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.3/austringer-daemon-x86_64-apple-darwin.tar.xz"
      sha256 "6a973da6c9b8b1e2a825d4be803130bd640124e14059238543ce1739b0f9ddc7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vinaosb/austringer/releases/download/v0.1.3/austringer-daemon-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b49f17ad8be0c1e3a2db8038583f83ffe11362715cf2f7f5929afa20a2f4bee3"
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
