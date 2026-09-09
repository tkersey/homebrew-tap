class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.15"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "d3ec77f8bb35c9e2dcbc20e185f2b36caa6662c5b4a3f38080da73e6e8fed045"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "86c5c5c1e5ebe02a61415cb163940af3dc8297a9ef51a5d29da62885259e5fd6"
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
