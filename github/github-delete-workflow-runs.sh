#!/bin/sh

WORKFLOW=$1

gh run list --limit 500 --workflow "$WORKFLOW" --json databaseId | jq -r ".[] | .databaseId | @sh" | xargs -I{} gh run delete "{}"
