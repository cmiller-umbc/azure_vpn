# Start with ubuntu base image
FROM nginx

# Set working directory to /
WORKDIR /

# Copy the necessary files
COPY revprox.conf /etc/nginx/conf.d/revprox.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY server.crt /etc/nginx/ssl/server.crt
COPY server.key /etc/nginx/ssl/server.key
COPY 400.html /usr/share/nginx/html/400.html
COPY index.html /usr/share/nginx/html/index.html

# Install apt-utils manually for some reason
RUN apt-get -y update && apt-get -y install --no-install-recommends apt-utils

# Install nginx and relevant bash tools for troubleshooting
RUN mkdir -p /var/log/nginx/logs /home/LogFiles /opt/startup && \
      echo "root:Docker!" | chpasswd && \
      echo "cd /home" >> /etc/bash.bashrc \
RUN apt-get install -y openssh-client openssh-server vim curl wget tcptraceroute openrc yarn net-tools dnsutils tcpdump iproute2 cron nano && \
    rm -rf /var/lib/apt/lists/*

# Copy in SSH configuration
COPY sshd_config /etc/ssh/sshd_config

#ssh customization script that Azure maybe uses?
RUN mkdir -p /tmp
COPY ssh_setup.sh /tmp/ssh_setup.sh

#Not quite sure if this is necessary...
COPY ssh_setup.sh /opt/startup/startssh.sh
RUN chmod +x /opt/startup/startssh.sh

# Build environment variables that are used in sshd_config
ENV PORT 8080
ENV SSH_PORT 2222

# Expose the necessary ports
EXPOSE 80 443 2222 8080

# Copy in boot up commands and run as entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]