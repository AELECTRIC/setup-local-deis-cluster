#!/usr/bin/env bash

./make_wildcard_ssl.sh
echo "Adding wildcard SSL to deis"
deisctl config router set sslKey=/tmp/certs/mycert.key sslCert=/tmp/certs/mycert.crt