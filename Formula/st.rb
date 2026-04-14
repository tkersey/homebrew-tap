class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.12"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "c706a8b1f091b9801ab7295059a1e3b35d18301636d5145654f8e65e1c39a8ed"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "ecaf712b6a858025d2f84c2d944c1cf8fbcd1a3058c386ea12b5841c032b7711"
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
