class Siwc < Formula
  desc "Native Sign in with ChatGPT credential manager"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.3"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-darwin-arm64.tar.gz"
    sha256 "a115948682ce1f94760820afd7382f20ffd1592828af2699169a0d6f9208de8f"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-linux-x86_64.tar.gz"
    sha256 "6b4f9dca98d652952c78f23793fd495d532718f1b31d4d7cd7d8e32071f3bc87"
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
