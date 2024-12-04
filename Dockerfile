# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

################################################################################
# Pick a base image to serve as the foundation for the other build stages in
# this file.
#
# For illustrative purposes, the following FROM command
# is using the alpine image (see https://hub.docker.com/_/alpine).
# By specifying the "latest" tag, it will also use whatever happens to be the
# most recent version of that image when you build your Dockerfile.
# If reproducibility is important, consider using a versioned tag
# (e.g., alpine:3.17.2) or SHA (e.g., alpine@sha256:c41ab5c992deb4fe7e5da09f67a8804a46bd0592bfdf0b1847dde0e0889d2bff).
FROM alpine:latest as base

FROM ubuntu:18.04



# Prerequisites

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget



# Set up new user

RUN useradd -ms /bin/bash developer

USER developer

WORKDIR /home/developer



# Prepare Android directories and system variables

RUN mkdir -p Android/sdk

ENV ANDROID_SDK_ROOT /home/developer/Android/sdk

RUN mkdir -p .android && touch .android/repositories.cfg



# Set up Android SDK

RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip

RUN unzip sdk-tools.zip && rm sdk-tools.zip

RUN mv tools Android/sdk/tools

RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses

RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"

ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"



# Download Flutter SDK

RUN git clone https://github.com/flutter/flutter.git

ENV PATH "$PATH:/home/developer/flutter/bin"



# Run basic check to download Dark SDK

RUN flutter doctor
