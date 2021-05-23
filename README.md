<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Homebrew_logo.svg/159px-Homebrew_logo.svg.png" align="right">

# homebrew omniORB (for OpenRTM)
This is [homebrew](https://brew.sh/) tap repository for OpenSSL enabled omniORB/omniORBpy formula.

Currently the following versions of omniORBs are provided.

- omniORB-4.2.4
  - on Python 3.8
  - on Python 3.9
- omniORBpy-4.2.4
  - on Python 3.8
  - on Python 3.9

Since the omniidl depends on python, please select the appropriate
bottles of omniORB/omniORBpy which support specific python versions.
Current latest homebrew's python version is 3.9.

## How to install

### OpenRTM-aist (C++)
```shell
$ brew update
$ brew install openssl
$ brew link openssl
$ brew uninstall omniorb
$ brew install openrtm/omniorb/omniorb-ssl
or
$ brew install openrtm/omniorb/omniorb-ssl-pyXX
-> XX is the python version you want (py38 or py39)
$ brew link omniorb-ssl
```

### OpenRTM-aist (Python)
```shell
$ brew update
$ brew install openssl
$ brew link openssl
$ brew uninstall omniorb
$ brew install openrtm/omniorb/omniorbpy
or
$ brew install openrtm/omniorb/omniorbpy-pyXX
-> XX is the python version you want (py38 or py39)
$ brew link omniorb-ssl
$ brew link omniorbpy
```


## How to build package (bottling)

```shell
$ brew install --build-bottle openrtm/omniorb/omniorb-ssl
$ brew bottle openrtm/omniorb/omniorb-ssl
```
