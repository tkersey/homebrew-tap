class KotlinDebugAdapter < Formula
  desc "Kotlin/JVM debugging for any editor/IDE using the Debug Adapter Protocol"
  homepage "https://github.com/fwcd/kotlin-debug-adapter"
  url "https://github.com/fwcd/kotlin-debug-adapter/archive/refs/tags/0.4.3.tar.gz"
  sha256 "9ad4db7e8877ed73d0b14c682f8bb8c4aed62918e3d936f0eb368052e2de2a8d"
  license "MIT"

  bottle do
    root_url "https://github.com/tkersey/homebrew-tap/releases/download/kotlin-debug-adapter-0.4.3"
    sha256 cellar: :any_skip_relocation, big_sur:      "a6ff3a918dbcb0f128e0003063f3e1e9dccb5c26e965c563112921385308ea1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1bf9dfc572ce0eba73a76067d9fba26a7320242260cec797adca691464618e87"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    #  Remove Windows files
    rm "gradlew.bat"

    system "gradle", ":adapter:installDist"

    libexec.install Dir["adapter/build/install/adapter/*"]

    (bin/"kotlin-debug-adapter").write_env_script libexec/"bin/kotlin-debug-adapter",
      Language::Java.overridable_java_home_env
  end

  test do
    output = pipe_output("#{bin}/kotlin-debug-adapter", "", 0)

    assert_match(/^Content-Length: \d+/i, output)
  end
end
