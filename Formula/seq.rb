class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.22"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "1efc32588b48ef8e1f5f4bb79b7ff0cc0b3a117637eb94aea1b277dd5814bcd7"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "ee73f91a4ea9439b539706e9d31dc87183916b8ecc58cc666bd0898b2944718d"
  end

  def install
    bin.install "seq"
  end

  test do
    help = shell_output("#{bin}/seq --help")
    assert_match "skills-rank", help
    assert_match "skill-blocks", help
    assert_match "artifact-search", help
    assert_match "plan-search", help
    assert_match "reply-latency", help

    token_help = shell_output("#{bin}/seq token-usage --help")
    assert_match "--tz", token_help
    assert_match "--summary", token_help
  end
end
