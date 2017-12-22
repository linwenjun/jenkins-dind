USER root

RUN apt-get -qq update \
      && apt-get -qq -y install \
      sudo \
      vim \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
      
RUN usermod -a -G staff,docker jenkins

USER  jenkins