#
# Fakes3 Dockerfile
#
# https://github.com/beingenious/docker-fakes3.git
#

# Pull base image.
FROM phusion/baseimage:0.9.12

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

## Brightbox Ruby 1.9.3 and 2.0.0
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C3173AA6
RUN echo deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu precise main > /etc/apt/sources.list.d/brightbox.list

# Base system configuration
RUN apt-get update
RUN apt-get install -y build-essential wget ruby2.0 ruby2.0-dev git

# Install fakes3 with dependancies
RUN gem2.0 install specific_install --no-rdoc --no-ri
RUN gem2.0 specific_install -l https://github.com/benjaminbarbe/fake-s3.git

# Fakes3 service
RUN mkdir /etc/service/fakes3
ADD bin/services/fakes3.sh /etc/service/fakes3/run

# Attach volumes.
VOLUME /var/data/fakes3

# Set working directory.
WORKDIR /var/data/fakes3

# Expose ports.
EXPOSE 80

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Leverage the baseimage-docker init system
CMD ["/sbin/my_init", "--quiet"]
