#!/usr/bin/env bash

apt update && apt -y install openjdk-17-jdk-headless postgresql-16-pljava


#RUN mkdir /var/custom
#COPY --chmod=0777 entrypoint.sh /var/custom/
#RUN /var/custom/entrypoint.sh
#RUN apt update && apt -y install openjdk-17-jdk-headless postgresql-16-pljava

#RUN apt-get update && \
#    apt-get --fix-missing -y --allow-change-held-packages --no-install-recommends install git ca-certificates \
#    init-system-helpers g++ maven postgresql-server-dev-17 libpq-dev libecpg-dev libkrb5-dev openjdk-17-jdk-headless postgresql-16-pljava libssl-dev && \
##    git clone https://github.com/tada/pljava.git && \
##    cd pljava && \
##    git config advice.detachedHead false && \
##    git checkout tags/V1_6_6 && \
##    mvn clean install && \
##    java -jar $(ls /pljava/pljava-packaging/target/pljava-pg15.jar) && \
#    cd ../ && \
#    apt-get -y remove --purge --auto-remove git ca-certificates g++ maven postgresql-server-dev-17 libpq-dev libecpg-dev openjdk-17-jdk-headless libkrb5-dev libssl-dev && \
#    apt-get --fix-missing -y --allow-change-held-packages --no-install-recommends install openjdk-17-jdk-headless && \
#    apt-get -y clean autoclean autoremove && \
#    rm -rf ~/.m2 /var/lib/apt/lists/* /tmp/* /var/tmp/*