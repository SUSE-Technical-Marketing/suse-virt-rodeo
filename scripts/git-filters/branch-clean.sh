#!/bin/sh
branch=$(git rev-parse --abbrev-ref HEAD)
sed "s/$branch/__BRANCH__/g"
