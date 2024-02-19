#============================================================
# omniORB formula for HomeBrew
#
# Author: Noriaki Ando <Noriaki.Ando@gmail.com>
# GitHub: https://github.com/OpenRTM/homebrew-omniorb
#
# This is the formula for omniORBpy on python3.11
# To use this formula/bottle, switch python 3.x to python 3.11.
# $ brew unlink python3.x (unlink current python)
# $ brew link python@3.11 omniorb-ssl-y310
#============================================================
class OmniorbSslPy311 < Formula
  desc "IOR and naming service utilities for omniORB with SSL"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.4/omniORB-4.3.4.tar.bz2"
  sha256 "79720d415d23cd8da99287a4ef4da0aa1bd34d3e4c7b1530715600adc5ed3dc3"

  license all_of: ["GPL-2.0-only", "LGPL-2.1-only"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    root_url "https://github.com/OpenRTM/homebrew-omniorb/releases/download/4.3.4/"
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "11b7da5ffd08d47aaf144dc537e0daa6bccd6561816cfa17ef7cd41eeb265867"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "7666011e6f464edd57291baee55e509f5b1056db1bff3babe66d1fd3c6755938"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "python@3.11"
  uses_from_macos "zlib"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.4/omniORBpy-4.3.4.tar.bz2"
    sha256 "a709c3c77b9c6b08616e1c9e12a5a9b9d5ccc1f2dcf6f647f205018d77f819a7"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = python3 = which("python3.11")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?
    system "./configure", *args, *std_configure_args
    system "make", "-j", "4"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *std_configure_args
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
