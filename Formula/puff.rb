class Puff < Formula
  desc "Zig CLI for Codex cloud task orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.4"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-darwin-arm64.tar.gz"
    sha256 "55ca1578e4b8d2ad169a530d5584f3c0e29f8f96d06b21fa3418c0836a51920f"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-linux-x86_64.tar.gz"
    sha256 "181652d484b1bd822b535d7221fb5ff8322a27699462a743d5ec6cf2b0deb07f"
  end

  def install
    bin.install "puff"
  end

  test do
    puff_help = shell_output("#{bin}/puff --help 2>&1")
    assert_match "puff.zig", puff_help
  end
end
