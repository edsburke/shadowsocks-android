#!/bin/bash -e

TMP_DIR=`mktemp -d /tmp/acl.XXXXXX`

function fetch_data() {
  pushd ${TMP_DIR}
  curl -kLs ${TODO_URL} > ${TODO}
  popd
}

function gen_gfwlist_acl() {
  sed -i 's/.*\((^|\\.)blogspot\\.\).*/\(^|\\.)blogspot(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?){1,2}$/' acl.acl
  sed -i 's/.*\((^|\\.)google\\.\).*/\(^|\\.)google(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?){1,2}$/' acl.acl
  sed -i 's/.*\((^|\\.)googleapis\\.\).*/\(^|\\.)googleapis(\\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?){1,2}$/' acl.acl
  uniq acl.acl > ok.acl
}
