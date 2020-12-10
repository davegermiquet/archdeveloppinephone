#!/bin/bash

github_latest_image="https://api.github.com/repos/dreemurrs-embedded/Pine64-Arch/releases/latest"
image_download_url=`curl -L -s $github_latest_image | grep browser_download_url.*pinephone-barebone | sed s/browser_download_url\":// | sed s/\"//g`
curl -L $image_download_url | xzcat > /tmp/setup/image/pinephonearch.img

