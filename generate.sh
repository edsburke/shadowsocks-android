#!/bin/bash -e

GFWLIST_URL='https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt'
CHNROUTE_URL='https://pexcn.me/daily/chnroute/chnroute.txt'

function fetch_data() {
  mkdir -p gen

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

function gen_china_list_acl() {
  pushd gen
  cp ../template/china-list.acl .
  sed -i "s/___CHNROUTE_LIST_PLACEHOLDER___/cat chnroute.txt/e" china-list.acl
  popd
}

function gen_bypass_acl() {
  pushd gen
  cp ../template/bypass-china.acl .
  cp ../template/bypass-lan-china.acl .
  sed -e '1,/proxy_list/d' gfwlist.acl > proxylist.txt
  sed -i "s/___CHNROUTE_LIST_PLACEHOLDER___/cat chnroute.txt/e" bypass-china.acl bypass-lan-china.acl
  sed -i "s/___GFWLIST_PROXY_LIST_PLACEHOLDER___/cat proxylist.txt/e" bypass-china.acl bypass-lan-china.acl
  popd
}

function dist_release() {
  mkdir -p dist/acl
  cp gen/gfwlist.acl dist/acl/
  cp gen/china-list.acl dist/acl/
  cp template/bypass-lan.acl dist/acl/
  cp gen/bypass-china.acl dist/acl/
  cp gen/bypass-lan-china.acl dist/acl/
}

fetch_data
gen_gfwlist_acl
gen_china_list_acl
gen_bypass_acl
dist_release
