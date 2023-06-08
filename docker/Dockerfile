# Only 3.15 includes python2
FROM alpine:3.15
RUN apk add --update --no-cache \
    sudo bash \
    git \
    python2

RUN git config --global --add safe.directory '*'

COPY . /gitinspector

RUN chmod +x /gitinspector/docker/docker-entrypoint.sh \
    /gitinspector/gitinspector.py


WORKDIR /gitinspector

USER root

ENTRYPOINT ["/gitinspector/docker/docker-entrypoint.sh"]

CMD [""]

VOLUME /git-projects
VOLUME /output-reports

ENV LANG en_US.UTF-8
