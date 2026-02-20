class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  url "https://github.com/tkersey/skills-zig.git",
      using: :git,
      tag:   "lift-v0.2.1"
  version "0.2.1"
  head "https://github.com/tkersey/skills-zig.git", branch: "main"

  depends_on "zig" => :build

  def install
    system "zig", "build", "build-lift", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/bench_stats", "zig-out/bin/perf_report"
  end

  test do
    assert_match "Summarize benchmark samples", shell_output("#{bin}/bench_stats --help 2>&1")
    assert_match "Generate a performance report template", shell_output("#{bin}/perf_report --help 2>&1")
  end
end
