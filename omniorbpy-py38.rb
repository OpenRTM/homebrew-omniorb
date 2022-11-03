#============================================================
# omniORBpy (for python3.8) formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.8.
# To use this formula/bottle, switch python3 into python 3.8.
# $ brew unlink python3 (unlink python 3.X != 3.8)
# $ brew link python@3.8
#============================================================
class OmniorbpyPy38 < Formula
  desc "IOR and naming service utilities for omniORBpy with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.0/omniORBpy-4.3.0.tar.bz2"
  sha256 "fffcfdfc34fd6e2fcc45d803d7d5db5bd4d188a747ff9f82b3684a753e001b4d"
  license "GPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORBpy[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.0/"
    sha256 cellar: :any, arm64_ventura: "6be4c8c960129e7e20cd5fc7c9214cf415aacbe84127e407651cecdee9970c52"
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb-ssl-py38"
  depends_on "python@3.8"

  def install
#    args = %w[
#      OPENSSL_CFLAGS=-I#{Formula["openssl@1.1"].opt_include}
#      OEPNSSL_LIBS=-L#{Formula["openssl@1.1"].opt_lib}
#      CFLAGS=-I#{Formula["python@3.8"].opt_inlcude}
#      LDFLAGS=-L#{Formula["python@3.8"].opt_lib}
#      CC=gcc-4.9
#      CXX=g++-4.9
#      PYTHON=#{Formula["python@3.8"].opt_bin}/python3.8
#    ]
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-omniorb=#{Formula["omniorb-ssl-py38"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      PYTHON=#{Formula["python@3.8"].opt_bin}/python3.8
    ]
    system "./configure", *args
    system "make", "-j", "4"
    system "make", "install"
  end

  test do
    system "#{bin}/omniidl", "-bpython", "-h"
  end
end
