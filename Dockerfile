# Start with ubuntu base image
FROM nginx

# Prevent GUI pop-ups
ENV DEBIAN_FRONTEND noninteractive

# Set working directory to /
WORKDIR /

# Make js directory
RUN mkdir /etc/nginx/js

# Copy the necessary files
COPY revprox.conf /etc/nginx/conf.d/revprox.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY headers.js /etc/nginx/headers.js
COPY server.crt /etc/nginx/ssl/server.crt
COPY server.key /etc/nginx/ssl/server.key
COPY 400.html /usr/share/nginx/html/400.html
COPY index.html /usr/share/nginx/html/index.html

# Install all apps seperately to try and figure out which one was buggin
RUN apt-get -y update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends openssh-client
RUN apt-get install -y --no-install-recommends openssh-server
RUN apt-get install -y --no-install-recommends net-tools
RUN apt-get install -y --no-install-recommends dnsutils
RUN apt-get install -y --no-install-recommends iproute2
RUN apt-get install -y --no-install-recommends cron
RUN apt-get install -y nano
RUN rm -rf /var/lib/apt/lists/*

# Set log directory, root password, and bash home directory
RUN mkdir -p /var/log/nginx/logs /home/LogFiles /opt/startup
RUN echo "root:Docker!" | chpasswd

# Copy in SSH configuration
COPY sshd_config /etc/ssh/
RUN mkdir /run/sshd
RUN ssh-keygen -A

# Build environment variables that are used in sshd_config
ENV PORT 8080
ENV SSH_PORT 2222

# Expose the necessary ports
EXPOSE 80 443 2222 8080

#Start SSH
CMD ["/usr/sbin/sshd", "-D", "-e"]

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]

# Copy in boot up commands and run as entrypoint script
COPY --chown=root docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh