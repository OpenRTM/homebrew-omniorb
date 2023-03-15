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
    rebuild 1
    sha256 cellar: :any, arm64_ventura: "7a9f0617b6fe449fa8cd4c2ae194c3f67620685a2b2acbd7f2b9daaaf8149c77"
    rebuild 2
    sha256 cellar: :any, monterey: "9d08baa7034bdf90ad4905048d6308ba422ecc17652cebcec8dfa5acd0b507a6"
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb-ssl-py38"
  depends_on "python@3.8"

  def install
    ENV["PYTHON"] = python3 = which("python3.8")
    xy = Language::Python.major_minor_version python3
    xy_short = xy.to_s.sub('.', '')
    inreplace "configure",
      /am_cv_python_version=`.*`/,
      "am_cv_python_version='#{xy}'"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-omniorb=#{Formula["omniorb-ssl-py#{xy_short}"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]
    system "./configure", *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bpython", "-h"
  end
end
