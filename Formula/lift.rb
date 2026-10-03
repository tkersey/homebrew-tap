class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.0"

  if OS.mac?
    depends_on arch: :arm64
    depends_on macos: :sequoia
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "4b0ef88ec39bf8ee84e357d3c68792a1b33395788561ad1a02953565433d30b4"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "c128a120331a18d1b45153a573eb065116b6fb3b623c47d9eaac1e880bf7be3d"
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
