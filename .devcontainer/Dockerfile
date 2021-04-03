FROM ubuntu:18.04

RUN apt update && apt install -y curl git unzip xz-utils zip wget gnupg lsb-release libglu1-mesa openjdk-8-jdk vim apt-transport-https ca-certificates

# Add docker repo
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Prerequisites
RUN apt update && apt install -y sudo docker-ce docker-ce-cli containerd.io

# Install Docker compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.28.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Setup Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
  && apt install -y nodejs \
  && curl -L https://www.npmjs.com/install.sh | sh

# Setup Node tools
RUN npm install -g firebase-tools supabase

# Setup new user
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable
ENV PATH "$PATH:/home/developer/flutter/bin"
# Run basic check to download Dark SDK
RUN flutter doctor
