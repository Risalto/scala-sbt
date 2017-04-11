#!/usr/bin/env bash
scala_versions=(
  2.11.8
  2.12.1
)
sbt_versions=(
  0.13.12
  0.13.13
  0.13.15
)
for scala_version in ${scala_versions[@]}; do
  for sbt_version in ${sbt_versions[@]}; do
    version=scala-${scala_version}-sbt-${sbt_version}
    docker build -t spikerlabs/scala-sbt:${version} --build-arg SCALA_VERSION=${scala_version} --build-arg SBT_VERSION=${sbt_version} .
    docker push spikerlabs/scala-sbt:${version}
    echo "Built ${version}"
  done
done