# Project Title

Azure VPN

## Description

Using https://github.com/cmiller-umbc/subdomain_fuzzer we discovered multiple Microsoft owned web domains that pointed to Azure CDN edge servers that proxy domain fronted traffic.  These findings can be easily recreated by running azure_domainfuzzer.py from that repo and inputing "microsoft.com".  The app has no dependencies and will run on any machine with Python 3 installed.  Microsoft has been informed of these domain fronting capable edge servers that are exposed to the internet and has informed us that they could not recreate our findings.

The goal of this project is to build a completely open-source and free solution that automatically domain fronts all traffic leaving a given interface on your machine, through an exposed Azure CDN edge server to an Azure hosted Nginx Reverse Proxy that then proxies your traffic to its true destination.  For a better understanding of desired traffic flow, please view the Azure_vpn Process Chart.

This project is currently still in the early stages of development.  As of right now its two authors are myself and ChatGPT who has been more helpful than any youtube video out there about Docker Nginx reverse proxies!  Any suggestions and recommendations are welcome.

### Software Used

Nginx
Docker

### Installing

git clone http://github.com/cmiller-umbc/azure_vpn/

### Executing program

docker build -t nginx-revprox .
docker run --name nginx-revprox -p 80:80 -p 443:443 nginx-revprox

## Help



## Authors



## Version History



## License



## Acknowledgments

