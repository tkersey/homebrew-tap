class Puff < Formula
  desc "Zig CLI for Codex cloud task orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.9"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-darwin-arm64.tar.gz"
    sha256 "f33b822361675dc3b3bed8073fbb43a6b6388e9bbf0a6a2e993c66466f6b8b45"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-linux-x86_64.tar.gz"
    sha256 "c798101eda94c78c45fbd8f5cefc2a95867607488c6af9cb1cba3c43d97402f5"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "puff"
  end

  test do
    puff_help = shell_output("#{bin}/puff --help 2>&1")
    assert_match "Delegates non-help invocations to:", puff_help
    assert_match "Version:", puff_help
  end
end
