#!/bin/bash
cd $(dirname $0)/..
watchexec -r -w src  -- ./dev/build-exec.sh "$@"