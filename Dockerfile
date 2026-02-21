FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    DISPLAY=:1 \
    LIBGL_ALWAYS_SOFTWARE=1 \
    MESA_SHADER_CACHE_DIR=/tmp/.mesa-cache

# Allow pinning DeepDrill
ARG DEEPDRILL_REPO=https://github.com/dirkwhoffmann/DeepDrill.git
ARG DEEPDRILL_REF=main

RUN apt-get update && apt-get install -y --no-install-recommends \
    # build stuff
    build-essential cmake git pkg-config \
    # deps for DeepDrill (GMP) + video
    libgmp-dev ffmpeg \
    # SFML 2.6.x (Ubuntu 24.04 ships 2.6.x)
    libsfml-dev \
    # Xorg with dummy driver + GLX + Mesa software OpenGL + tools
    xserver-xorg-core xserver-xorg-video-dummy \
    libgl1-mesa-dri libglx-mesa0 mesa-utils x11-utils \
    # small helpers
    ca-certificates wget && \
    rm -rf /var/lib/apt/lists/*

# Xorg dummy screen config (720p)
RUN mkdir -p /etc/X11/xorg.conf.d
COPY xorg/10-dummy.conf /etc/X11/xorg.conf.d/10-dummy.conf

# Build DeepDrill
WORKDIR /opt
RUN git clone --depth=1 "$DEEPDRILL_REPO" DeepDrill && \
    cd DeepDrill && \
    git fetch --depth=1 origin "$DEEPDRILL_REF" && \
    git checkout "$DEEPDRILL_REF"

WORKDIR /opt/DeepDrill
RUN cmake -S src -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build -j"$(nproc)" && \
    sed -i '/coord.y = 1.0 - coord.y;/d' shaders/illuminators/normalmap.glsl

# Lightweight wrapper for easy invocation inside container
COPY image/deepdrill-cmd /usr/local/bin/deepdrill-cmd
RUN chmod +x /usr/local/bin/deepdrill-cmd

# entry: start an Xorg (dummy) with GLX, then run the given command
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default work dir for projects you bind-mount
WORKDIR /work

LABEL org.opencontainers.image.title="deepdrill-headless" \
      org.opencontainers.image.description="Headless DeepDrill runner with Xorg dummy + Mesa llvmpipe" \
      org.opencontainers.image.source="https://github.com/<you>/deepdrill-headless" \
      org.opencontainers.image.licenses="MIT"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
