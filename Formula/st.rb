class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.13"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "f54ba89457b93a014681debfa453a21ea1d20acf940d85a055de808eb6c172c9"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "10bf0a00c29d2f4e7acf6a0a03af7ae87b738934641e10ebebee43b59301e28b"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "st"
  end

  test do
    help = shell_output("#{bin}/st --help")
    assert_match "Manage dependency-aware JSONL v3 plan state.", help
    assert_match "import-orchplan", help
    assert_match "import-update-plan", help
    assert_match "import-mesh-results", help
  end
end
