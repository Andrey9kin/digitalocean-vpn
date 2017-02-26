Automatically create droplet in DigitalOcean, install and configure VPN server, update local VPN settings and connect

Requirements/tested on:
- digitalocean-cli v1.0 https://github.com/Andrey9kin/digitalocean-cli Compiled into single executable as described in README
- packer v0.12.2 https://www.packer.io
- MacOS 10.12

To run

```
VPN=<VPN configuration name> TOKEN=<DO API tocken> CREDENTIALS=user:password bash do-things.sh
```