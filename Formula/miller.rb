class Miller < Formula
  desc "Like sed, awk, cut, join & sort for name-indexed data such as CSV"
  homepage "https://github.com/johnkerl/miller"
  url "https://github.com/johnkerl/miller/releases/download/v5.9.0/mlr-5.9.0.tar.gz"
  sha256 "06d995667f48a59818979c1ca6d4192f784796f8612550e1a2b24d63a0802856"
  license "BSD-2-Clause"
  head "https://github.com/johnkerl/miller.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "262035972c936468b4ae38126c7cb92282c8eee992b5e1edbdf81e0a3cf26d83" => :catalina
    sha256 "019b18a5ebb5c5214ea920d214990ed686d26bfcc331293f5d936b6f1b26249f" => :mojave
    sha256 "abd84eef3044f3c7ec52ae14a3df5e2456abcd40fc4d211fa23f87460d0c60a7" => :high_sierra
    sha256 "4ce289a442ac567bb13f0da9819deafa6d5d82077d80e598fe923288dad55038" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build

  def install
    # Profiling build fails with Xcode 11, remove it
    inreplace "c/Makefile.am", /noinst_PROGRAMS=\s*mlrg/, ""
    system "autoreconf", "-fvi"

    system "./configure", "--prefix=#{prefix}", "--disable-silent-rules",
                          "--disable-dependency-tracking"
    system "make"
    # Time zone related tests fail. Reported upstream https://github.com/johnkerl/miller/issues/237
    system "make", "check" if !OS.mac? && ENV["CI"]
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
      4,5,6
    EOS
    output = pipe_output("#{bin}/mlr --csvlite cut -f a test.csv")
    assert_match /a\n1\n4\n/, output
  end
end
