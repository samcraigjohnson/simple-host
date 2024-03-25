FROM postgres:16.1

# Install AWS cli
RUN apt-get update && apt-get install -y curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Add config
COPY postgresql.conf /etc/postgresql.conf
COPY pg_hba.conf /etc/pg_hba.conf

COPY archive_command.sh /etc/archive_command.sh
COPY restore_command.sh /etc/restore_command.sh
COPY backup_command.sh /etc/backup_command.sh
COPY recover.sh /etc/recover.sh
COPY start.sh /etc/start.sh

RUN chmod +x /etc/archive_command.sh
RUN chmod +x /etc/restore_command.sh
RUN chmod +x /etc/backup_command.sh
RUN chmod +x /etc/start.sh
RUN chmod +x /etc/recover.sh

ENTRYPOINT ["/etc/start.sh"]
CMD ["postgres"]
