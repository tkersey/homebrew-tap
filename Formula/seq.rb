class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.21"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "859a3e44a8288c5d4e76b0bb7d3f90af6eabe6764791f36afc81b3da6231ad7a"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "2ce733f901fec0a25d81a5e2b202cadefe1dfe7e2214b15c7966328bdd2dad29"
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
  end
end
