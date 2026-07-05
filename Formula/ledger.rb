class Ledger < Formula
  desc "Zig CLI for repo-local durable source-memory ledgers"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.4"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-darwin-arm64.tar.gz"
    sha256 "32787e82df539939709a761a451e03f2ad703b502f4538257a63032a986d8984"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/ledger-v#{version}/ledger-v#{version}-linux-x86_64.tar.gz"
    sha256 "7ae7a746db4e2e7a94823a52d530626d8752f4f4e60b2fc4528d213aba98f0c0"
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

    (testpath/"synesthesia.json").write <<~JSON
      {"operation":"assert","authority":"explicit-user-endorsement","summary":"Endorse long corridor.","scope":{"kind":"task-family","repo":null,"paths":[]},"source_refs":[{"kind":"user","ref":"tap-test","summary":"User endorsed long corridor mapping."}],"related_ids":[],"supersedes_id":null,"payload":{"sensory_phrase":"long corridor","engineering_translation":"serialized waits","activation_boundary":"latency work","non_activation_boundary":"syntax","verification":"name the wait"}}
    JSON
    system bin/"ledger", "capture", "--source", "synesthesia",
      "--kind", "mapping-endorsement", "--json", testpath/"synesthesia.json"
    assert_path_exists testpath/".ledger/synesthesia/events.jsonl"
    synesthesia_recent = shell_output("#{bin}/ledger recent --source synesthesia --limit 1")
    assert_match "long corridor", synesthesia_recent
    synesthesia_id = synesthesia_recent[/SYN-[^ ]+/]
    assert_match "SYN-", synesthesia_id
    synesthesia_export = shell_output(
      "#{bin}/ledger export --source synesthesia --format memory-note --id #{synesthesia_id}",
    )
    assert_match "\"operation\":\"assert\"", synesthesia_export
    refute_match "logical_kind", synesthesia_export

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
