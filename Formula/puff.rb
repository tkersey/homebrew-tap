class Puff < Formula
  desc "Zig CLI for Codex cloud task orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.6"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-darwin-arm64.tar.gz"
    sha256 "24652dfb8f4a004c2f405ca3b6b00048aada26c57abfd4d72cba5abbae23f17d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-linux-x86_64.tar.gz"
    sha256 "af56c0afcae17f7d1ed5f1c13c6ef4ffa8e7f2882d01953b1e5d86fc77d7bc14"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "puff"
  end

  test do
    puff_help = shell_output("#{bin}/puff --help 2>&1")
    assert_match "puff.zig", puff_help
  end
end
