#!/bin/bash
set -e

URL=$1
FORMAT=${2:-json}

if [ -z "$URL" ]; then
  echo "Error: URL is required" >&2
  exit 1
fi

SOM=$(plasmate fetch "$URL" 2>/dev/null)

# Handle multiline output for GITHUB_OUTPUT
{
  echo "som<<EOF"
  echo "$SOM"
  echo "EOF"
} >> "$GITHUB_OUTPUT"

# Extract title
TITLE=$(echo "$SOM" | python3 -c "import sys,json; print(json.load(sys.stdin).get('title',''))" 2>/dev/null || echo "")
echo "title=$TITLE" >> "$GITHUB_OUTPUT"

# Count approximate tokens (chars / 4)
TOKENS=$(echo "$SOM" | wc -c | awk '{printf "%d", $1/4}')
echo "tokens=$TOKENS" >> "$GITHUB_OUTPUT"

if [ "$FORMAT" = "text" ]; then
  echo "$SOM" | python3 -c "
import sys, json
som = json.load(sys.stdin)
print(f\"Title: {som.get('title', 'N/A')}\")
for r in som.get('regions', []):
    print(f\"[{r['role']}] {r.get('id', '')}\")
    for el in r.get('elements', []):
        print(f\"  {el['role']}: {el.get('text', '')[:80]}\")
" 2>/dev/null
else
  echo "$SOM"
fi
