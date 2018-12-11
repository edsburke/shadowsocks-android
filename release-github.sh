#!/bin/bash -e

prepare() {
  git clone https://github.com/pexcn/shadowsocks-android.git -b release --depth 3 shadowsocks-release
  pushd shadowsocks-release
  git config user.name "pexcn"
  git config user.email "i@pexcn.me"
  git config log.date iso
  find . ! -path . | grep -vE ".git|.circleci" | xargs rm
  popd
}

release() {
  pushd shadowsocks-release
  cp ../mobile/build/outputs/apk/release/mobile-armeabi-v7a-release.apk shadowsocks-armeabi-v7a-release.apk
  cp ../mobile/build/outputs/apk/release/mobile-arm64-v8a-release.apk shadowsocks-arm64-v8a-release.apk
  cp ../mobile/build/outputs/apk/release/mobile-x86-release.apk shadowsocks-x86-release.apk
  cp ../mobile/build/outputs/apk/release/mobile-universal-release.apk shadowsocks-universal-release.apk
  popd
}

push() {
  pushd shadowsocks-release
  git add --all
  git commit -m "`date +'%Y-%m-%d %T'`"
  git push --quiet "https://${GITHUB_TOKEN}@github.com/pexcn/shadowsocks-android.git" HEAD:release
  popd
}

prepare
release
push
