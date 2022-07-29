class KotlinDebugAdapter < Formula
  desc "Kotlin/JVM debugging for any editor/IDE using the Debug Adapter Protocol"
  homepage "https://github.com/fwcd/kotlin-debug-adapter"
  url "https://github.com/fwcd/kotlin-debug-adapter/archive/refs/tags/0.4.3.tar.gz"
  sha256 "9ad4db7e8877ed73d0b14c682f8bb8c4aed62918e3d936f0eb368052e2de2a8d"
  license "MIT"

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "./gradlew", ":adapter:installDist"
  end

  test do
    system "true"
  end
end
