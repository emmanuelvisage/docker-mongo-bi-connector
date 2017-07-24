FROM debian:jessie
MAINTAINER Emmanuel Marboeuf <emmanuel@visage.jobs>

RUN apt-get update
RUN apt-get install -y openssl libssl-dev

ADD bin /usr/local/bin
RUN chmod -R 755 /usr/local/bin

EXPOSE 3307