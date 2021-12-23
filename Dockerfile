FROM arm64v8/alpine

MAINTAINER Jan-Frode Myklebust <janfrode@tanso.net>

ENV LANG=C.UTF-8

RUN apk update && apk upgrade
RUN apk --no-cache add \
  bash \
  build-base \
  ca-certificates \
  clang-dev \
  clang \
  cmake \
  coreutils \
  curl \
  freetype-dev \
  ffmpeg-dev \
  ffmpeg-libs \
  gcc \
  g++ \
  git \
  gettext \
  lcms2-dev \
  libavc1394-dev \
  libc-dev \
  libffi-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  libressl-dev \
  libtbb \
  libtbb-dev\
  libwebp-dev \
  linux-headers \
  make \
  musl \
  openblas\
  openblas-dev\
  openjpeg-dev \
  openssl \
  python3 \
  python3-dev \
  tiff-dev \
  unzip \
  zlib-dev \
  py3-pip

RUN ln -s /usr/bin/python3 /usr/local/bin/python && \
  ln -s /usr/bin/pip3 /usr/local/bin/pip && \
  pip install --upgrade pip

RUN ln -s /usr/include/locale.h /usr/include/xlocale.h && \
  pip install numpy

RUN mkdir /opt ; cd /opt && \
  wget https://github.com/opencv/opencv/archive/refs/tags/4.5.4.zip && \
  unzip 4.5.4.zip && rm 4.5.4.zip && \
  wget https://github.com/opencv/opencv_contrib/archive/refs/tags/4.5.4.zip && \
  unzip 4.5.4.zip && rm 4.5.4.zip

RUN cd /usr/include/ && ln -s libpng16 libpng
RUN mkdir -p /usr/local/include /include

RUN cd /opt/opencv-4.5.4 && mkdir build && cd build && \
  cmake .. \
        -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-4.5.4/modules/  \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D INSTALL_C_EXAMPLES=OFF \
        -D CMAKE_BUILD_TYPE=RELEASE

RUN cd /opt/opencv-4.5.4/build && make && make install && cd .. && rm -rf build && \
  cp -p $(find /usr/local/lib/python*/site-packages -name cv2.*.so) \
   /usr/lib/python*/site-packages/cv2.so && \
   python -c 'import cv2; print("Python: import cv2 - SUCCESS")'
