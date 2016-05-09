# --------------------------------------------------------------------------
# This is a Dockerfile to build a Python / Alpine Linux image with
# luigid running on port 8082
# --------------------------------------------------------------------------

FROM python:alpine

MAINTAINER  Tim Birkett <tim@birkett-bros.com> (@pysysops)

ARG user=app
ARG group=app
ARG uid=2101
ARG gid=2101

# The luigi app is run with user `app`, uid = 2101
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN addgroup -g ${gid} ${group} \
    && adduser -u ${uid} -G ${group} -D -s /bin/bash ${user}

RUN mkdir /etc/luigi
ADD ./etc/luigi/logging.cfg /etc/luigi/
ADD ./etc/luigi/client.cfg /etc/luigi/
VOLUME /etc/luigi

RUN mkdir -p /luigi/tasks
RUN mkdir -p /luigi/work
RUN mkdir -p /luigi/outputs

ADD ./luigi/taskrunner.sh /luigi/
ADD ./luigi/tasks/hello_world.py /luigi/tasks

RUN chown -R ${user}:${group} /luigi

VOLUME /luigi/work
VOLUME /luigi/tasks
VOLUME /luigi/outputs

# Build deps for pip modules
RUN apk add --no-cache postgresql-dev freetds freetds-dev gcc make musl-dev

USER ${user}

RUN pyvenv /luigi/.pyenv \
    && source /luigi/.pyenv/bin/activate \
    && pip install sqlalchemy luigi pymssql psycopg2 alembic pandas

ENTRYPOINT ["/luigi/taskrunner.sh"]
