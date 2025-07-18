#!/bin/sh

### NEEDS LATEST VERSION OF gh (2.75 works)
set -e

list_open() {
    gh pr list --limit 1000 --label 666-files --state open --json url | jq -r '.[].url'
}

list_merged() {
    gh pr list --limit 1000 --label 666-files --state merged --json url | jq -r '.[].url'
}

list_failed() {
    gh pr list --label 666-files --json url,number | jq -r '.[] | "\(.number) \(.url)"' | while read pr_number url; do
	checks_output=$(gh pr checks $pr_number --json state 2>/dev/null)
    
	if [ -n "$checks_output" ] && [ "$checks_output" != "[]" ]; then
            failed_checks=$(echo "$checks_output" | jq -r '.[] | select(.state == "FAILURE" or .state == "CANCELLED" or .state == "TIMED_OUT") | .state' | wc -l)
            if [ "$failed_checks" -gt 0 ]; then
		echo "$url"
            fi
	fi
    done
}

auto() {
    gh pr list --limit 1000 --label 666-files --json number | jq -r '.[].number' | while read url; do gh pr merge --merge --auto $url; done
}

case $1 in
    auto)
	auto
	;;
    open)
	list_open
	;;
    merged)
	list_merged
	;;
    fail*)
	list_failed
	;;
    counts)
	echo "MERGED: $(list_merged | wc -l)"
	echo "FAILED: $(list_failed | wc -l)"
	;;
    *)
	;;
esac

	
