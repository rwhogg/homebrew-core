class Re2c < Formula
  desc "Generate C-based recognizers from regular expressions"
  homepage "https://re2c.org"
  url "https://github.com/skvadrik/re2c/releases/download/2.0.2/re2c-2.0.2.tar.xz"
  sha256 "6cddbb558dbfd697a729cb4fd3f095524480283b89911ca5221835d8a67ae5e0"
  license :public_domain

  bottle do
    sha256 "322bebea8b7ef36ba9fa67f8eb244720e703e3caa61c4cb0c3f69233844a7249" => :catalina
    sha256 "c4e54f2eebcc3bf581d8b0a794041f6cbbbdc0148856d2061069396412fb080f" => :mojave
    sha256 "070dcf3fdca558cb8aac21bc3db638faba8aaadcacd199f459a4bef743d87ecd" => :high_sierra
    sha256 "e403b9790a1875ba0fa855317861edf3e995da7475cf521514dc7dd61de958ae" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      unsigned int stou (const char * s)
      {
      #   define YYCTYPE char
          const YYCTYPE * YYCURSOR = s;
          unsigned int result = 0;

          for (;;)
          {
              /*!re2c
                  re2c:yyfill:enable = 0;

                  "\x00" { return result; }
                  [0-9]  { result = result * 10 + c; continue; }
              */
          }
      }
    EOS
    system bin/"re2c", "-is", testpath/"test.c"
  end
end
