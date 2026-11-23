class Siwc < Formula
  desc "Native Sign in with ChatGPT credential manager"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.6"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-darwin-arm64.tar.gz"
    sha256 "b2466e23adf3e408a1f2fbdd3a89bbad14e19520dba46aa112d405715589e321"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-linux-x86_64.tar.gz"
    sha256 "89a0f8d881ff1e2530c5fe3edf2cfc8b7bc9be3e1cb83bf33cfdcb62a24631f4"
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
