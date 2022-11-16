#============================================================
# omniORBpy (for python3.10) formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.10.
# To use this formula/bottle, switch python3 into python 3.10.
# $ brew unlink python3 (unlink python 3.X != 3.10)
# $ brew link python@3.10
#============================================================
class OmniorbpyPy310 < Formula
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
    sha256 cellar: :any, arm64_ventura: "9a913e4b9b7d496b87b8ebf050c8536ab292bd55df37ac058ee95f784969ee91"
    sha256 cellar: :any, monterey: "c5f5b9c516dee26b9f9a43c64fb418a53326403233a3e7bc861d316d0493dea6"
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb-ssl-py310"
  depends_on "python@3.10"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-omniorb=#{Formula["omniorb-ssl-py310"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      PYTHON=#{Formula["python@3.10"].opt_bin}/python3.10
    ]
    xy = "310"
    inreplace "configure",
      /am_cv_python_version=`.*`/,
      "am_cv_python_version='#{xy}'"
    system "./configure", *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/omniidl", "-bpython", "-h"
  end
end
