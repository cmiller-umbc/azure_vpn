# Start with nginx base image
FROM nginx

# Set working directory to /
WORKDIR /

# Copy the necessary files
COPY revprox.conf /etc/nginx/conf.d/default.conf
COPY server.crt /etc/nginx/ssl/cert.crt
COPY server.key /etc/nginx/ssl/key.key
COPY 400.html /usr/share/nginx/html/400.html

# Expose the necessary ports
EXPOSE 80 443

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]