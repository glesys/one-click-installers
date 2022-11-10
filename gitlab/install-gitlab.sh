#!/bin/bash
# Licensed under the CC0 1.0

set -x

if [ "$#" -eq 0 ]
then
    echo "Usage $0 <bootstrapPassword>"
    exit 1
fi

BOOTSTRAPPASSWORD=$1

update_apt() {
    echo "Running apt-get update.."
    apt-get update &> /dev/null
}

setup_postfix() {
    export LANG=en_US.UTF-8
    echo "postfix postfix/mailname        string  $(hostname --fqdn)" | sudo debconf-set-selections
    echo "postfix postfix/main_mailer_type        select  Internet Site" | sudo debconf-set-selections
    echo "postfix postfix/destinations    string  localhost" | sudo debconf-set-selections
    echo "postfix postfix/mynetworks      string  127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128" | sudo debconf-set-selections
    echo "postfix postfix/mailbox_limit   string  0" | sudo debconf-set-selections
    echo "postfix postfix/recipient_delim string  +" | sudo debconf-set-selections
    echo "postfix postfix/protocols       select  all" | sudo debconf-set-selections
    echo "Installing postfix..."
    apt-get install postfix -y
}

setup_ufw() {
    echo "Checking for ufw"
    if command -v ufw > /dev/null; then
        echo "ufw found. Enabling rules.."
        ufw default deny incoming
        ufw allow OpenSSH
        ufw allow http
        ufw allow https
        ufw allow 5050
        ufw --force enable
    else
        echo "UFW Not found. No firewall applied."
    fi
}

setup_gitlab() {
    echo "Fetching gitlab-ee installscript.."
    curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
    echo "Installing gitlab-ee..."
    EXTERNAL_URL="https://$(hostname --fqdn)" GITLAB_ROOT_PASSWORD="$BOOTSTRAPPASSWORD" apt-get install gitlab-ee -y
}

main() {
    update_apt
    setup_postfix
    setup_gitlab
    setup_ufw
}

main
