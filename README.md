<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Homebrew_logo.svg/159px-Homebrew_logo.svg.png" align="right">

# homebrew omniORB (for OpenRTM)
This is [homebrew](https://brew.sh/) tap repository for OpenSSL enabled omniORB/omniORBpy formula.

Currently the following versions of omniORBs are provided.

- omniORB-4.3.0/omniORBpy-4.3.0
  - on Python 3.8
  - on Python 3.9
  - on Python 3.10
  - on Python 3.11

Both omniORB and omniORBpy are included in one bottle. Since the omniidl depends
on python, please select the appropriate bottles of omniORB/omniORBpy which
support specific python versions. Current latest homebrew's python version is
3.11.

## How to install

### OpenRTM-aist (C++)
```shell
$ brew update
$ brew install openssl
$ brew link openssl
$ brew uninstall omniorb
$ brew install openrtm/omniorb/omniorb-ssl-pyXX
-> XX is the python version you want (38, 39, 310 or 311)
$ brew link omniorb-ssl-pyXY
```

### OpenRTM-aist (Python)
```shell
$ brew update
$ brew install openssl
$ brew link openssl
$ brew uninstall omniorb
$ brew install openrtm/omniorb/omniorb-ssl-pyXX
-> XX is the python version you want (38, 39, 310 or 311)
$ brew link omniorb-ssl-pyXT
```


## How to build package (bottling)

```shell
$ brew install --build-bottle openrtm/omniorb/omniorb-ssl-pyXY
$ brew bottle openrtm/omniorb/omniorb-ssl-pyXY
```
