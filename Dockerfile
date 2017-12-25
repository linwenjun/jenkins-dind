FROM jenkins:2.60.1

USER root

RUN apt-get update \
      && apt-get -y install \
      sudo \
      vim \
      libltdl7 \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER  jenkins



