class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.4"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "c496b3836b5555a3fee77821a2be2e37275889ab1d597999150c7bd951a86689"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "380246365c545901d7e34ececba4c96b629d6a991e555edd6108e3287e651c05"
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
    assert_match "Infer repository architecture signals", parse_help
    assert_match "collect", parse_help
    refute_match "uv run", parse_help
  end
end
