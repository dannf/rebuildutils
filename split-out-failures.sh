#!/bin/sh

set -ex

REMOTE=dannf
tmpfile="$(mktemp)"
splittmp="$(mktemp)"
trap "rm -f $tmpfile $splittmp" EXIT

base=5f0e44705f72c764ffdd7713e55b7d24025025ad
git log $base..HEAD --oneline | cut -d' ' -f1 | tac > "$tmpfile"
git reset --hard $base
for c in $(cat "$tmpfile"); do
    skipped=0
    for f in $@; do
	if git show $c -- "$f" | grep .; then
	    echo $c >> "$splittmp"
	    skipped=1
	    break
	fi
    done
    if [ "$skipped" -eq 1 ]; then
	echo "SKIPPING $(git show $c --oneline)"
	continue
    fi
    git cherry-pick $c
done
git push -f dannf

for c in $(cat "$splittmp"); do
    pkg="$(git show --name-only --format='' $c | sed 's/\.yaml$//')"
    git checkout -b "${pkg}/666-rebuild" $base
    git cherry-pick "$c"
    git push -u $REMOTE
    gh pr create -f -F /dev/null --label 666-files
    gh pr merge --merge --auto
done
