class Typesafe < Formula
  desc "Document review triage with the TypeSafe API"
  homepage "https://github.com/tkersey/skills-zig"
  version "0.2.1"

  if OS.mac?
    depends_on arch: :arm64
    depends_on macos: :sequoia
    url "https://github.com/tkersey/skills-zig/releases/download/typesafe-v#{version}/typesafe-v#{version}-darwin-arm64.tar.gz"
    sha256 "6f9caa9d8ae4ccdc86921df64eb5e26e78332c8028a5f952285556ee326b2435"
  else
    depends_on arch: :x86_64
    url "https://github.com/tkersey/skills-zig/releases/download/typesafe-v#{version}/typesafe-v#{version}-linux-x86_64.tar.gz"
    sha256 "010cec9ab14cddb50827816cb713f4267f71d5ff672e9fe3cff286c8c460ec1a"
  end

  def install
    bin.install "typesafe"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/typesafe --version").strip
    assert_match "Evaluate UTF-8 text or Markdown documents with TypeSafe.",
                 shell_output("#{bin}/typesafe --help")
  end
end
