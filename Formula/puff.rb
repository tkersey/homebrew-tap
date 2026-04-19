class Puff < Formula
  desc "Zig CLI for Codex cloud task orchestration"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.7"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-darwin-arm64.tar.gz"
    sha256 "856fb1d7ba06d6f66a7917c82607053910558dc6bb72e245c80c1a6b0126997a"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/puff-v#{version}/puff-v#{version}-linux-x86_64.tar.gz"
    sha256 "5aeb1694a451601fd4ccb02be77e5afa7e568ae010cb6a7c02f8bc5a6a07f43f"
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
