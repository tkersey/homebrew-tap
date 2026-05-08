class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.29"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "cce7aac347c792bf664031292ddc1261455f7e5ff0e8ae6b45f326fe8edc5434"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "3b30277f56ce8c874c50f5ec21ed795c69a327f7ca09f0bd37c3e59a7d47286e"
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
