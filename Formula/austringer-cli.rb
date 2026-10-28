class AustringerCli < Formula
  desc "Thin terminal client over the austringer daemon (run, capture, REPL, attach, doctor)"
  homepage "https://vinaosb.github.io/austringer/"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-cli-aarch64-apple-darwin.tar.xz"
      sha256 "1ac6c1602408840831689db3f1ee75d8d62faefc664d7c8e4b97bd5d4c0d0e61"
    end
    if Hardware::CPU.intel?
      url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-cli-x86_64-apple-darwin.tar.xz"
      sha256 "50fc844dc4e4225176308a29a2e122b9d028b967ebbdd78012f5e7e0b1199683"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/vinaosb/austringer/releases/download/v0.1.2/austringer-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "b77cc9e3b09f057b73780f4d84d0adc9a2c57d1d146a90981d472bec4deb4fe7"
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
      bin.install "austringer"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "austringer"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "austringer"
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
