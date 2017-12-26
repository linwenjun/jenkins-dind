FROM jenkins:2.60.3

USER root

RUN apt-get update \
      && apt-get -y install \
      sudo \
      vim \
      libltdl7 \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

ADD install-rancher-compose.sh install-rancher-compose.sh
RUN bash install-rancher-compose.sh && rm install-rancher-compose.sh

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false

ADD project /project
RUN cd /project && ./gradlew tasks

USER  jenkins
