class Puff < Formula
  desc "Zig CLI for Codex cloud task orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  url "https://github.com/tkersey/skills-zig.git",
      using:    :git,
      tag:      "puff-v0.1.2",
      revision: "1983dbfa8b013b571a9a185ffdbb0c691979e500"
  license "MIT"

  depends_on "zig" => :build

  def install
    bin.mkpath
    system "zig", "build", "build-puff", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/puff"
  end

  test do
    puff_help = shell_output("#{bin}/puff --help 2>&1")
    assert_match "puff.zig", puff_help
  end
end
