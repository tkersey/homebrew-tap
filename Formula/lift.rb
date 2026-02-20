class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/lift"
  url "https://github.com/tkersey/lift.git",
      using:    :git,
      revision: "f177725db7358032d0085027ef40329315daf12d"
  version "f177725"
  head "https://github.com/tkersey/lift.git", branch: "main"

  depends_on "zig" => :build

  def install
    bin.mkpath
    system "zig", "build-exe", "scripts/bench_stats.zig",
                  "-O", "ReleaseFast",
                  "--name", "bench_stats",
                  "-femit-bin=#{bin}/bench_stats"
    system "zig", "build-exe", "scripts/perf_report.zig",
                  "-O", "ReleaseFast",
                  "--name", "perf_report",
                  "-femit-bin=#{bin}/perf_report"
  end

  test do
    assert_match "bench_stats.zig", shell_output("#{bin}/bench_stats --help 2>&1")
    assert_match "perf_report.zig", shell_output("#{bin}/perf_report --help 2>&1")
  end
end
