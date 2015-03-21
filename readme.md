A quick private docker registry installer
=========================================

Need a private docker registry? This will effortlessly set up a private registry anywhere, with redis caching for extra speed, authentication, and optional SSL out of the box. It works interactively from the commandline, but offers full automation options for making the whole process repeatable.

TLDR; Give me my private registry!
----------------------------------

Run this anywhere:

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -e INSTALLDIR=$PWD -v $PWD:/data \
           --rm -it ruphin/registry-installer
```

And you have your own private registry:

```bash
docker pull debian
docker login https://anywhere:5000
docker tag debian anywhere:5000/mydebian
docker push anywhere:5000/mydebian

docker pull anywhere:5000/mydebian
```

## What is this?

This is a simple installer for private docker registries, inside a public docker image. The intention of this installer is that it can be run anywhere without requiring any setup or downloads, it only needs docker to be installed. It will configure and start a [docker registry](https://registry.hub.docker.com/_/registry/), with a [redis cache](https://registry.hub.docker.com/_/redis/), and an [nginx proxy](https://registry.hub.docker.com/u/library/nginx/). The resulting installation uses only official images, and includes authentication, caching, and optionally SSL connectivity.

It accepts the following configuration options:

- A domainname where you want to run the registry (optional)
- The IP address of the box running the registry (optional)
- Username and password for authentication to your registry

You must you must provide either a domainname or an IP address for SSL to be available. (This is highly recommended)

It is possible to provide your own SSL certificates. If you do not have any, self-signed certificates will be automatically generated for you. 

## Usage

There are two ways to install your private registry. In the interactive install, you will be asked for any necessary configuration through the command line. This mode is recommended for normal use. In the automated install, you have to provide the necessary configurations and files beforehand, and the installer will attempt to complete the installation automatically. If anything is missing it will not ask for additional information, and immediately exit with a failure. This mode is recommended for automated installations.


#### Interactive install

This is the standard installation method. It will interactively ask you everything it needs to complete the installation process. Simply `cd` into the desired installation directory and run this:

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -e INSTALLDIR=$PWD -v $PWD:/data \
           --rm -it ruphin/registry-installer
```

#### Automated install

The automated install requires several files to be in place before running the installer.

A htpasswd file `<installpath>/auth/registry.htpasswd` with the authorizations for the registry.
You can create one with `echo <username> | docker run --rm ruphin/htpasswd <password> > <installpath>/registry.htpasswd`

SSL Certificates: `<installpath>/certificates/registry.crt` and `<installpath>/certificates/registry.key`

With these in place, you can run the following:

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -e INSTALLDIR=<installpath> -v <installpath>:/data \
           -e DOMAIN=<domainname> \
           --rm ruphin/registry-installer
```


## Encryption

If you don't like moving your SSL keys unencrypted (which is understandable) the installer supports GPG encryption. If you provide `<installpath>/certificates/registry.crt.gpg` and `<installpath>/certificates/registry.key.gpg` and use the interactive install, you will be asked for a passphrase to decrypt these files.

You can use `gpg -c registry.crt` and `gpg -c registry.key` to encrypt your certificates.
