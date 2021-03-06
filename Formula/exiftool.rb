class Exiftool < Formula
  desc "Perl lib for reading and writing EXIF metadata"
  homepage "https://exiftool.org"
  # Ensure release is tagged production before submitting.
  # https://exiftool.org/history.html
  url "https://exiftool.org/Image-ExifTool-12.00.tar.gz"
  sha256 "d0792cc94ab58a8b3d81b18ccdb8b43848c8fb901b5b7caecdcb68689c6c855a"

  bottle do
    cellar :any_skip_relocation
    sha256 "94e6bea5ede141fec762e7c7e06e1434d84b90695388cf269787ae77ece01cda" => :catalina
    sha256 "94e6bea5ede141fec762e7c7e06e1434d84b90695388cf269787ae77ece01cda" => :mojave
    sha256 "b7aa0c2aa1d2e0e1d2eab87c16c180153f62715e780f31a83f2f081d8f91b620" => :high_sierra
    sha256 "3300fc72a42101920d9ccef59fb6e70f9298db3141ecd211cfdeb14cd7801c4b" => :x86_64_linux
  end

  def install
    # replace the hard-coded path to the lib directory
    inreplace "exiftool", "$1/lib", libexec/"lib"

    system "perl", "Makefile.PL"
    system "make", "all"
    libexec.install "lib"
    bin.install "exiftool"
    doc.install Dir["html/*"]
    man1.install "blib/man1/exiftool.1#{OS.mac? ? "" : "p"}"
    man3.install Dir["blib/man3/*"]
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match %r{MIME Type\s+: image/jpeg},
                 shell_output("#{bin}/exiftool #{test_image}")
  end
end
