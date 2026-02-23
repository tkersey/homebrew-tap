class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  url "https://github.com/tkersey/skills-zig.git",
      using:    :git,
      tag:      "seq-v0.2.3",
      revision: "3327b5f706c6391fa426ed2a6458ef8ef1a950a0"
  license "MIT"

  depends_on "zig" => :build

  def install
    system "zig", "build", "build-seq", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/seq"
  end

  test do
    assert_match "skills-rank", shell_output("#{bin}/seq --help")
  end
end
