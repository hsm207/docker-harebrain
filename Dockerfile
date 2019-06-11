FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04

ARG swift_tf_url=https://storage.googleapis.com/swift-tensorflow-artifacts/releases/v0.3/rc1/swift-tensorflow-RELEASE-0.3-cuda10.0-cudnn7-ubuntu18.04.tar.gz
ARG anaconda_url=https://repo.anaconda.com/archive/Anaconda3-2019.03-Linux-x86_64.sh

RUN apt-get update && \
    apt-get install -y locales software-properties-common

# fix python encode/decode error in Ubuntu
# from https://stackoverflow.com/questions/27931668/encoding-problems-when-running-an-app-in-docker-python-java-ruby-with-u/27931669
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN add-apt-repository -y ppa:apt-fast/stable && \
    add-apt-repository -y ppa:graphics-drivers/ppa && \
    apt-get update && \
    apt-get -y install apt-fast

WORKDIR /tmp/docker-harebrain

COPY . .

# from https://serverfault.com/questions/949991/how-to-install-tzdata-on-a-ubuntu-docker-image
RUN bash ./scripts/install_tzdata.sh

RUN apt-fast -y upgrade &&  \
    apt-fast install -y build-essential \
                        cmake \
                        doxygen \
                        exuberant-ctags \
                        g++-6 \
                        gcc-6 \
                        gfortran-6 \
                        google-mock \
                        graphviz \
                        libasound2-dev \
                        libboost-all-dev \
                        libbz2-dev \
                        libeigen3-dev \
                        libfftw3-dev \
                        libflac-dev \
                        libgflags-dev \
                        libgoogle-glog0v5 \
                        libgoogle-glog-dev \
                        libgtest-dev \
                        liblzma-dev \
                        libogg-dev \
                        libsndfile-dev \
                        libsox-fmt-all \
                        libtool \
                        libvorbis-dev \
                        parallel \
                        python3-pip  \
                        python-powerline \
                        ubuntu-drivers-common \
                        vim-nox \
                        zlib1g-dev && \
      apt-fast install -y ack \
                          firefox\
                          git \
                          lsyncd \
                          mesa-common-dev \
                          tigervnc-standalone-server \
                          wget


RUN mkdir -p ~/.ssh/ && \
    cp ./configs/ssh_config ~/.ssh/config && \
    chmod 600 ~/.ssh/config

RUN wget --quiet $anaconda_url -O anaconda.sh && \
    bash anaconda.sh -b -p /opt/conda && \
    rm anaconda.sh && \
    /opt/conda/bin/conda build purge-all && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate" >> ~/.bashrc

RUN rm -r /tmp/docker-harebrain

WORKDIR  /root/download

RUN wget -q $swift_tf_url -O s4tf.tar.gz && \
    apt-fast -y install clang \
                        cmake \
                        icu-devtools \
                        libblocksruntime-dev \
                        libbsd-dev \
                        libcurl4-openssl-dev \
                        libedit-dev \
                        libicu-dev \
                        libncurses5-dev \
                        libpython-dev \
                        libsqlite3-dev \
                        libxml2-dev \
                        ninja-build \
                        pkg-config \
                        python \
                        rsync \
                        swig \
                        systemtap-sdt-dev \
                        uuid-dev && \
    tar xf s4tf.tar.gz && \
    mkdir ~/swift && \
    mv usr ~/swift && \
    echo "export PATH=~/swift/usr/bin:$PATH" >> ~/.bashrc && \
    rm s4tf.tar.gz

WORKDIR /root/git

RUN git clone https://github.com/google/swift-jupyter.git && \
    cd swift-jupyter && \
    /opt/conda/bin/python register.py --sys-prefix --swift-python-use-conda --use-conda-shared-libs --swift-toolchain ~/swift

RUN git clone https://github.com/fastai/fastai_docs.git

WORKDIR /root/git/fastai_docs

EXPOSE 8888

CMD /opt/conda/bin/jupyter notebook --ip 0.0.0.0 --allow-root --no-browser



