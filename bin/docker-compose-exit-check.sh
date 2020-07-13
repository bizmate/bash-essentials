#!/usr/bin/env bash
set -e

dockerComposeExitCheck () {
    # expected count of 0 exits services
    EXPECTED_COUNT="${1:-1}"

    MAX_ATTEMPTS=20
    ATTEMPTS=0
    while [ $ATTEMPTS -le $MAX_ATTEMPTS ]; do
        ATTEMPTS=$(( ATTEMPTS + 1 ))

        echo "Waiting for  $EXPECTED_COUNT - (attempt: $ATTEMPTS)..."
        DOCKER_PS_COUNT=$( docker-compose ps | awk '/Exit/ {print $6}' | grep -ce ^0$ )
        if [ "$DOCKER_PS_COUNT" -eq "$EXPECTED_COUNT" ]; then
          echo "Containers are Ready!"
          break
        else
          echo "Containers NOT Ready!"
        fi
        sleep 2
    done

    # https://github.com/koalaman/shellcheck/wiki/SC2181
    if [ "$DOCKER_PS_COUNT" -ne "$EXPECTED_COUNT" ] ; then
      echo "Containers are not ready, exiting with error!"
      exit 1
    fi
}

dockerComposeExitCheck "$@"
