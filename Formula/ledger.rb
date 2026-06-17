class Ledger < Formula
  desc "Zig CLI for repo-local durable negative-evidence ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "88b147bad6c336287f60c8687e28db6f41283c70c09b3dadfc31bb0903170614"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "539d6e7d0d8e87c3abcca87bb8a72bcb73de762ba5bfa6f90105b7724a69e63f"
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
    assert_match "\"status\":\"ok\"", shell_output("#{bin}/ledger doctor")
  end
end
