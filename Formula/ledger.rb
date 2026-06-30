class Ledger < Formula
  desc "Zig CLI for repo-local durable source-memory ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "cc294ab888145ef708c562387f5e237e3e225fb1a3ccc4517bf6b695d466a1e3"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "091f5e09f5668f5953a51c71e6920bd082f77dec3dbdec6812391c5cf76f1697"
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
    assert_match "Durable source-memory ledger.", help
    assert_match "capture", help
    assert_match "map", help
    assert_match "migrate", help
    assert_match "--source SOURCE", help
    assert_match "recall", help
    assert_match "status", help
    assert_match "export", help

    system bin/"ledger", "init"
    assert_path_exists testpath/".ledger/negative-ledger/events.jsonl"
    assert_match "\"ok\":true", shell_output("#{bin}/ledger doctor")

    capture_help = shell_output("#{bin}/ledger capture --source learnings --help 2>&1")
    assert_match "Append a structured learning event to repo-local .ledger/learnings/events.jsonl.", capture_help
    assert_match "synesthesia", shell_output("#{bin}/ledger --help")
    assert_match "\"status\":\"missing\"", shell_output("#{bin}/ledger doctor --source synesthesia")

    system bin/"ledger", "capture", "--source", "learnings",
      "--status", "do_more",
      "--learning",
      "When tap tests install ledger, use ledger capture --source learnings because formula tests catch regressions.",
      "--evidence", "command: brew test ledger writes .ledger/learnings/events.jsonl",
      "--application", "Keep ledger --source learnings covered in the formula test.",
      "--tag", "homebrew",
      "--allow-temp-path"
    assert_path_exists testpath/".ledger/learnings/events.jsonl"
    recent = shell_output("#{bin}/ledger recent --source learnings --limit 1")
    assert_match "tap tests install ledger", recent
  end
end
