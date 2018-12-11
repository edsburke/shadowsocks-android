#!/bin/bash -e

GFWLIST_URL='https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt'
CHNROUTE_URL='https://pexcn.me/daily/chnroute/chnroute.txt'

function fetch_data() {
  mkdir gen

  pushd gen
  curl -kLs ${GFWLIST_URL} > gfwlist.txt
  curl -kLs ${CHNROUTE_URL} > chnroute.txt
  popd
}

function gen_gfwlist_acl() {
  pushd gen
  ../parse.py -i gfwlist.txt -f gfwlist.tmp
  sed -i 's/.*\((^|\\.)blogspot\\.\).*/\(^|\\.)blogspot(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?){1,2}$/' gfwlist.tmp
  sed -i 's/.*\((^|\\.)google\\.\).*/\(^|\\.)google(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?){1,2}$/' gfwlist.tmp
  sed -i 's/.*\((^|\\.)googleapis\\.\).*/\(^|\\.)googleapis(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?){1,2}$/' gfwlist.tmp
  uniq gfwlist.tmp > gfwlist.acl
  popd
}

fetch_data
gen_gfwlist_acl
