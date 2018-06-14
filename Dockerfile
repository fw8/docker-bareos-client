FROM ubuntu:xenial
LABEL maintainer="Florian Wolpert <wolpert@freinet.de>"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install curl software-properties-common vim

RUN curl -Ls http://download.bareos.org/bareos/release/17.2/xUbuntu_16.04/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/breos-keyring.gpg add - && \
    echo 'deb http://download.bareos.org/bareos/release/17.2/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/bareos.list && \
    apt-get update -qq && \
    apt-get install -qq -y bareos-client mysql-client && \
    apt-get clean

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh
RUN sed -i -e 's/# Plugin Directory/Plugin Directory/' /etc/bareos/bareos-fd.d/client/myself.conf
RUN tar cfvz /bareos-fd.tgz /etc/bareos/bareos-fd.d

RUN mkdir /etc/bareos/scripts
COPY scripts/* /etc/bareos/scripts/

# create pseudo-user and add bareos to the group
# this way bpipe is able to write to a mapped user volume 
#RUN useradd -u 1000 volume-user && usermod -a -G volume-user bareos

EXPOSE 9102

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/bareos-fd", "-f"]