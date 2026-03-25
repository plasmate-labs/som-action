# Plasmate SOM Action

[![GitHub Action](https://img.shields.io/badge/GitHub-Action-blue?style=for-the-badge&logo=github)](https://github.com/marketplace/actions/plasmate-som-fetch)

A GitHub Action that fetches a web page with [Plasmate](https://github.com/nickthecook/plasmate) and outputs the **Semantic Object Model (SOM)**.

## Usage

```yaml
- uses: plasmate-labs/som-action@v1
  with:
    url: https://example.com
  id: som

- run: echo "Page title: ${{ steps.som.outputs.title }}"
```

## Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `url` | ✅ | — | URL to fetch |
| `format` | ❌ | `json` | Output format (`json` or `text`) |

## Outputs

| Output | Description |
|--------|-------------|
| `som` | The full SOM JSON output |
| `title` | Page title extracted from the SOM |
| `tokens` | Approximate token count of the SOM |

## Examples

### Fetch and use in subsequent steps

```yaml
name: Scrape and Process

on:
  workflow_dispatch:
    inputs:
      url:
        description: 'URL to scrape'
        required: true

jobs:
  scrape:
    runs-on: ubuntu-latest
    steps:
      - uses: plasmate-labs/som-action@v1
        with:
          url: ${{ github.event.inputs.url }}
        id: som

      - name: Display results
        run: |
          echo "Title: ${{ steps.som.outputs.title }}"
          echo "Tokens: ${{ steps.som.outputs.tokens }}"

      - name: Save SOM
        run: echo '${{ steps.som.outputs.som }}' > som.json

      - uses: actions/upload-artifact@v4
        with:
          name: som-output
          path: som.json
```

### Scheduled monitoring

```yaml
name: Monitor Page Changes

on:
  schedule:
    - cron: '0 */6 * * *'  # Every 6 hours

jobs:
  monitor:
    runs-on: ubuntu-latest
    steps:
      - uses: plasmate-labs/som-action@v1
        with:
          url: https://example.com/status
        id: som

      - name: Check for changes
        run: |
          echo "Current title: ${{ steps.som.outputs.title }}"
          # Add your change detection logic here
```

## How It Works

1. Builds a Docker container with Plasmate installed
2. Fetches the specified URL using `plasmate fetch`
3. Parses the SOM JSON to extract metadata
4. Outputs the full SOM and extracted fields as step outputs

## License

MIT
