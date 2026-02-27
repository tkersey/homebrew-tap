class Lift < Formula
  desc "Zig CLI helpers for performance measurement workflows"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.7"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "7d4212ab0ce328835395f1284b345816187fe81f50e5270831a60680b7694439"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "e047581bbe3c872aa2cf77fd5b18a83232363cab9c89f65634ee7dcf2c06661c"
  end

  def install
    bin.install "lift-bench-stats" => "bench_stats"
    bin.install "lift-perf-report" => "perf_report"
  end

  test do
    assert_match "Summarize benchmark samples", shell_output("#{bin}/bench_stats --help 2>&1")
    assert_match "Generate a performance report template", shell_output("#{bin}/perf_report --help 2>&1")
  end
end
