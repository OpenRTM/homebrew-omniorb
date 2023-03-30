#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.9
# To use this formula/bottle, switch python 3.x to python 3.9.
# $ brew unlink python3.x (unlink current python)
# $ brew link python@3.9 omniorb-ssl-y39
#============================================================
class OmniorbSslPy39 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.1/omniORB-4.3.1.tar.bz2"
  sha256 "0f42bc3eb737cae680dafa85b3ae3958e9f56a37912c5fb6b875933f8fb7390d"

  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.1/"
    sha256 cellar: :any, arm64_ventura: "10abe7cc4d99fc5b48b7b19291e14d5cd154e77d8d2d76f048d29630768c729a"
    sha256 cellar: :any, monterey: "01bd16399388ec8c6591cc53696b8c2930b120d1ff3603fdd0514e6538901ac3"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.1/omniORBpy-4.3.1.tar.bz2"
    sha256 "9da34af0a0230ea0de793be73ee66dc8a87e732fec80437ea91222e272d01be2"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.9")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = %W[
      --prefix=#{prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]
    system "./configure", *args
    system "make", "-j", "4"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      args  = %W[
        --disable-debug
        --disable-dependency-tracking
        --disable-silent-rules
        --prefix=#{prefix}
        --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
      ]
      system "./configure", *args
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
