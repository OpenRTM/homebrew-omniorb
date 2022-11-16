#============================================================
# omniORBpy (for python3.11) formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.11.
# To use this formula/bottle, switch python3 into python 3.11.
# $ brew unlink python3 (unlink python 3.X != 3.11)
# $ brew link python@3.11
#============================================================
class OmniorbpyPy311 < Formula
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
    sha256 cellar: :any, arm64_ventura: "9693aceba645dd7668acc053d0eb4c737487689c7bdbe6606860de5c308bd5de"
    sha256 cellar: :any, monterey: "13b589070e7304911cdc9296487b56bec0bca41cf638f18090ab096efa325d98"
  end

  depends_on "pkg-config" => :build
  depends_on "omniorb-ssl-py311"
  depends_on "python@3.11"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-omniorb=#{Formula["omniorb-ssl-py311"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      PYTHON=#{Formula["python@3.11"].opt_bin}/python3.11
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
