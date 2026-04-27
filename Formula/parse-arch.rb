class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "435b869c806b87fa28f429d717beafce97b1813ed902b6c04a03b5fa497fbd17"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "d10e9826a96aa045d81d43e03a225365322782e7bf2e16f43d151f0556a8902d"
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
