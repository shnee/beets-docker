FROM alpine:3.8

RUN \
    echo -e "\n" \
"**************************************************************************" \
"\n * Install build packages.\n" \
"**************************************************************************\n" \
    && \
    apk add --no-cache --virtual=build-dependencies \
        cmake \
        ffmpeg-dev \
        g++ \
        gcc \
        git \
        jpeg-dev \
        libpng-dev \
        make \
        mpg123-dev \
        openjpeg-dev \
        python2-dev \
     && \
    echo -e "\n" \
"**************************************************************************" \
"\n * Install runtime packages.\n" \
"**************************************************************************\n" \
    && \
    apk add --no-cache \
        curl \
        expat \
        ffmpeg \
        ffmpeg-libs \
        gdbm \
        gst-plugins-good \
        gstreamer \
        jpeg \
        lame \
        libffi \
        libpng \
        mpg123 \
        openjpeg \
        py2-gobject3 \
        py2-pip \
        py2-pylast \
        python2 \
        sqlite-libs \
        tar \
        vim \
        wget && \
    echo -e "\n" \
"**************************************************************************" \
"\n * Compile mp3gain.\n" \
"**************************************************************************\n" \
    && \
    mkdir -p \
        /tmp/mp3gain-src && \
    curl -o \
        /tmp/mp3gain-src/mp3gain.zip -L \
        https://sourceforge.net/projects/mp3gain/files/mp3gain/1.6.1/mp3gain-1_6_1-src.zip && \
    cd /tmp/mp3gain-src && \
    unzip -qq /tmp/mp3gain-src/mp3gain.zip && \
    sed -i "s#/usr/local/bin#/usr/bin#g" /tmp/mp3gain-src/Makefile && \
    make && \
    make install && \
    echo -e "\n" \
"**************************************************************************" \
"\n * Compile chromaprint.\n" \
"**************************************************************************\n" \
    && \
    git clone https://bitbucket.org/acoustid/chromaprint.git \
        /tmp/chromaprint && \
    cd /tmp/chromaprint && \
    cmake \
        -DBUILD_TOOLS=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr && \
    make && \
    make install && \
    echo -e "\n" \
"**************************************************************************" \
"\n * Install pip packages.\n" \
"**************************************************************************\n" \
    && \
    pip install --no-cache-dir -U \
        beautifulsoup4 \
        beets \
        beets-copyartifacts \
        discogs-client \
        flask \
        pillow \
        pip \
        pyacoustid \
        requests \
        unidecode && \
    echo -e "\n" \
"**************************************************************************" \
"\n * Cleanup.\n" \
"**************************************************************************\n" \
    && \
    apk del --purge \
        build-dependencies && \
    rm -rf \
        /root/.cache \
        /tmp/*

# environment settings
ENV BEETSDIR="/config" \
    EDITOR="vim" \
    HOME="/config"

VOLUME /config /downloads /music /staging

ENTRYPOINT ["/usr/bin/beet"]

