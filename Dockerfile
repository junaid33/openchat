FROM nvcr.io/nvidia/pytorch:23.10-py3
USER root

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y install \
    wget \
    curl \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    --no-install-recommends

# Install Miniconda
ENV CONDA_DIR /opt/conda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p $CONDA_DIR
ENV PATH=$CONDA_DIR/bin:$PATH

# Create and initialize Conda environment
RUN conda create -y --name openchat python=3.11 \
    && echo "source activate openchat" > ~/.bashrc

# To keep the environment activated for subsequent RUN commands
SHELL ["/bin/bash", "--login", "-c"]

RUN pip3 install ochat

CMD ["conda", "run", "-n", "openchat", "python", "-m", "ochat.serving.openai_api_server", "--model", "openchat/openchat_3.5"]
# If you want to make it available from outside the container
# CMD ["conda", "run", "-n", "openchat", "python", "-m", "ochat.serving.openai_api_server", "--model", "openchat/openchat_3.5", "--host", "0.0.0.0", "--port", "18888"]
