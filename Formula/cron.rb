class Cron < Formula
  desc "Zig CLI for Codex automation schedule management"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.5"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-darwin-arm64.tar.gz"
    sha256 "659f59b2aa964417689ea423d8ee12c5f042ac6acd104ed1c56ecbe5f69d9344"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-linux-x86_64.tar.gz"
    sha256 "e919c9c9b573d71626a0d403a08dc94fb90419d1730db3f56f35081410301a37"
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
    assert_match "cron.zig", cron_help
    refute_match "uv run python", cron_help
  end
end
