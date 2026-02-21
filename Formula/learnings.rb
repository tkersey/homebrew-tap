class Learnings < Formula
  desc "Zig CLIs for Codex learnings capture workflows"
  homepage "https://github.com/tkersey/skills-zig"
  url "https://github.com/tkersey/skills-zig.git",
      using:    :git,
      tag:      "learnings-v0.1.1",
      revision: "4c3bd1a515e7dadf00b5cf4df6044780ebd98230"
  license "MIT"

  depends_on "zig" => :build

  def install
    bin.mkpath
    system "zig", "build", "build-learnings", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/learnings", "zig-out/bin/append_learning"
  end

  test do
    learnings_help = shell_output("#{bin}/learnings --help 2>&1")
    assert_match "learnings.zig", learnings_help

    append_help = shell_output("#{bin}/append_learning --help 2>&1")
    assert_match "append_learning.zig", append_help
  end
end
