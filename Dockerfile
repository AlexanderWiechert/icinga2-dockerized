FROM ubuntu:latest
ENV TZ="Europe/Berlin"

RUN apt-get update && \
  apt-get -y install apt-transport-https wget gnupg lsb-release && \
  wget -O - https://packages.icinga.com/icinga.key | apt-key add - && \
  echo "Acquire::http::No-Cache true;" > /etc/apt/apt.conf && \
  echo "Acquire::http::Pipeline-Depth 0;" >> /etc/apt/apt.conf && \
  DIST=$(lsb_release -cs) &&  \
  echo "deb https://packages.icinga.com/ubuntu icinga-$DIST main" > /etc/apt/sources.list.d/$DIST-icinga.list && \
  echo "deb-src https://packages.icinga.com/ubuntu icinga-$DIST main" >> /etc/apt/sources.list.d/$DIST-icinga.list && \
  apt-get update && \
  apt-get -y install icinga2


CMD ['/bin/bash']
