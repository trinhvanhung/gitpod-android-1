FROM gitpod/workspace-full-vnc

ARG ANDROID_STUDIO_URL=https://dl.google.com/dl/android/studio/ide-zips/4.0.0.16/android-studio-ide-193.6514223-linux.tar.gz
ARG ANDROID_STUDIO_VERSION=4.0
ARG ANDROID_SDK_TOOLS="4333796"
ARG GRADLE_VERSION="5.6.4"
ENV ANDROID_HOME=/home/gitpod/android \
    FLUTTER_HOME=/home/gitpod/flutter \
    PATH=/usr/lib/dart/bin:$FLUTTER_HOME/bin:$ANDROID_HOME/tools:$PATH

USER root

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      coreutils            \
      curl                 \
      expect               \
      lib32gcc1            \
      lib32ncurses5-dev    \
      lib32stdc++6         \
      lib32z1              \
      libc6-i386           \
      pv                   \
      unzip                \
      wget  && \
  apt-get clean && \
  rm -rf /var/cache/apt/* && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*

USER gitpod

RUN mkdir ${ANDROID_HOME};

# Install AndroidSDK
RUN wget --wget -O ${ANDROID_HOME}/android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip && \
    cd ${ANDROID_HOME} && unzip -q -d sdk android-sdk.zip && \
    rm -rf android-sdk.zip && \
    mkdir ~/.android && \
    touch ~/.android/repositories.cfg && \
    yes | sdkmanager --licenses >/dev/null

# Install Android Studio
RUN wget -O ${ANDROID_HOME}/android-studio-ide.tar.gz $ANDROID_STUDIO_URL && \
    cd ${ANDROID_HOME} && tar xf android-studio-ide.tar.gz && rm android-studio-ide.tar.gz;

# Install Flutter sdk
RUN cd /home/gitpod && \
    git clone https://github.com/flutter/flutter.git && \
    cd $FLUTTER_HOME/examples/hello_world && \
    $FLUTTER_HOME/bin/flutter channel ${FLUTTER_CHANNEL} && \
    $FLUTTER_HOME/bin/flutter upgrade && \
    $FLUTTER_HOME/bin/flutter config --enable-web
