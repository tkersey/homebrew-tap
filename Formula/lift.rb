class Lift < Formula
  desc "Benchmark sample statistics and comparisons"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.4.0"

  if OS.mac?
    depends_on arch: :arm64
    depends_on macos: :sequoia
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "0031a2909a3fa6fc7c0c74222beab5a3e0cb9c43d5bc566e4710b63580b912a5"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "d60335bdc2e8b3c92d088f985545461d7acf491e5dba2bebc01c21d3cc5bcdbd"
  end

  def install
    bin.install "lift-bench-stats" => "bench_stats"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/bench_stats --version").strip
    assert_match "Summarize benchmark samples", shell_output("#{bin}/bench_stats --help 2>&1")

    (testpath/"baseline.txt").write "1\n2\n3\n4\n5\n"
    (testpath/"variant.txt").write "2\n3\n4\n5\n6\n"
    summary = JSON.parse(shell_output("#{bin}/bench_stats --input #{testpath}/baseline.txt --unit ms --json"))
    assert_equal 5, summary.fetch("count")
    assert_equal 3.0, summary.fetch("mean")
    assert_equal 3.0, summary.fetch("p50")
    assert_equal "ms", summary.fetch("unit")

    comparison = JSON.parse(shell_output(
                              "#{bin}/bench_stats --input #{testpath}/baseline.txt " \
                              "--compare #{testpath}/variant.txt --seed 42 --json",
                            ))
    assert_equal 3.0, comparison.fetch("baseline").fetch("mean")
    assert_equal 4.0, comparison.fetch("variant").fetch("mean")
    assert_equal 1.0, comparison.fetch("delta").fetch("mean")
  end
end
