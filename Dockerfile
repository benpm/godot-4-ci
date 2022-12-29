FROM ubuntu:focal
LABEL author="https://github.com/benpm/godot-4-ci/graphs/contributors"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    adb \
    openjdk-11-jdk-headless \
    rsync \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

ARG GODOT_VERSION="4.0"
ARG RELEASE_NAME="beta8"
ARG SUBDIR=""

# Download godot and export templates
# Example URL: https://downloads.tuxfamily.org/godotengine/4.0/beta8/Godot_v4.0-beta8_linux.x86_64.zip
RUN wget -nv https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && wget -nv https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}${SUBDIR}/${RELEASE_NAME}/Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mkdir -v ~/.cache \
    && mkdir -v -p ~/.config/godot \
    && mkdir -v -p ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip \
    && mv -v Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64 /usr/local/bin/godot \
    && unzip Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz \
    && mv -v templates/* ~/.local/share/godot/templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && rm -vf Godot_v${GODOT_VERSION}-${RELEASE_NAME}_export_templates.tpz Godot_v${GODOT_VERSION}-${RELEASE_NAME}_linux.x86_64.zip

# Add itch.io butler script
ADD getbutler.sh /opt/butler/getbutler.sh
RUN bash /opt/butler/getbutler.sh
RUN /opt/butler/bin/butler -V
ENV PATH="/opt/butler/bin:${PATH}"

# Run godot once to generate config files
RUN godot -e --quit --headless
