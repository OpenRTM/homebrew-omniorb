<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Homebrew_logo.svg/159px-Homebrew_logo.svg.png" align="right">

# homebrew omniORB (for OpenRTM)
This is [homebrew](https://brew.sh/) tap repository for OpenSSL enabled omniORB/omniORBpy formula.

Currently the following versions of omniORBs are provided.

- omniORB-4.2.4
- omniORBpy-4.2.4

## How to install

### OpenRTM-aist (C++)
```shell
$ brew update
$ brew install openssl
$ brew link openssl
$ brew uninstall omniorb
$ brew tap openrtm/omniorb
$ brew install openrtm/omniorb-ssl
$ brew link omniorb-ssl
```

### OpenRTM-aist (Python)
```shell
$ brew update
$ brew install openssl
$ brew link openssl
$ brew uninstall omniorb
$ brew tap openrtm/omniorb
$ brew install openrtm/omniorb-ssl
$ brew link omniorb-ssl
$ brew install openrtm/omniorbpy
$ brew link omniorbpy
```

