
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Debian and Ubuntu based images are supported. Alpine images are not yet supported.
FROM debian:9

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1

# Install git, process tools, lsb-release (common in install instructions for CLIs)
RUN apt-get -y install git procps lsb-release

# *****************************************************
# * Add steps for installing needed dependencies here *
# ****************************************************
RUN apt-get -y install \
    unzip \
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    git

# Install Azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install terraform 0.12
RUN wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
RUN unzip terraform_0.12.20_linux_amd64.zip
RUN mv terraform /usr/local/bin
RUN rm terraform_0.12.20_linux_amd64.zip

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
   && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   stretch \
   stable" \
   && apt-get update && apt-get install -y --no-install-recommends \
    docker-ce \
    docker-ce-cli \
   && curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
   && chmod +x /usr/local/bin/docker-compose

# Install kubectl
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https \
   && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
   && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
   && apt-get update && apt-get install --no-install-recommends -y kubectl

# Install helm
RUN curl -sL https://git.io/get_helm.sh | bash

## Install .NET
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg \
   && mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ \
   && wget -q https://packages.microsoft.com/config/debian/9/prod.list \
   && mv prod.list /etc/apt/sources.list.d/microsoft-prod.list \
   && chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg \
   && chown root:root /etc/apt/sources.list.d/microsoft-prod.list \
   && apt-get update && apt-get install dotnet-sdk-2.2 -y --no-install-recommends

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get remove curl unzip wget -y

ENV DEBIAN_FRONTEND=dialog

# Set the default shell to bash rather than sh
ENV SHELL /bin/bash