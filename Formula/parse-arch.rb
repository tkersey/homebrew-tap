class ParseArch < Formula
  desc "Zig CLI for repository architecture signal collection"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.3"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-darwin-arm64.tar.gz"
    sha256 "9d49451d817a269c9755d78241e6da7c7eac7ac6e4148a8c2a70271660cbbfa6"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/parse-arch-v#{version}/parse-arch-v#{version}-linux-x86_64.tar.gz"
    sha256 "e19b737f7431325e6aa6254addfa2a29f64ff3157689172a756a883e752740fd"
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
