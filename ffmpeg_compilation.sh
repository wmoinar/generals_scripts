!#/bin/bash

# -------------------------------------------------------------------- |
#                       SCRIPT OPTIONS                                 |
# ---------------------------------------------------------------------|
OPENCV_VERSION='3.4.2'       # Version to be installed
OPENCV_CONTRIB='NO'          # Install OpenCV's extra modules (YES/NO)
# -------------------------------------------------------------------- |


apt-get -y update
apt-get -y dist-upgrade 
apt-get install -y sudo

#GET THE DEPENDENCIES

sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  libxvidcore-dev \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libsdl2-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texinfo \
  wget \
  unzip \
  vim \
  zlib1g-dev \
  build-essential \
  python-dev \
  python-numpy \
  software-properties-common

add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"

media_io_tools=(zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev)
video_io_tools=(libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-de)
lin_alg_tools=(libtbb-dev libeigen3-dev)

apt-get install -y ${media_io_tools[@]}
apt-get install -y ${video_io_tools[@]}
apt-get install -y ${lin_alg_tools[@]}

###############################################
# Compile FFmpeg for Ubuntu, Debian, or Mint  #
###############################################
  
# In your home directory make a new directory to put all of the source code and binaries into: 
  
mkdir -p ~/ffmpeg_sources ~/bin
  
# Compilation & Installation

# NASM
sudo apt-get install nasm -y
  
# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
tar xjvf nasm-2.14.02.tar.bz2 && \
cd nasm-2.14.02 && \
./autogen.sh && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make && \
make install

# YASM
sudo apt-get install yasm -y

# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
wget -O yasm-1.3.0.tar.gz https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
tar xzvf yasm-1.3.0.tar.gz && \
cd yasm-1.3.0 && \
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
make && \
make install
  
# libx264
sudo apt-get install libx264-dev -y

# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
cd x264 && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic && \
PATH="$HOME/bin:$PATH" make && \
make install

# libx265
sudo apt-get install libx265-dev libnuma-dev -y

# Otherwise you can compile: 
sudo apt-get install mercurial libnuma-dev && \
cd ~/ffmpeg_sources && \
if cd x265 2> /dev/null; then hg pull && hg update && cd ..; else hg clone https://bitbucket.org/multicoreware/x265; fi && \
cd x265/build/linux && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source && \
PATH="$HOME/bin:$PATH" make && \
make install

# libvpx
sudo apt-get install libvpx-dev -y

# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
cd libvpx && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
PATH="$HOME/bin:$PATH" make && \
make install

# libfdk-aac
sudo apt-get install libfdk-aac-dev -y

# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
git -C fdk-aac pull 2> /dev/null || git clone --depth 1 https://github.com/mstorsjo/fdk-aac && \
cd fdk-aac && \
autoreconf -fiv && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install

# libmp3lame
sudo apt-get install libmp3lame-dev -y

# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
wget -O lame-3.100.tar.gz https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz && \
tar xzvf lame-3.100.tar.gz && \
cd lame-3.100 && \
PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm && \
PATH="$HOME/bin:$PATH" make && \
make install

# libopus
sudo apt-get install libopus-dev -y

# Otherwise you can compile: 
cd ~/ffmpeg_sources && \
git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
cd opus && \
./autogen.sh && \
./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
make && \
make install

# libaom
cd ~/ffmpeg_sources && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
PATH="$HOME/bin:$PATH" make && \
make install

# OpenCV
cd ~/ffmpeg_sources && \
wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip
mv opencv-${OPENCV_VERSION} OpenCV
cd OpenCV && mkdir build && cd build
cmake -D WITH_FFMPEG=ON -DENABLE_SHARED=off ..
make -j8
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH


# FFmpeg
cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 && \

# Get Transform360
cd ~/ffmpeg_sources && \
git clone https://github.com/facebook/transform360.git
cd transform360/Transform360
cmake ./
make
sudo make install

#Transform360 is implemented in C++ and is invoked by ffmpeg video filter
cd .. && \
cp -r Transform360 ~/ffmpeg_sources/ffmpeg
cd ~/ffmpeg_sources/ffmpeg
cp Transform360/vf_transform360.c libavfilter/ 
cd libavfilter
sed -i '399i extern AVFilter ff_vf_transform360;' allfilters.c
sed -i '90i OBJS-$(CONFIG_TRANSFORM360_FILTER) += vf_transform360.o' Makefile
sed -i '27d' && sed - '27i #include "Transform360/Library/VideoFrameTransformHandler.h"' vf_transform360.c
sed -i '28d' && sed - '28i #include #include "Transform360/Library/VideoFrameTransformHelper.h"' vf_transform360.c

#Configure ffmpeg in the source folder:

PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libopencv \
  --enable-libxvid \
  --extra-libs='-lTransform360 -lstdc++' \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r
source ~/.profile
sudo ldconfig -v

~/bin/ffmpeg -filters
