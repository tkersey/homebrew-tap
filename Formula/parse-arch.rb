class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "34bff12834e47a93a95a3de591cc87c919e988a745190d6ff05f80829934e61c"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "3ae8f6f7bb8d6bb349a8043065b4ca56fc6e75552b108f4e60a74e4b2b3a8ddc"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "parse-arch"
  end

  test do
    require "json"

    assert_equal version.to_s, shell_output("#{bin}/parse-arch --version").strip

    parse_help = shell_output("#{bin}/parse-arch --help 2>&1")
    assert_match "Infer repository architecture signals", parse_help
    assert_match "collect", parse_help
    refute_match "uv run", parse_help

    repo = testpath/"repo"
    repo.mkpath
    (repo/"README.md").write("# Tiny plugin repo\n")
    (repo/"codex").mkpath
    (repo/"codex/config.toml").write("[hooks]\n")

    payload = JSON.parse(shell_output("#{bin}/parse-arch collect #{repo} --json"))
    assert_equal "thin_repo_wide", payload.fetch("read_depth_verdict")
    assert_match "repo_kind_hints", payload.fetch("thin_signal_classes").join("\n")
    assert_match "codex", payload.fetch("suggested_focus_paths").join("\n")
    assert_match "Rerun collect", payload.fetch("followup_hint")
  end
end
