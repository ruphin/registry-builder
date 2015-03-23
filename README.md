A complete private docker registry installer
============================================

Need a private docker registry? This will effortlessly set up a private registry anywhere, with redis caching, and NginX for SSL and authentication. It works interactively from the commandline, but offers full automation options for scripting.


TLDR; Give me my private registry!
----------------------------------

Run this on your private registry:

```bash
cd <installpath> # This is where your images will be saved
docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -e INSTALLDIR=$PWD -v $PWD:/data \
           --rm -it ruphin/registry-installer
```

If you want to use SSL (and I think you do) you must provide either a domainname or IP address for the registry. The installer will take care of everything you need including generating self-signed SSL certificates and configuring Nginx to use http basic authentication.

If you are using self-signed SSL certificates, you need to do the following on each machine that has to connect to your registry:

```bash
# Copy over the certificate we generated. 
# Replace <registry> with the domainname or IP address used during installation.
scp <user>@<registry>:<installpath>/certificates/<registry>.crt .
sudo mv <registry>.crt /usr/local/share/ca-certificates/

# Install the ca certificate, and restart the docker daemon
sudo update-ca-certificates
sudo service docker restart

# If you do not have DNS configured for your registry server
sudo sh -c 'echo "<ip-address> <domain>" >> /etc/hosts'
```

Now you can use your private registry:

```bash
docker pull debian
docker login -u <username> -p <password> -e what@ever.com https://<registry>:5000
docker tag debian <registry>:5000/mydebian
docker push <registry>:5000/mydebian
docker pull <registry>:5000/mydebian
```


What is this?
-------------

This is a docker image for a simple installer for private docker registries. The intention of this installer is that it can be run anywhere without requiring any setup, it only needs docker to be installed. It will configure and start a [docker registry](https://registry.hub.docker.com/_/registry/), with a [redis cache](https://registry.hub.docker.com/_/redis/), and an [nginx proxy](https://registry.hub.docker.com/u/library/nginx/). The resulting installation uses only official images, and includes authentication, caching, and optionally SSL connectivity.

It accepts the following configuration options:

- A domainname where you want to run the registry (optional)
- The IP address of the box running the registry (optional)
- Username and password for authentication to your registry

You must you must provide either a domainname or an IP address for SSL to be available. (This is highly recommended)

It is possible to provide your own SSL certificates. If you do not have any, self-signed certificates will be automatically generated for you. 


Usage
-----

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

A htpasswd file:
`<installpath>/auth/registry.htpasswd`

You can create one with:
`echo '<username>' | docker run --rm -i ruphin/htpasswd '<password>' > <installpath>/registry.htpasswd`

SSL Certificates: 
`<installpath>/certificates/<domain>.crt`
`<installpath>/certificates/<domain>.key`

With these in place, you can run the following:

```bash
docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -e INSTALLDIR=<installpath> -v <installpath>:/data \
           -e DOMAIN=<domain> \
           --rm ruphin/registry-installer
```


Encryption
----------

If you don't like moving your SSL keys unencrypted (which is understandable) the installer supports GPG encryption. If you provide `<installpath>/certificates/<fqdn>.crt.gpg` and `<installpath>/certificates/<fqdn>.key.gpg` and use the interactive install, you will be asked for a passphrase to decrypt these files.

You can use `gpg -c <fqdn>.crt` and `gpg -c <fqdn>.key` to encrypt your certificates.
