class Puff < Formula
  desc "Zig CLI for Codex cloud task orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.5"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-darwin-arm64.tar.gz"
    sha256 "d9346d2b0586887fd322f24fb2ccee7d25751e265b9b0d388028b0f1dd234f25"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-linux-x86_64.tar.gz"
    sha256 "6edc1dda063ede7b8b67b0e7e8c91f8ae76e03558cc4c1206f366ef356e7a18e"
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
