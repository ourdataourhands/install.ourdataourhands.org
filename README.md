# Our Data Our Hands `curl|bash` Installation Script
This repository contains the `curl|bash` install script served from http://sh.ourdataourhands.org/ that installs the [Our Data Our Hands](http://ourdataourhands.org) grid contributor. The script has been tested on Ubuntu Linux, both x86 and ARM varieties, but **is not guaranteed to work** on any other platform. In fact, it's not guaranteed to work on the tested platforms either, but we do our best! We welcome your contribution through a pull request to add compatibility for your favorite operating system, or to log bugs you've found. See [our issues page](https://github.com/ourdataourhands/install.ourdataourhands.org/issues) for more.

The basic idea behind this script:

1. Check your local Linux system for pre-requisites like [Docker](https://www.docker.com/), [OpenSSL](https://www.openssl.org/), [git](https://git-scm.com/) and [a large hard drive](http://a.co/0jHW6KQ)
2. Clone the Our Data Our Hands Docker image locally
3. Generate SSH keys
4. Fire up the Docker image, configure [Zerotier](https://github.com/zerotier/) networking and [infinit](https://infinit.sh/) distributed storage
5. Start contributing to the cause, and feel good!

## GPG Signature
This installation script plans to be GPG signed in the future, much like the Zerotier installer: [we have an issue](https://github.com/ourdataourhands/install.ourdataourhands.org/issues/2).

## Installation
This installer is **not ready for deployment**. We're currently still testing and automating the process. Please **do not use** this until there is a release.
