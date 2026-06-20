class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.3.0"
  license "MIT"

  if OS.mac?
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "7182e520bc288fcf72e900bed10a66fd6b0ccd334184fe82b4f6e6f1c177be6d"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "bdbdf7cea19f1187d9cf054992947feb82988f906ac238fd14b36b78fbbd20ce"
  end

  def install
    bin.install "seq"
  end

  test do
    help = shell_output("#{bin}/seq --help")
    assert_match "skills-rank", help
    assert_match "skill-success-rank", help
    assert_match "skill-evidence", help
    assert_match "skill-blocks", help
    assert_match "artifact-search", help
    assert_match "skill-audit", help
    assert_match "tool-audit", help
    assert_match "memory-inventory", help
    assert_match "message-search", help
    assert_match "workdir-report", help
    assert_match "memory-provenance", help
    assert_match "memory-map", help
    assert_match "memory-history", help
    assert_match "plan-search", help
    assert_match "reply-latency", help
    assert_match "workflow-audit", help
    assert_match "message-audit", help
    assert_match "skill-cohort", help
    assert_match "tool-search", help
    assert_match "memory-extension-audit", help
    assert_match "token-window", help
    assert_match "goal-audit", help
    assert_match "adjudication-audit", help
    assert_match "workflow-overlap", help
    assert_match "resolve-churn-audit", help
    assert_match "review-compiler-audit", help
    assert_match "skill-decision-audit", help
    assert_match "skill-contract", help
    assert_match "skill-decision-receipt", help

    token_help = shell_output("#{bin}/seq token-usage --help")
    assert_match "--tz", token_help
    assert_match "--last", token_help
    assert_match "--summary", token_help
    assert_match "--audit", token_help

    token_cost_help = shell_output("#{bin}/seq token-cost --help")
    assert_match "--pricing", token_cost_help
    assert_match "--model", token_cost_help

    skill_audit_help = shell_output("#{bin}/seq skill-audit --help")
    assert_match "summary|mentions|trend|activation", skill_audit_help
    assert_match "--exclude-current", skill_audit_help
    assert_match "--last", skill_audit_help
    assert_match "summary|sessions", shell_output("#{bin}/seq skill-success-rank --help")
    skill_blocks_help = shell_output("#{bin}/seq skill-blocks --help")
    assert_match "blocks|body|term-counts|term-summary", skill_blocks_help
    assert_match "term-counts", skill_blocks_help
    assert_match "term-summary", skill_blocks_help
    assert_match "--term-group", skill_blocks_help
    assert_match "summary|rows|args|unresolved", shell_output("#{bin}/seq tool-audit --help")
    assert_match "categories|files|blocks|stage1|extensions", shell_output("#{bin}/seq memory-inventory --help")
    assert_match "--contains-any", shell_output("#{bin}/seq message-search --help")
    assert_match "summary|sessions", shell_output("#{bin}/seq workdir-report --help")
    artifact_search_help = shell_output("#{bin}/seq artifact-search --help")
    assert_match "--contains-any", artifact_search_help
    assert_match "summary|rows|sessions", shell_output("#{bin}/seq message-audit --help")
    skill_cohort_help = shell_output("#{bin}/seq skill-cohort --help")
    assert_match "summary|cohort|mentions", skill_cohort_help
    assert_match "--last", skill_cohort_help
    tool_search_help = shell_output("#{bin}/seq tool-search --help")
    assert_match "rows|summary|args", tool_search_help
    assert_match "--path", tool_search_help
    assert_match "--session-id", tool_search_help
    assert_match "--contains-any", tool_search_help
    assert_match "summary|rows", shell_output("#{bin}/seq memory-extension-audit --help")
    assert_match "--window-hours", shell_output("#{bin}/seq token-window --help")
    assert_match "review|resolve", shell_output("#{bin}/seq goal-audit --help")
    workflow_audit_help = shell_output("#{bin}/seq workflow-audit --help")
    assert_match "cohort-report", workflow_audit_help
    assert_match "term-summary", workflow_audit_help
    assert_match "--term-group", workflow_audit_help
    assert_match "--last", workflow_audit_help
    adjudication_help = shell_output("#{bin}/seq adjudication-audit --help")
    assert_match "summary|rows|report", adjudication_help
    assert_match "--include-root-equivalent", adjudication_help
    assert_match "--bundle-dir", adjudication_help

    resolve_churn_help = shell_output("#{bin}/seq resolve-churn-audit --help")
    assert_match "--since", resolve_churn_help
    assert_match "--until", resolve_churn_help
    assert_match "--repo", resolve_churn_help
    assert_match "markdown|json", resolve_churn_help

    review_compiler_help = shell_output("#{bin}/seq review-compiler-audit --help")
    assert_match "--since", review_compiler_help
    assert_match "--until", review_compiler_help
    assert_match "--repo", review_compiler_help
    assert_match "--protocol", review_compiler_help
    assert_match "c3-mrpc", review_compiler_help
    assert_match "mbk", review_compiler_help
    assert_match "markdown|json", review_compiler_help
  end
end
