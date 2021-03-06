class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://mafft.cbrc.jp/alignment/software/mafft-7.471-with-extensions-src.tgz"
  sha256 "2c4993e9ebdaf4dcc6ea2b0daf30f58cbbe98fdba3e2cfcb46145bb2c62e94ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "47030809ef8372782fbf5770b2b95057f31bcbf81ead53cb06cb09e2ecbd2f87" => :catalina
    sha256 "f7820f8386beaa0b0bfcfccc75bea1563d3b5947e32a0aba5051edb621491026" => :mojave
    sha256 "a194f9f065024b846417688c2da31c22c058598880c4fb8ef5369e10299ecf2f" => :high_sierra
    sha256 "bc830e6712ff14ac8fc49e3ad7a7a207fd070a676ee2d4dee71079781601b9a2" => :x86_64_linux
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
