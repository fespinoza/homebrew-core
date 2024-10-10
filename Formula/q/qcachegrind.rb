class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://apps.kde.org/kcachegrind/"
  url "https://download.kde.org/stable/release-service/24.08.2/src/kcachegrind-24.08.2.tar.xz"
  sha256 "87ae02a6a9cdaed5cf9526ed405b59bacc5d6871715f91d0c22d222d5c8475f4"
  license "GPL-2.0-or-later"
  head "https://invent.kde.org/sdk/kcachegrind.git", branch: "master"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "658af69e9decc7fd6c3ad4366e1b69133baf3da4857d3b625eac20d6a42d3360"
    sha256 cellar: :any,                 arm64_ventura:  "60e4864fc5434bffb9b6f9a39060ea10d1309336345891395ba38109969c656d"
    sha256 cellar: :any,                 arm64_monterey: "9eaf947a26c5a68c530d9cbee62b2b9330c5bec595f2f1baf38a921d0cc1fcf1"
    sha256 cellar: :any,                 sonoma:         "416bc682c84d030078705ee7f981ac972b15b02fa3fab2192ff85fa4efc586b1"
    sha256 cellar: :any,                 ventura:        "c13843b12dfb41b38e481ccebc14895fff2e199cc9eb7fdf50dc8e91022713aa"
    sha256 cellar: :any,                 monterey:       "d938241d2260ff266f795fe81be7871a35afe2d64a675d417f61f641a2071715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce9980a4dbec26dce80d1621b91aa353c7c253273226966efc51207f64dba680"
  end

  depends_on "graphviz"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    qt = Formula["qt"]
    system qt.opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
