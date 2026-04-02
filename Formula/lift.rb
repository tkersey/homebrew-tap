class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.8"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "18e869a66c116a7c68ca42e018bebba4dd526aa2785f8c0c74170bddbc140f39"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "8abe3a32b7c10bd898f2fb524e96c71f2625e94135bafd951c7b51d117817e5b"
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
