class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.1"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "bffce652cec16c8eeaec6b3217dcaba5597d41b0db90ed4044065f76176488e4"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "14e9515ef12c05f780cb50aa13c606e05ef415a4076fb06f5ea1b81e0a7e8210"
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
