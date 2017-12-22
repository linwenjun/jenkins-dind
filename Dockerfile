FROM jenkins:2.60.1

USER root
RUN apt-get -qq update \
      && apt-get -qq -y install \
      sudo \
      vim \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER  jenkins

