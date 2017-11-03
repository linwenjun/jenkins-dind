FROM jenkins:1.642.4

USER root
RUN apt update \
      && apt install sudo
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
USER  jenkins