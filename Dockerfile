FROM centos:7
MAINTAINER stewartshea <shea.stewart@arctiq.ca>

# Inspired by billryan/gitbook:base

RUN yum install -y wget git && \
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &&\
    rpm -ivh epel-release-latest-7.noarch.rpm && \
    yum install -y npm && \
    npm install gitbook-cli -g && \
    npm install gitbook-plugin-popup

ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
 
# Install gitbook versions
RUN gitbook fetch 3.2.2 && \
    gitbook install popup


COPY docs/ ${APP_ROOT}/docs/
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd 

WORKDIR ${APP_ROOT}

EXPOSE 4000

VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data

CMD ["/bin/bash", "-c", "${APP_ROOT}/bin/run.sh"]
