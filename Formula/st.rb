class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.5.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "990cfa4492c6870e6f88c13d171b8508001daaeb653bd95a30370c4e55642bc4"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "e7f17340b0c4037030270ed72f79e2988a7a1cb5bb686dd7fed7db606346f69a"
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
    show_help = shell_output("#{bin}/st show --help")
    assert_match "usage: st show --file PATH [--id ID]", show_help
    assert_match "--id ID", show_help
    compile_aperture_help = shell_output("#{bin}/st compile aperture --help")
    assert_match "--parallelism auto", compile_aperture_help
    assert_match "Legacy no-op compatibility alias", compile_aperture_help
  end
end
