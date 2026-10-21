class Siwc < Formula
  desc "Native Sign in with ChatGPT credential manager"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.0"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-darwin-arm64.tar.gz"
    sha256 "1d2376e698d8e0495a4bede2d7cb9e320738af85c83ccad57ab6df872d17a62f"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-linux-x86_64.tar.gz"
    sha256 "72a85b6f38ef8d71f2157792ee3e1470d69e863cf80ffe9709bd0180a4a6eae1"
  end

  on_macos do
    depends_on arch: :arm64
    depends_on macos: :sequoia
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "siwc"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/siwc --version").strip
    help = shell_output("#{bin}/siwc --help")
    assert_match "siwc login", help
    assert_match "siwc credential", help
    assert_match "siwc exec", help

    auth_dir = testpath.realpath/"auth"
    output = shell_output(
      "#{bin}/siwc accounts --app homebrew-test --auth-dir #{auth_dir} --json 2>&1", 1
    )
    assert_match "FileNotFound", output
    refute_path_exists auth_dir
  end
end
