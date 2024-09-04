#!/bin/sh

SCRIPT_DIR="$(cd "$(dirname $0)" && pwd)"

pushd $1 > /dev/null

./gradlew -I $SCRIPT_DIR/github-dependency-graph-gradle-plugin.init.gradle ForceDependencyResolutionPlugin_resolveAllDependencies
cat ./build/reports/dependency-graph-snapshots/dependency-graph.json

popd > /dev/null
