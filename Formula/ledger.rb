class Ledger < Formula
  desc "Zig CLI for repo-local durable negative-evidence ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "d78e70d0cc36e5fa88f0573928333663a6b69a8f3334cd2899f8a89024bd2284"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "e1b1c5025ff1c71ec2e6dcae5706dab9bd04c102db72b524fd9a6d977981fbc8"
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
