class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.10"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "2f2f83acb4eef2918de655427a590be77c8525830b7bc284be41af411269ba72"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "2d1b304b89bf95ecd4805847028b9c2f19e58b895dcac4efbc379eea76fb195a"
  end

  def install
    bin.install "lift-bench-stats" => "bench_stats"
    bin.install "lift-perf-report" => "perf_report"
    bin.install "lift-perf-bench-stats"
  end

  test do
    assert_match "Summarize benchmark samples", shell_output("#{bin}/bench_stats --help 2>&1")
    assert_match "Generate a performance report template", shell_output("#{bin}/perf_report --help 2>&1")
    perf_help = shell_output("#{bin}/lift-perf-bench-stats --help 2>&1")
    assert_match "Performance harness for bench_stats parser", perf_help
  end
end
