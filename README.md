# Introduction

This repository contains a Dockerfile that containerizes fastai's [harebrain](https://twitter.com/jeremyphoward/status/1103401049270804480) project.

It is based on [Jeremy's Harebrained install guide](https://forums.fast.ai/t/jeremys-harebrained-install-guide/43814/9).

# Prerequisites
You will need a machine that has the following software installed in order to build and run the image:
* [docker](https://docs.docker.com/install/)
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)

# Usage

1. Clone this repo.
2. Navigate to this project's root directory.
3. Execute:
    ```bash
    docker build -t harebrain . && \
    docker run -p 8888:8888 --cap-add SYS_PTRACE --runtime=nvidia --rm harebrain
    
    ```
    This will build the image which will launch a jupyter server at port 8888. The
    working directory of this notebook instance is the root of the [fastai_docs](https://github.com/fastai/fastai_docs) repo.
    The `dev_swift` folder contains notebooks about Swift for TensorFlow.
# Contributing
Feel free to raise an issue if you have any questions, feedback, etc.