class Seq < Formula
  desc "Zig CLI for mining Codex session and memory artifacts"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.5"
  license "MIT"

  on_macos do
    depends_on arch: :arm64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-darwin-arm64.tar.gz"
    sha256 "c9bc444e216ec7a3335cb4ba9c9ad382e8243de2bc58b91945f2614dc9f2e59c"
  end

  on_linux do
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/seq-v#{version}/seq-v#{version}-linux-x86_64.tar.gz"
    sha256 "8152af84b3658cee274dc448ab8183a648e05bc775144fa2ae9667b51303e5a6"
  end

  def install
    bin.install "seq"
  end

  test do
    assert_match "skills-rank", shell_output("#{bin}/seq --help")
  end
end
