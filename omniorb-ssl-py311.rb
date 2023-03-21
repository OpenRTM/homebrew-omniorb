#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.11
# To use this formula/bottle, switch python 3.x to python 3.11.
# $ brew unlink python3.x (unlink current python)
# $ brew link python@3.11 omniorb-ssl-y311
#============================================================
class OmniorbSslPy311 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.0/omniORB-4.3.0.tar.bz2"
  sha256 "976045a2341f4e9a85068b21f4bd928993292933eeecefea372db09e0219eadd"

  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.0/"
    sha256 cellar: :any, arm64_ventura: "7c17d095fc4ebe4555f8643f44d7ea529cad1499b710d44326c227e8011ebd08"
    sha256 cellar: :any, monterey: "417dc840efcb70e39ae66d57d737a607f81be6be73f51bf232ddec399fde66e1"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.0/omniORBpy-4.3.0.tar.bz2"
    sha256 "fffcfdfc34fd6e2fcc45d803d7d5db5bd4d188a747ff9f82b3684a753e001b4d"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.11")
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
