class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.31"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "6b0ff69814f920b3d2a0d29f63eb297edd42c4c8e676f76687a93c6a910ff6ba"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "4ca5d30d118db09c4c802e22380f840d2a6ce73e27be72254976c891c295d242"
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

    token_help = shell_output("#{bin}/seq token-usage --help")
    assert_match "--tz", token_help
    assert_match "--summary", token_help
    assert_match "--audit", token_help

    assert_match "summary|mentions|trend", shell_output("#{bin}/seq skill-audit --help")
    assert_match "summary|rows|args|unresolved", shell_output("#{bin}/seq tool-audit --help")
    assert_match "categories|files|blocks|stage1|extensions", shell_output("#{bin}/seq memory-inventory --help")
    assert_match "--contains-any", shell_output("#{bin}/seq message-search --help")
    assert_match "summary|sessions", shell_output("#{bin}/seq workdir-report --help")
  end
end
