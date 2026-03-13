class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.2"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "f7b2694cad2c8749e78d0ae264df6d7d7eb7a9df899b5ac49474e62aa0c400ec"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "dc9b1ffd914df400901f4c66102618b82843f0323d92c28dad152c01be54269b"
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
