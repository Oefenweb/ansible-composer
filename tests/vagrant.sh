#!/usr/bin/env bash
#
# set -x;
set -e;
set -o pipefail;
#
thisFile="$(readlink -f ${0})";
thisFilePath="$(dirname ${thisFile})";

# Only provision once
if [[ -f /provisioned ]]; then
  exit 0;
fi

export DEBIAN_FRONTEND=noninteractive;

shopt -s expand_aliases;
alias apt-update='apt-get update -qq';
alias apt-install='apt-get install -q -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"';

distributor_id="$(lsb_release -i | awk '{print $3}' | tr '[:upper:]' '[:lower:]')";
distributor_version="$(lsb_release -r | awk '{print $2}')";
major_version="$(echo ${distributor_version} | awk -F. '{print $1}')";

PHP_VERSION='';
if [ "${distributor_id}" = 'ubuntu' ] && [ "${major_version}" -le "14" ]; then
    PHP_VERSION='5';
elif [ "${distributor_id}" = 'debian' ] && [ "${major_version}" -le "8" ]; then
    PHP_VERSION='5';
fi
apt-update && apt-install "php${PHP_VERSION}-cli" curl;

touch /provisioned;
