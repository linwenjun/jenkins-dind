FROM jenkins:2.60.3-alpine

USER root
RUN apk update \
      && apk add sudo \
      && apk add docker \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN addgroup -S docker && adduser -S -g jenkins group
USER  jenkins
