ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install Node.js 22 (required by moltbot)
RUN apk add --no-cache \
    nodejs>=22 \
    npm \
    git \
    bash \
    jq \
    curl

# Install moltbot globally
RUN npm install -g moltbot@latest

# Create necessary directories
RUN mkdir -p /data /config/moltbot

# Copy startup script
COPY run.sh /
RUN chmod a+x /run.sh

# Set working directory
WORKDIR /data

# Expose WebSocket control plane port
EXPOSE 18789

CMD [ "/run.sh" ]
