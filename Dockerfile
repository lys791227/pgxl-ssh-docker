FROM  pavouk0/postgres-xl:XL_10_R1_1-313-g31dfe47-20-g2513967
USER root
RUN apt-get update && \
        apt-get  install -y apt-utils  dnsutils procps  vim tzdata curl ssh  jq sudo
RUN rm /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone
RUN     apt-get -qq update && \
        apt-get -qq install wget lsb-release gnupg2 && \
        apt-get -qq purge wget && \
        apt-get -qq autoclean && apt-get -qq autoremove && rm -rf /tmp/* /var/cache/apt/* /var/cache/depconf/*
ENV TZ="Asia/Shanghai"
RUN sed -i "/StrictHostKeyChecking/d" /etc/ssh/ssh_config && echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
COPY etcdctl  /usr/bin/etcdctl
COPY mc  /usr/bin/mc
COPY rclone  /usr/bin/rclone
COPY zookeepercli  /usr/bin/zookeepercli
RUN  chmod 755 /usr/bin/etcdctl
RUN  chmod 755 /usr/bin/mc
RUN  chmod 755 /usr/bin/rclone
RUN  chmod 755 /usr/bin/zookeepercli
COPY ssh-keys /root/.ssh
RUN  chmod 755  /root/.ssh
RUN sed -i '/^postgres          ALL=(ALL)       NOPASSWD: ALL$/d' /etc/sudoers && sed -i '$a\postgres          ALL=(ALL)       NOPASSWD: ALL' /etc/sudoers
USER postgres
COPY --chown=postgres:postgres ssh-keys /tmp/.ssh
COPY --chown=postgres:postgres ssh-keys /var/lib/postgres/.ssh



