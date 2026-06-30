class Ledger < Formula
  desc "Zig CLI for repo-local durable negative-evidence ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.5"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "e9eb77605bb919e6bd1101aefcfdc94acf83e04634da676c75aa930e639cee7d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "8aa5cf6c11d54481b70d4b074c4ab96e7175e8d9eddd68751b72e88737ce49d8"
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
