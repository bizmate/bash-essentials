#!/usr/bin/env bash

github_ssh_file="id_rsa_github"
github_ssh_file_local_path="$HOME/.ssh/$github_ssh_file"

github_install_msg=$(cat <<'END_HEREDOC'
id_rsa_github.pub has been generated as a password less key
Please add it to your github account as shown in this article at
https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
END_HEREDOC
)

if [[ -f $github_ssh_file_local_path ]];
then
    echo "ID RSA file for Github exists.";
else
    echo "$github_ssh_file_local_path does not exist, generating"

    # the open SSL way of generating the key is not working well with Github. ssh-keygen works
    # docker run -v "$HOME":/work -w /work -it nginx openssl genrsa -out /work/.ssh/$github_ssh_file 4096
    # docker run -v "$HOME":/work -w /work -it nginx openssl rsa -in "/work/.ssh/$github_ssh_file" -pubout -out "/work/.ssh/$github_ssh_file.pub"
    # https://hub.docker.com/r/madhub/ssh-keygen
    docker run -v "$HOME":/work -w /work -it madhub/ssh-keygen ssh-keygen -b 4096 -t rsa -f "/work/.ssh/$github_ssh_file" -q -N ""
    echo "$github_install_msg"
fi


