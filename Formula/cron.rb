class Cron < Formula
  desc "Zig CLI for Codex automation schedule management"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.12"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-darwin-arm64.tar.gz"
    sha256 "3fe4e54fec1574d24723935498e70685453611a7b34ed7d72dde57c09d337e9e"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-linux-x86_64.tar.gz"
    sha256 "72adebb782b5c4401d171c0ab1ed8ae1b2669eb2001f56d63be2569c7c65e093"
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
