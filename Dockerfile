FROM jenkins:2.60.3-alpine

USER root
RUN apk update \
      && apk add sudo \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS=-Djenkins.install.runSetupWizard=false
ADD --chown=jenkins:jenkins ./jobs /var/jenkins_home/jobs
ADD --chown=jenkins:jenkins ./scripts /var/scripts

USER  jenkins
