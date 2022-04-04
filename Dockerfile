FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
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
  apt-get -y install nano net-tools icinga2 icinga2-ido-mysql icingaweb2 icingacli icingaweb2-module-pnp icingaweb2-module-statusmap monitoring-plugins && \
  apt-get autoremove -y  && \
  apt-get autoclean -y  && \
  rm -rf /var/lib/apt/lists/*


COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
#CMD /bin/bash