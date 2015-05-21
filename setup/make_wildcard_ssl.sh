#!/usr/bin/env bash

# Based on code from article:
# https://serversforhackers.com/self-signed-ssl-certificates

# Specify where we will install
# the xip.io certificate
SSL_DIR="/tmp/certs"

# Clean up from previous runs
rm /tmp/certs/mycert.*

# Set the wildcarded domain
# we want to use
DOMAIN="*.deisapp.com"

# A blank passphrase
PASSPHRASE=""

# Set our CSR variables
SUBJ="
C=US
ST=New York
O=
localityName=NYC
commonName=$DOMAIN
organizationalUnitName=
emailAddress=your.email@example.com
"

# Create our SSL directory
# in case it doesn't exist
mkdir -p "$SSL_DIR"

# Generate our Private Key, CSR and Certificate
openssl genrsa -out "$SSL_DIR/mycert.key" 2048
openssl req -new -subj "$(echo -n "$SUBJ" | tr "\n" "/")" -key "$SSL_DIR/mycert.key" -out "$SSL_DIR/mycert.csr" -passin pass:$PASSPHRASE
openssl x509 -req -days 365 -in "$SSL_DIR/mycert.csr" -signkey "$SSL_DIR/mycert.key" -out "$SSL_DIR/mycert.crt"