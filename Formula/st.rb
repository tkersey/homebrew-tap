class St < Formula
  desc "Zig CLI for dependency-aware durable task plans"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.1.8"
  license "MIT"

  if OS.mac?
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-darwin-arm64.tar.gz"
    sha256 "94d489ae3dc485752301d686386f9bfe92c34a5dcf7657cc5475655e287e396d"
  else
    url "https://github.com/tkersey/skills-zig/releases/download/st-v#{version}/st-v#{version}-linux-x86_64.tar.gz"
    sha256 "249dd1ed32f48775c69b5ee79e30e107c3eaa4b3efe5231be4d738a5e4cee407"
  end

  on_macos do
    depends_on arch: :arm64
  end

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    bin.install "st"
  end

  test do
    help = shell_output("#{bin}/st --help")
    assert_match "Manage dependency-aware JSONL v3 plan state.", help
    assert_match "import-orchplan", help
    assert_match "import-update-plan", help
    assert_match "import-mesh-results", help
  end
end
