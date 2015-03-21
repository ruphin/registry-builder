This project is a simple provisioner for a docker registry running as https://registry.unionstationapp.com:5000

To provision any server as a docker registry:

1. Download this project anywhere permanent (not tmp)
2. Have Docker installed (you are running CoreOS or RancherOS right?)
3. Ask Goffert for the secret password
4. `run.sh '<secret password>'`
5. Make sure this server is known as registry.unionstationapp.com either through DNS or hostfile shenanigans

You can now use `docker login registry.unionstationapp.com:5000` On your docker hosts.
Ignore the account activation instructions.

TODO: security (htpassword)
https://github.com/jwilder/nginx-proxy#basic-authentication-support

For docker client configuration:
https://coreos.com/docs/launching-containers/building/registry-authentication/
