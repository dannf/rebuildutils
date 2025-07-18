#!/bin/sh

set -ex

label="666-files"
urls="$(gh pr list --limit 1000 --label $label --json url | jq -r '.[].url')"
for url in $urls; do
    if gh pr diff $url | grep -v ^--- | grep -v ^+++ | \
	    grep -e ^- -e ^+ | grep -v -E '^.  epoch: ([0-9])+$'; then
	continue
    fi
    gh pr review $url --approve || /bin/true
done
