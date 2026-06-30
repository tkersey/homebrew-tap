class Cron < Formula
  desc "Zig CLI for Codex automation schedule management"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.13"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-darwin-arm64.tar.gz"
    sha256 "5e813a6503d627f16312078e0ba1258e5a609c042abdce90ccda0124a1700018"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/cron-v#{version}/cron-v#{version}-linux-x86_64.tar.gz"
    sha256 "ebb181829836f914a785bb9c3f9a4df1361674938ca67679e1e1cca9f151c4c9"
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
