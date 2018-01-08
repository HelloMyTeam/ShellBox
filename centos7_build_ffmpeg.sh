# 安装依赖
yum -y install yum-utils
yum-config-manager --add-repo http://www.nasm.us/nasm.repo
yum install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel -y
if [ ! -d ~/ffmpeg_sources ];then
  mkdir ~/ffmpeg_sources
fi

# 二、yasm  #Ysam是X264和FFmpeg使用的汇编程序。
cd ~/ffmpeg_sources
curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make && make install

# 三、x264 #libx264 视频编码器。
cd ~/ffmpeg_sources
git clone --depth 1 http://git.videolan.org/git/x264
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make && make install

# 四、x265   #H.265/HEVC 视频编码器。
cd ~/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make && make install

# 五、fdk-aac  #AAC 音频编码器。
cd ~/ffmpeg_sources
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make && make install

# 六、lame   #MP3 音频编码器.
cd ~/ffmpeg_sources
curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz
tar xzvf lame-3.99.5.tar.gz
cd lame-3.99.5
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make && make install

# 七、opus  #Opus 音频编解码器.
cd ~/ffmpeg_sources
curl -O https://archive.mozilla.org/pub/opus/opus-1.1.5.tar.gz
tar xzvf opus-1.1.5.tar.gz
cd opus-1.1.5
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make && make install

# 八、libogg   #Ogg 比特流库.
cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz
tar xzvf libogg-1.3.2.tar.gz
cd libogg-1.3.2
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make && make install

# 九、libvorbis  #Vorbis 音频编码器. 需要 libogg
cd ~/ffmpeg_sources
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz
tar xf libvorbis-1.3.4.tar.gz
cd libvorbis-1.3.4
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make && make install

# 十、libvpx  #VP8/VP9 视频编码器.
cd ~/ffmpeg_sources
git clone https://github.com/webmproject/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
PATH="$HOME/bin:$PATH" make
make install

# 十一、ffmpeg
ffmpegversion='3.2.8'
cd ~/ffmpeg_sources
wget http://ffmpeg.org/releases/ffmpeg-${ffmpegversion}.tar.xz
tar xf ffmpeg-${ffmpegversion}.tar.xz
cd ffmpeg-${ffmpegversion}
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build"   --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib -ldl"   --bindir="$HOME/bin" --pkg-config-flags="--static"   --enable-gpl   --enable-libfdk_aac   --enable-libfreetype   --enable-libmp3lame   --enable-libopus   --enable-libvorbis   --enable-libvpx   --enable-libx264   --enable-libx265   --enable-nonfree
make  && make install
hash -r
