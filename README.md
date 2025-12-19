# Windows Docker Container
This container enables to run Windows on a Linux host.

## Ports
In order to allow for backwards compatibility with Unity 3.5.5, which 
does not use https, Port 5000 is mapped to Port 80 in the windows service.
Port 5055 and 5155 are for Photon, 843 is for Photon Policy.
Port 8006 is for Windows installation purposes, 3389 is for RDP.

## https support
It automatically signs and auto-renews certificates for https.
Port 80 is redirected to 443.

