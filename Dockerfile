#
# Scala and sbt Dockerfile
#
# https://github.com/spikerlabs/scala-sbt (based on https://github.com/hseeberger/scala-sbt)
#

# Pull base image
FROM  openjdk:8-jre-alpine

ARG SCALA_VERSION
ARG SBT_VERSION

ENV SCALA_VERSION ${SCALA_VERSION:-2.12.6}
ENV SBT_VERSION ${SBT_VERSION:-1.1.6}

RUN \
  echo "$SCALA_VERSION $SBT_VERSION" && \
  mkdir -p /usr/lib/jvm/java-1.8-openjdk/jre && \
  touch /usr/lib/jvm/java-1.8-openjdk/jre/release && \
  apk add --no-cache bash && \
  apk add --no-cache curl && \
  apk add --no-cache git && \
  apk add --no-cache openssh && \
  apk add --no-cache make && \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /usr/local && \
  ln -s /usr/local/scala-$SCALA_VERSION/bin/* /usr/local/bin/ && \
  scala -version && \
  scalac -version

RUN \
  curl -fsL https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz | tar xfz - -C /usr/local && \
  $(mv /usr/local/sbt-launcher-packaging-$SBT_VERSION /usr/local/sbt || true) \
  ln -s /usr/local/sbt/bin/* /usr/local/bin/ && \
  sbt sbt-version || sbt sbtVersion || true

RUN \
  curl -fsL https://git.io/vgvpD -o /usr/local/bin/coursier && \
  chmod +x /usr/local/bin/coursier && \
  coursier --help

RUN \
  coursier bootstrap com.geirsson:scalafmt-cli_2.12:1.5.0 \
    -r bintray:scalameta/maven \
    -o /usr/local/bin/scalafmt --standalone --main org.scalafmt.cli.Cli && \
  scalafmt --version
