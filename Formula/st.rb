class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.4.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "fc40e6253fc5ea747c221bdf4fa9b8ec03715ffe0ea633ca49c346b738197cda"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "64350b61850603c5738dcc574d5ce73498a750a50c17d46f5469796f554854c7"
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
    assert_match "intake", help
    assert_match "graph", help
    assert_match "complete", help
    assert_match "usage: st prime --file PATH [options]", shell_output("#{bin}/st prime --help")
    assert_match "usage: st complete --file PATH --id ID --command CMD --evidence-ref REF [options]",
      shell_output("#{bin}/st complete --help")
  end
end
