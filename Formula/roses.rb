class Roses < Formula
  desc "A TUI RSS reader, backed by Feedbin."
  homepage "https://github.com/rharmes/roses"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rharmes/roses/releases/download/v0.2.0/roses-aarch64-apple-darwin.tar.xz"
      sha256 "0c5c1042b7f52abcddb91a85184e72e81607772b3d9082afcaadc44751b6faf3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rharmes/roses/releases/download/v0.2.0/roses-x86_64-apple-darwin.tar.xz"
      sha256 "d63ca95c2ec09da551e01f7a3a367e2d9f5b4c92d434108ffee04e5733d30aa8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rharmes/roses/releases/download/v0.2.0/roses-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9db01b6d9bbd0e5502dbb89987bf7ba2e0d46a673fd3c389e83f500ad4eadce3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rharmes/roses/releases/download/v0.2.0/roses-x86_64-unknown-linux-musl.tar.xz"
      sha256 "32834f14edcac255bb63f5ff886d73708a6d7acb1119db3cd08ef36af6998d19"
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
