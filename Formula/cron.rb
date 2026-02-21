class Cron < Formula
  desc "Zig CLI for Codex automation schedule management"
  homepage "https://github.com/tkersey/skills-zig"
  url "https://github.com/tkersey/skills-zig.git",
      using: :git,
      tag:   "cron-v0.1.0"
  version "0.1.0"
  license "MIT"

  depends_on "zig" => :build

  def install
    bin.mkpath
    system "zig", "build", "build-cron", "-Doptimize=ReleaseFast"
    bin.install "zig-out/bin/cron"
  end

  test do
    cron_help = shell_output("#{bin}/cron --help 2>&1")
    assert_match "cron.zig", cron_help
  end
end
