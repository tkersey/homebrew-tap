class Siwc < Formula
  desc "Native Sign in with ChatGPT credential manager"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.2"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-darwin-arm64.tar.gz"
    sha256 "29ab123b106d6d7f8eed749bb46accb23a4808aed5f051eb78fe2ade55238222"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/siwc-v#{version}/siwc-v#{version}-linux-x86_64.tar.gz"
    sha256 "66560f71bc51f96343a7d7f485487b8721d48a803d1a08a01b25304989ab7946"
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
