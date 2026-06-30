class Roses < Formula
  desc "A TUI RSS reader, backed by Feedbin."
  homepage "https://github.com/rharmes/roses"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rharmes/roses/releases/download/v0.1.0/roses-aarch64-apple-darwin.tar.xz"
      sha256 "16003628bfbc75ce49adaedad821539a33f7bce13c502cf21265eec28381683f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rharmes/roses/releases/download/v0.1.0/roses-x86_64-apple-darwin.tar.xz"
      sha256 "90f5ec82bc815254ed49f091d8002bc87d9dc35444d9eb8934f3a5f241e2a346"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rharmes/roses/releases/download/v0.1.0/roses-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ef70e0223e55b7a56663ce3c5c3d715e7110d1cd9f3be4ca1826cf292581595d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rharmes/roses/releases/download/v0.1.0/roses-x86_64-unknown-linux-musl.tar.xz"
      sha256 "afc30de595fc0e7435ec14d35857d0c520049a2a8d41920cddac922a06c51318"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    bin.install "roses" if OS.mac? && Hardware::CPU.arm?
    bin.install "roses" if OS.mac? && Hardware::CPU.intel?
    bin.install "roses" if OS.linux? && Hardware::CPU.arm?
    bin.install "roses" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
