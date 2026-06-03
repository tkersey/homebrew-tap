class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "85a4ed320efee49e9dad781c4bd73a72f2a7ee4c5c8357b0d5c69feeaa5d02ca"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "79b38ac5f0f42fb153d23e5144e7875afb29ba902d919dab6a22b61fd1b46f16"
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
    assert_match "Manage dependency-aware JSONL v3/v4 plan state.", help
    assert_match "prime", help
    assert_match "assert-projection", help
    assert_match "reconcile-codex", help
    assert_match "import-proposed-plan", help
    assert_match "graph", help
    assert_match "complete", help
  end
end
