class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "9fb7a8037cd366998f1316a87aa176e24028a9014c665ffe878e2fb7233c17b9"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "27508f882d37d50b473b4bab698e8bfd302011f2967c6d9d5c43574fe9bbbd9f"
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
