# ASL Environments

## Pre Prod
### Public
[Public PreProd https://public-ui.preprod.asl.homeoffice.gov.uk/](https://public-ui.preprod.asl.homeoffice.gov.uk/)

### Internal (needs a VPN unless you're in London Bridge office) SEE BOTTOM OF PAGE FOR VPN
[Internal PreProd https://internal-ui.preprod.asl.homeoffice.gov.uk/](https://internal-ui.preprod.asl.homeoffice.gov.uk/)

## Dev

### Public
[Public Dev https://public-ui.dev.asl.homeoffice.gov.uk/](https://public-ui.dev.asl.homeoffice.gov.uk/)

### Internal
[Internal Dev https://internal-ui.dev.asl.homeoffice.gov.uk/](https://internal-ui.dev.asl.homeoffice.gov.uk/)

## DT (Drafting Tool)

### Prod - ish
[https://ppl-prototype.herokuapp.com/](https://ppl-prototype.herokuapp.com/)

### Dev
[https://ppl-staging.herokuapp.com](https://ppl-prototype.herokuapp.com/)

### Accounts

#### External

`holc`

`ntco`

`admin`

`read`

#### Internal

`inspector`

`asru-admin`

`licensing`

### How to I run a vpn?

You need to do this *every day or so*.

1. Go to [https://access-acp.digital.homeoffice.gov.uk/ui/profiles](https://access-acp.digital.homeoffice.gov.uk/ui/profiles)

2. Download the ACP-TUNNEL default ovpn file

![VPN Download](graphs/VPN_Download.png)

3. Run the relevant command for openvpn on your os

*for my OS - Ubuntu - it's:*

`sudo openvpn vpn-acp-tunnel-NNNNNNN-NNNNN.ovpn`

*Note: This might not work when we're in the Home Office estate, e.g. in Croydon, because of reasons, so the only way to access internal pages when at the HO might be via VPN and tethering on your phone.*

