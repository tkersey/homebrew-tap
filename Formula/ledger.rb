class Ledger < Formula
  desc "Zig CLI for repo-local durable negative-evidence ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "09dee31b862f51d4d2ccc82c70cbc0ef5d5e0ae56dd9f37c3dc85e29f64c2847"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "159a2454b257759c1c30f6573b81e1619d7803c0e63069cb02c1942f82ed9147"
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

    system bin/"ledger", "init"
    assert_path_exists testpath/".ledger/negative-ledger.jsonl"
    assert_match "\"ok\":true", shell_output("#{bin}/ledger doctor")
  end
end
