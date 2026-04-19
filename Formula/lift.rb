class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.11"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "8e177b5a13d06465e5f84efa0008a6a8472902ac9a129f53bfacb438413bceb1"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "9c33c14c06aafd32a934f302a3bc9fd4752229e256319ebe35414bab5e0e6d65"
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
