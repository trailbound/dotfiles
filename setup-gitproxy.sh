#!/bin/bash

# Sets URL redirects for use when we need to use our gitproxy
git config --global url."gitproxy:".insteadOf https://github.com/
git config --global --add url."gitproxy:".insteadOf git://github.com/
