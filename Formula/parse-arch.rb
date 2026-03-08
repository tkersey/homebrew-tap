class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "f0100b543778e03b251acb87b8e7088221be490b217bc9a81ea6398fc5f7ca34"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "dbd61996798dd17a6f7db5a013880b2a9f72d09a6747af502afad38a63ffd994"
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
    parse_help = shell_output("#{bin}/parse-arch --help 2>&1")
    assert_match "parse_arch.zig", parse_help
    refute_match "uv run", parse_help
  end
end
