FROM seafileltd/seafile-mc:13.0-latest

# Install cron if not already present
RUN apt-get update && \
    apt-get install -y cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Create cron job file
RUN echo "45 2 * * * /scripts/gc.sh >> /var/log/gc.log 2>&1" > /etc/cron.d/seafile-gc && \
    chmod 0644 /etc/cron.d/seafile-gc && \
    crontab /etc/cron.d/seafile-gc

# Ensure the gc.sh script is executable
RUN chmod +x /scripts/gc.sh

# Create log directory
RUN mkdir -p /var/log && touch /var/log/gc.log

# Use the new entrypoint that starts cron
ENTRYPOINT ["/entrypoint.sh"]