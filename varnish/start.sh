#!/bin/sh

set -xe

varnishd -a :80 \
  -f $VCL_CONFIG \
  -s malloc,${CACHE_SIZE} \
  $VARNISHD_PARAMS

sleep 1
varnishncsa
