# 安装依赖

# yum -y install yum-utils
# yum-config-manager --add-repo http://www.nasm.us/nasm.repo
# yum install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y

HERE=$(cd `dirname $0`;pwd)
echo $HERE

if [ ! -d ${HERE}/ffmpeg_sources ];then
  mkdir ${HERE}/ffmpeg_sources
fi

yasm () {
  # 二、yasm  #Ysam是X264和FFmpeg使用的汇编程序。
  cd ${HERE}/ffmpeg_sources
  curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
  tar xzvf yasm-1.3.0.tar.gz
  cd yasm-1.3.0
  ./configure --prefix="$HERE/ffmpeg_build" --bindir="$HERE/bin"
  make && make install
}

x264 () {
  # 三、x264 #libx264 视频编码器。
  cd ${HERE}/ffmpeg_sources
  git clone --depth 1 http://git.videolan.org/git/x264
  cd x264
  PKG_CONFIG_PATH="$HERE/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HERE/ffmpeg_build" --bindir="$HERE/bin" --enable-static
  make && make install
}

x265 () {
  # 四、x265   #H.265/HEVC 视频编码器。
  cd ${HERE}/ffmpeg_sources
  hg clone https://bitbucket.org/multicoreware/x265
  cd ${HERE}/ffmpeg_sources/x265/build/linux
  cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HERE/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
  make && make install
}

fdk-aac () {
  # 五、fdk-aac  #AAC 音频编码器。
  cd ${HERE}/ffmpeg_sources
  git clone --depth 1 https://github.com/mstorsjo/fdk-aac
  cd fdk-aac
  autoreconf -fiv
  ./configure --prefix="$HERE/ffmpeg_build" --disable-shared
  make && make install
}

lame () {
  # 六、lame   #MP3 音频编码器.
  cd ${HERE}/ffmpeg_sources
  curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
  tar xzvf lame-3.99.5.tar.gz
  cd lame-3.99.5
  ./configure --prefix="$HERE/ffmpeg_build" --bindir="$HERE/bin" --disable-shared --enable-nasm
  make && make install
}

opus () {
  # 七、opus  #Opus 音频编解码器.
  cd ${HERE}/ffmpeg_sources
  curl -O https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
  tar xzvf opus-1.1.5.tar.gz
  cd opus-1.1.5
  ./configure --prefix="$HERE/ffmpeg_build" --disable-shared
  make && make install
}

ogg () {
  # 八、libogg   #Ogg 比特流库.
  cd ${HERE}/ffmpeg_sources
  wget http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
  tar xzvf libogg-1.3.2.tar.gz
  cd libogg-1.3.2
  ./configure --prefix="$HERE/ffmpeg_build" --disable-shared
  make && make install
}

vorbis () {
  # 九、libvorbis  #Vorbis 音频编码器. 需要 libogg
  cd ${HERE}/ffmpeg_sources
  wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
  tar xf libvorbis-1.3.4.tar.gz
  cd libvorbis-1.3.4
  ./configure --prefix="$HERE/ffmpeg_build" --with-ogg="$HERE/ffmpeg_build" --disable-shared
  make && make install
}

vpx () {
  # 十、libvpx  #VP8/VP9 视频编码器.
  cd ${HERE}/ffmpeg_sources
  git clone https://github.com/webmproject/libvpx.git
  cd libvpx
  ./configure --prefix="$HERE/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
  PATH="$HERE/bin:$PATH" make
  make install
}

ffmpeg_build () {
  # 十一、ffmpeg
  ffmpegversion='3.4'
  ffmpegfile="ffmpeg-${ffmpegversion}.tar.xz"
  cd ${HERE}/ffmpeg_sources

  if [[ -f ${ffmpegfile} ]];then
    # m=$(`md5sum $ffmpegfile | cut -d " " -f 1`)
    # if [[ "$m" -ne "c64ba7247bb91e516f6a5789348fd5b5" ]];then
    wget http://ffmpeg.org/releases/${ffmpegfile} 
    echo "download ${ffmpegfile}"
    # fi
  else
  wget http://ffmpeg.org/releases/${ffmpegfile}
  echo "download ${ffmpegfile}"
  fi
  tar xvf ${ffmpegfile}
  cd ffmpeg-${ffmpegversion}
  PKG_CONFIG_PATH="$HERE/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HERE/ffmpeg_build"   --extra-cflags="-I$HERE/ffmpeg_build/include" --extra-ldflags="-L$HERE/ffmpeg_build/lib -ldl"   --bindir="$HERE/bin" --pkg-config-flags="--static"   --enable-gpl   --enable-libfdk_aac   --enable-libfreetype   --enable-libmp3lame   --enable-libopus   --enable-libvorbis   --enable-libvpx   --enable-libx264   --enable-libx265   --enable-nonfree
  make  && make install
  hash -r
}


yasm && x264 && x265 && fdk-aac && lame && opus && ogg && vorbis && vpx && ffmpeg_build
