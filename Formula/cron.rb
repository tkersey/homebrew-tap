class Cron < Formula
  desc "Zig CLI for Codex automation schedule management"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-darwin-arm64.tar.gz"
    sha256 "abbfb191cb07da663831a30a35f8b0539fb76f2b2e513897d3702927e9067ab3"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-linux-x86_64.tar.gz"
    sha256 "7f30c2bdec097f9b95e9ec135412103e6aae752a3e03a7216dc42bd6d1163908"
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
