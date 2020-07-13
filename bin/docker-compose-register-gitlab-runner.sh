#!/usr/bin/env bash
set -ex

dockerComposeRegisterGitlabRunner() {
    # expected count of 0 exits services
    GITLAB_TOKENS="$1"

    if [ -z "$1" ]; then
        echo "Please provide a token for the gitlab runner registration."
        echo "You can provide many tokens separated by commas."
        exit 1
    fi

	# https://stackoverflow.com/questions/10586153/split-string-into-an-array-in-bash
    IFS=',' read -r -a gitlab_tokens <<< "$GITLAB_TOKENS"

    for gitlab_token in "${gitlab_tokens[@]}"; do
    	docker-compose exec gitlab-runner gitlab-runner register -non-interactive --executor "docker" \
    	 --docker-image alpine:latest --url "https://gitlab.com/" --registration-token "$gitlab_token"  \
    	 --description "docker-runner" --tag-list "docker,aws" --run-untagged="true" --locked="false" \
    	 --access-level="not_protected"

	done
}

dockerComposeRegisterGitlabRunner "$@"
