# Project Title

Azure VPN

## Description

Using https://github.com/cmiller-umbc/subdomain_fuzzer we discovered multiple Microsoft owned web domains that pointed to Azure CDN edge servers that proxy domain fronted traffic.  These findings can be easily recreated by running azure_domainfuzzer.py from that repo and inputing "microsoft.com".  The app has no dependencies and will run on any machine with Python 3 installed.  Microsoft has been informed of these domain fronting capable edge servers that are exposed to the internet and has informed us that they could not recreate our findings.

The goal of this project is to build a completely open-source and free solution that automatically domain fronts all traffic leaving a given interface on your machine, through an exposed Azure CDN edge server to an Azure hosted Nginx Reverse Proxy that then proxies your traffic to its true destination.  For a better understanding of desired traffic flow, please view the Azure_vpn Process Chart.

This project is currently still in the early stages of development.  As of right now its two authors are myself and ChatGPT who has been more helpful than any youtube video out there about Docker Nginx reverse proxies.  Considering uploading my entire conversation for this project to github as I've also learned alot about how to best get the information you want from ChatGPT.  

Any suggestions and recommendations are welcome!

### Software Used

Nginx, Docker, Dockerhub, Azure App Services

### Domain Fronting

As described in the parent research paper "Domain Fronting Through Microsoft Azure and CloudFlare: How to Identify Viable Domain Fronting Proxies" the python app azure_domainfuzzer.py is able to successfully identify multiple microsoft owned domains that point to edge servers that proxy domain fronted traffic to a static web app who's address is hidden in the encrypted HTTP Host header of the packet.  This is done by iteratively using the wget command and fuzzing in the top 1000 most common subdomains from https://github.com/bitquark/dnspop/tree/master/results.

The logical next step in this solution is to turn the static web app into a reverse proxy web server that can take an address hidden within a different HTTP header (I've chosen Forwarded:) and proxy the information to the true destination, which can now be any location on the internet and not just those hosted in Azure.

### NGINX Reverse Proxy

In order to keep this solution 100% free it has to be done using only Azure services available to a free account.  As of 4-2-2023 the only method of hosting an NGINX Reverse Proxy server in the Azure CDN for free is by pushing a Dockerhub hosted container image to Azure App Services.

As of 4-2-23 this feature is in-operable and undergoing improvements.

### Azure_VPN.py

This solution also requires a local python application to be running on the user machine.  The plan is to use the mitmproxy library to alter outgoing traffic in such a way that it is properly routed through the Azure CDN and our NGINX reverse proxy to the desired address, without any user interaction.  That requires intercepting requests at the web interface, placing the address or "true destination" from the HTTPS DNS and SNI headers into the HTTP Forwarded header, changing the HTTP Host header to the address of the NGINX reverse proxy, and changing the HTTP DNS and SNI headers to be one of the exposed Azure CDN edge servers (in this case I am going with security.microsoft.com because Microsoft blew me off and irony is fun).

As of 4-2-23 this feature is in-operable and undergoing improvements.

### Installing

git clone http://github.com/cmiller-umbc/azure_vpn/

### Executing program

docker build -t nginx-revprox .
docker run --name nginx-revprox -p 80:80 -p 443:443 nginx-revprox

## Authors

Me and my bff ChatGPT

## Version History

0.0 - Nginx Reverse Proxy still non-functional.  When attempting to run an instance of the built image it returns the following error: [emerg] open() "/etc/nginx/logs/error.log" failed (2: No such file or directory)

## Acknowledgments

Working with Dr. Michael Brown from University of Maryland, Baltimore County on publishing a study into domain fronting and the methodology used to build a domain fronting proxy identifier using python code to manually identify available edge servers on any given CDN.  

Domain Fronting Through Microsoft Azure and CloudFlare: How to Identify Viable Domain Fronting Proxies - https://docs.google.com/document/d/1USofoLX4JFpv8lrY80Q9qQFffe0Mmux12tTSfOccseM/edit
