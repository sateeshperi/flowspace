FROM mltooling/ml-workspace:latest

USER root

# Install a few dependencies for iCommands, text editing, and monitoring instances
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    gcc \
    gnupg \
    htop \
    less \
    libfuse2 \
    libpq-dev \
    libssl1.0 \
    lsb \
    nano \
    nodejs \
    python-requests \
    software-properties-common \
    vim 

# Install iCommands
RUN wget https://files.renci.org/pub/irods/releases/4.1.10/ubuntu14/irods-icommands-4.1.10-ubuntu14-x86_64.deb && dpkg -i *.deb
   
# Install conda environment for Mamba and Snakemake
COPY environment.yml /root/environment.yml
RUN conda update -n base -c defaults conda
RUN conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda env update -n base -f environment.yml && \
    conda clean --all

# Install Nextflow
WORKDIR /usr/local/bin
RUN wget -qO- https://github.com/nextflow-io/nextflow/releases/download/v20.12.0-edge/nextflow-20.12.0-edge-all | bash
