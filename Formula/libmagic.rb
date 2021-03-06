class Libmagic < Formula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.39.tar.gz"
  sha256 "f05d286a76d9556243d0cb05814929c2ecf3a5ba07963f8f70bfaaa70517fad1"

  bottle do
    sha256 "90b17cb74e853804227abdd32c6810ff535fb98e8862f946c49860b697faece0" => :catalina
    sha256 "f32eb14fbef470d28a041ddefec932e8d96870b4a13dbac3f61d8c6de6e50f29" => :mojave
    sha256 "110d2db0b588dc5a379124d024b228e8ee8aae58c95a6a0510e68dc36426a86a" => :high_sierra
    sha256 "fa24ab8447b58ec9cc2e1313ddbf3ccb75e626d2b0c63edf9d06a2e7dc65911d" => :x86_64_linux
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share/"misc/magic").install Dir["magic/Magdir/*"]

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>

      #include <magic.h>

      int main(int argc, char **argv) {
          magic_t cookie = magic_open(MAGIC_MIME_TYPE);
          assert(cookie != NULL);
          assert(magic_load(cookie, NULL) == 0);
          // Prints the MIME type of the file referenced by the first argument.
          puts(magic_file(cookie, argv[1]));
      }
    EOS
    if OS.mac?
      system ENV.cc, "-I#{include}", "-L#{lib}", "-lmagic", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmagic", "-o", "test"
    end
    cp test_fixtures("test.png"), "test.png"
    assert_equal "image/png", shell_output("./test test.png").chomp
  end
end
