## pr-shard
Separate repo: https://github.com/dannf/pr-shard

## status.sh
This was originally just meant to spit out status metrics, but I started
added other subcommands to it too. It's hardcoded for a specific PR label
right now, needs to be generalized.


```
$ ~/git/rebuildutils/status.sh counts
MERGED: 190
FAILED: 30
```
FAILED means elastic-build has failed. It doesn't tell you anything about
PRs where CI is still running, or if it failed for some other reason.

You can use it to feed URLs into other tools. Here are PRs where elastic-build has failed:
```
$ ~/git/rebuildutils/status.sh failures
https://github.com/wolfi-dev/os/pull/59896
https://github.com/wolfi-dev/os/pull/59891
https://github.com/wolfi-dev/os/pull/59883
https://github.com/wolfi-dev/os/pull/59880
^C
```

Here are all open PRs (with the currently-hardcoded label):
```
~/git/rebuildutils/status.sh open
https://github.com/wolfi-dev/os/pull/59896
https://github.com/wolfi-dev/os/pull/59891
https://github.com/wolfi-dev/os/pull/59883
https://github.com/wolfi-dev/os/pull/59880
https://github.com/wolfi-dev/os/pull/59873
...
```

And PRs that match that label that have been merged:
```
$ ~/git/rebuildutils/status.sh merged | head -3
https://github.com/wolfi-dev/os/pull/59903
https://github.com/wolfi-dev/os/pull/59902
https://github.com/wolfi-dev/os/pull/59901
```

And this will set all PRs with that label to auto-merge once all checks have passed:

```
$ ~/git/rebuildutils/status.sh auto
✓ Pull request wolfi-dev/os#59896 will be automatically merged when all requirements are met
✓ Pull request wolfi-dev/os#59891 will be automatically merged when all requirements are met
⣽^C
```

## auto-review-epoch-bumps.sh
Takes a list of GH urls on stdin, checks to make sure they only comprise
epoch bumps and, if so, approves them.

This is not intended to be used blindly where potentially malicious PRs might be present, just from people you trust (but are not impervious to mistakes).

## split-out-failures.sh
If you have a PR that touches multiple packages, but some of them failed
to build in CI, you can use this tool to split those failures out into
standalone PRs.

This script currently needs to be edited with a base branch sha, and generally
isn't a great UI. Probably just best to be considered sample code for now.
