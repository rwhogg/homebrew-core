class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.52.3.tar.gz"
  sha256 "ad07a6a5bda13b9447a5cc455058f3c9972871bb386c869249cb0d0b8cb036a7"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae392245869cf46c328a5e1947d93e5e7edb93b7e29cf466d560a0532dbf4891" => :catalina
    sha256 "5d00a1da9b94ef0d0418ad20d48a601e7a46e17ef9bae5df14d256d2a59d906b" => :mojave
    sha256 "d90cc67223debdb47bf00ba686c74b24ebac1ea9e4bc12636977d4eb0d57ae7b" => :high_sierra
    sha256 "0236d0cfd92301ec8c6b2053fd9e80914e09de3b0a97ef11edc2e5aa18122f49" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
