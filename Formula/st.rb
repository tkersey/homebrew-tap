class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.4.5"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "5dc6db62e5cdf9e0f9c12b58a38174bde1a9e88f7a2cd4e2e2be5854d232ce2a"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "34d36494897bc2c9ee3fbeac7346d9a8df333d0575b3f42947a85b9c79071a63"
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
    complete_help = shell_output("#{bin}/st complete --help")
    assert_match "usage: st complete --file PATH --id ID [--command CMD --evidence-ref REF] [options]", complete_help
    assert_match "--command CMD", complete_help
    assert_match "--evidence-ref REF", complete_help
    compile_aperture_help = shell_output("#{bin}/st compile aperture --help")
    assert_match "--parallelism auto", compile_aperture_help
    assert_match "Legacy no-op compatibility alias", compile_aperture_help
  end
end
