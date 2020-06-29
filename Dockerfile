# Container image
FROM amd64/python:2-slim

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh

# Install required packages
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y doxygen graphviz fonts-freefont-ttf ftp \
  && rm -rf /var/lib/apt/lists/*

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]

