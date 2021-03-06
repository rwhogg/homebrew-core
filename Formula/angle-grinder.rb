class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.14.1.tar.gz"
  sha256 "32ee1ae9102f81b6d6a3c0865c42e2c747595804d5b8689a2e6a1e39ed0cd886"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f395c2d4997cd855ed3a8dc2ddf978b04fb59c9868509f5b9b2b02c2ac13aa7c" => :catalina
    sha256 "dfa85c12e520c3d57206f376cce51a7e52b4f486d586d47fabcefa6508b06514" => :mojave
    sha256 "6025f925c0d03b7bb6b020e7c4ea859eed3c6244bd9065d0e78c34ec140b3361" => :high_sierra
    sha256 "d50f41cd549c7c187dc7eb1a03e9da76e1f2350459ffe76becd2c7f6296af858" => :x86_64_linux
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
