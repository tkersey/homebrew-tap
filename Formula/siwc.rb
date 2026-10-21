class Siwc < Formula
  desc "Native Sign in with ChatGPT credential manager"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.1"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-darwin-arm64.tar.gz"
    sha256 "fc2d3896050f676a171c59cbe2215c4e37a02cc5a701a8887c0460be7701b422"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-linux-x86_64.tar.gz"
    sha256 "0661d6e2d83b344d56aff8c587dae480d2c281ad7700d4c1e4df5a189cb4fd8e"
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
