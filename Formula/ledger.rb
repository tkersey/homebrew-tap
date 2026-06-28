class Ledger < Formula
  desc "Zig CLI for repo-local durable negative-evidence ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.3"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "f6d88b9a196fdf5ec6ebcac18e2797b2a1d37ddb1f49888f4a6b4ea3efa7b0a2"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "feb29a996ff93ab9c13667a1eeeba0eb37e23954bf1ca1d9ce41406bc235c8a3"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "ledger"
  end

  test do
    version_output = shell_output("#{bin}/ledger --version")
    assert_match version.to_s, version_output

    help = shell_output("#{bin}/ledger --help")
    assert_match "Durable negative-evidence ledger.", help
    assert_match "capture", help
    assert_match "map", help
    assert_match "migrate", help
    assert_match "status", help
    assert_match "export", help

    system bin/"ledger", "init"
    assert_path_exists testpath/".ledger/negative-ledger/events.jsonl"
    assert_match "\"ok\":true", shell_output("#{bin}/ledger doctor")
  end
end
