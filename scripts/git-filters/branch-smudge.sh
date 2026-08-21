#!/bin/sh
branch=$(git rev-parse --abbrev-ref HEAD)
sed "s/__BRANCH__/$branch/g"

