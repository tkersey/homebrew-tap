class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.33"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "dd8b3caa2871aa3dc47e057bcb144599679a3871b4875e51e4bff0790da31199"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "97271ca1d4a0dc7f6a6f9d8099e0df53c7252c7cf0477c928c81111428d35f3d"
  end

  def install
    bin.install "seq"
  end

  test do
    help = shell_output("#{bin}/seq --help")
    assert_match "skills-rank", help
    assert_match "skill-blocks", help
    assert_match "artifact-search", help
    assert_match "skill-audit", help
    assert_match "tool-audit", help
    assert_match "memory-inventory", help
    assert_match "message-search", help
    assert_match "workdir-report", help
    assert_match "memory-provenance", help
    assert_match "memory-map", help
    assert_match "memory-history", help
    assert_match "plan-search", help
    assert_match "reply-latency", help
    assert_match "workflow-audit", help
    assert_match "message-audit", help
    assert_match "skill-cohort", help
    assert_match "tool-search", help
    assert_match "memory-extension-audit", help
    assert_match "token-window", help
    assert_match "goal-audit", help

    token_help = shell_output("#{bin}/seq token-usage --help")
    assert_match "--tz", token_help
    assert_match "--summary", token_help
    assert_match "--audit", token_help

    assert_match "summary|mentions|trend", shell_output("#{bin}/seq skill-audit --help")
    assert_match "summary|rows|args|unresolved", shell_output("#{bin}/seq tool-audit --help")
    assert_match "categories|files|blocks|stage1|extensions", shell_output("#{bin}/seq memory-inventory --help")
    assert_match "--contains-any", shell_output("#{bin}/seq message-search --help")
    assert_match "summary|sessions", shell_output("#{bin}/seq workdir-report --help")
    assert_match "summary|rows|sessions", shell_output("#{bin}/seq message-audit --help")
    assert_match "summary|cohort|mentions", shell_output("#{bin}/seq skill-cohort --help")
    assert_match "rows|summary|args", shell_output("#{bin}/seq tool-search --help")
    assert_match "summary|rows", shell_output("#{bin}/seq memory-extension-audit --help")
    assert_match "--window-hours", shell_output("#{bin}/seq token-window --help")
    assert_match "review|resolve", shell_output("#{bin}/seq goal-audit --help")
  end
end
