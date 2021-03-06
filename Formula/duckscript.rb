class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.6.6.tar.gz"
  sha256 "43de949234254a64ca7a505e99937034e36db80da7a8362604bd0a376cc066eb"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "edf89095b113c073b4c4b5b031ea0681b494b6a557b2182f3df45ea86d40092f" => :catalina
    sha256 "3932ca839bc4ba481bf8bf450af1224fc12d9d05f1bb150e274a1abb2ef47198" => :mojave
    sha256 "927aaed71744c78f2fb05288f76c2648357efb6752335f82f0e151ab5595418a" => :high_sierra
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}    
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
