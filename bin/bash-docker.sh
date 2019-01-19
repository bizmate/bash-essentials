#!/usr/bin/env bash

 docker run --rm -it \
  -v ~/.ssh/:/root/.ssh/ \
  -v "$(pwd)":/mnt \
  bash "$@"