# Ubuntu 24.04 LTS 기반
FROM ubuntu:24.04

# 환경 변수 설정
ENV DEBIAN_FRONTEND=noninteractive

# 한국 로케일 설정
RUN apt-get update && apt-get install -y \
    locales \
    && locale-gen ko_KR.UTF-8 \
    && update-locale LANG=ko_KR.UTF-8 LC_ALL=ko_KR.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=ko_KR.UTF-8 \
    LANGUAGE=ko_KR:ko \
    LC_ALL=ko_KR.UTF-8

# pyenv 설치 및 Python 3.12 설정
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl https://pyenv.run | bash

ENV HOME=/root
ENV PYENV_ROOT=$HOME/.pyenv
ENV PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init --path)"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc

RUN /bin/bash -c "source ~/.bashrc && pyenv install 3.12 && pyenv global 3.12"

# 나눔폰트와 D2Coding 폰트 설치 (fontconfig 추가)
RUN apt-get update && apt-get install -y \
    fonts-nanum \
    fontconfig \
    && mkdir -p /usr/share/fonts/truetype/d2coding \
    && curl -o /usr/share/fonts/truetype/d2coding/D2Coding-Ver1.3.2-20180524.ttf \
        https://github.com/naver/d2codingfont/raw/master/D2Coding/D2Coding-Ver1.3.2-20180524.ttf \
    && fc-cache -fv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ffmpeg 및 OpenCV 설치
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libopencv-dev \
    python3-opencv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# JupyterLab 설치
RUN /bin/bash -c "source ~/.bashrc && pip install jupyterlab"

# 작업 디렉토리 설정
RUN mkdir -p /root/workspace
WORKDIR /root/workspace

# 포트 노출
EXPOSE 8888