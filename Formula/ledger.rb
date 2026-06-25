class Ledger < Formula
  desc "Zig CLI for repo-local durable negative-evidence ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "3c8bf71d1f006c74afde07ba1011bd348292cece03d174f0f6b3ce7b02a8212f"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "b4f83689e517cacfe20402c098f63d29db7739bf28e9fb4d130f18ed2d6e6985"
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
    assert_match "status", help
    assert_match "export", help

    system bin/"ledger", "init"
    assert_path_exists testpath/".ledger/negative-ledger.jsonl"
    assert_match "\"ok\":true", shell_output("#{bin}/ledger doctor")
  end
end
