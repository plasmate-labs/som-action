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


---

## Part of the Plasmate Ecosystem

| | |
|---|---|
| **Engine** | [plasmate](https://github.com/plasmate-labs/plasmate) - The browser engine for agents |
| **MCP** | [plasmate-mcp](https://github.com/plasmate-labs/plasmate-mcp) - Claude Code, Cursor, Windsurf |
| **Extension** | [plasmate-extension](https://github.com/plasmate-labs/plasmate-extension) - Chrome cookie export |
| **SDKs** | [Python](https://github.com/plasmate-labs/plasmate-python) / [Node.js](https://github.com/plasmate-labs/quickstart-node) / [Go](https://docs.plasmate.app/sdk-go) / [Rust](https://github.com/plasmate-labs/quickstart-rust) |
| **Frameworks** | [LangChain](https://github.com/langchain-ai/langchain/pull/36208) / [CrewAI](https://github.com/plasmate-labs/crewai-plasmate) / [AutoGen](https://github.com/plasmate-labs/autogen-plasmate) / [Smolagents](https://github.com/plasmate-labs/smolagents-plasmate) |
| **Tools** | [Scrapy](https://github.com/plasmate-labs/scrapy-plasmate) / [Audit](https://github.com/plasmate-labs/plasmate-audit) / [A11y](https://github.com/plasmate-labs/plasmate-a11y) / [GitHub Action](https://github.com/plasmate-labs/som-action) |
| **Resources** | [Awesome Plasmate](https://github.com/plasmate-labs/awesome-plasmate) / [Notebooks](https://github.com/plasmate-labs/notebooks) / [Benchmarks](https://github.com/plasmate-labs/plasmate-benchmarks) |
| **Docs** | [docs.plasmate.app](https://docs.plasmate.app) |
| **W3C** | [Web Content Browser for AI Agents](https://www.w3.org/community/web-content-browser-ai/) |
