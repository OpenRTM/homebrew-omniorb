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
  url "https://versaweb.dl.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2"
  sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  license "GPL-2.1"

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORBpy[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.2.4/"
    sha256 cellar: :any, catalina: "63592f05f70e89f59c07f4170a304f7a071a2d95813af8104a0bbb1e5af98df3"
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb-ssl-py38"
  depends_on "python@3.8"

  def install
    args = %w[
      OPENSSL_CFLAGS=-I/usr/local/opt/openssl/include
      OEPNSSL_LIBS=-L/usr/local/opt/openssl/lib
      CFLAGS=-I/usr/local/opt/python@3.8/include
      LDFLAGS=-L/usr/local/opt/python@3.8/lib
      CC=gcc-4.9
      CXX=g++-4.9
      PYTHON=/usr/local/opt/python@3.8/bin/python3.8
    ]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-omniorb=/usr/local",
                          "--with-openssl=/usr/local/opt/openssl",
                          *args
    system "make", "-j", "4"
    system "make", "install"
  end

  test do
    system "#{bin}/omniidl", "-bpython", "-h"
  end
end
