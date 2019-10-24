#!/bin/sh

set -xe

varnishd -a :90 \
  -b 8080
  -f $VCL_CONFIG \
  -s malloc,${CACHE_SIZE} \
  $VARNISHD_PARAMS

sleep 1
varnishncsa
