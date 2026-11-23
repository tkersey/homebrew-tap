class Lift < Formula
  desc "Benchmark sample statistics and comparisons"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.4.5"

  if OS.mac?
    depends_on arch: :arm64
    depends_on macos: :sequoia
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-darwin-arm64.tar.gz"
    sha256 "ba26b2fa9ff2efd73ff0c1433626e17c6004a5b319f92eca1bd4bfd9035f469b"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/lift-v#{version}/lift-v#{version}-linux-x86_64.tar.gz"
    sha256 "8a0ca3a9e48c7692c003b256b9bb09dfd4485fd1738ecfeeae279dba9053c826"
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
