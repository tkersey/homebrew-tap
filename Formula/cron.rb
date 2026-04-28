class Cron < Formula
  desc "Zig CLI for Codex automation schedule management"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.9"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-darwin-arm64.tar.gz"
    sha256 "753ba63f9a3a592818df13c4e2cac6712224386aa6b8267dd07ead0737f1e8db"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-linux-x86_64.tar.gz"
    sha256 "002ae2b6fd3ec08567b3242c2fadf6ed26bbcdad04fb0a83522ddaec0f973d3e"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "cron"
  end

  test do
    cron_help = shell_output("#{bin}/cron --help 2>&1")
    assert_match "Manage Codex automations with native Zig runtime", cron_help
    refute_match "uv run python", cron_help
  end
end
