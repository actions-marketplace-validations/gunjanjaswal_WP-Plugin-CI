# WP Plugin CI

<p>
  <a href="https://github.com/gunjanjaswal/wp-plugin-ci/actions/workflows/test.yml"><img src="https://github.com/gunjanjaswal/wp-plugin-ci/actions/workflows/test.yml/badge.svg" alt="Test"></a>
  <img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT">
  <img src="https://img.shields.io/badge/GitHub-Action-2088FF?logo=githubactions&logoColor=white" alt="GitHub Action">
</p>

A one-step quality gate for WordPress plugins. Drop it into a workflow and every push gets:

- **PHP lint** across the plugin (skipping `vendor` and `node_modules`)
- **readme.txt validation** — required headers, a Changelog section, and a short-description length check
- **Plugin Check** (optional) — runs the official WordPress Plugin Check

No server, no dependencies of your own. It runs on GitHub's runners.

## Usage

```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: gunjanjaswal/wp-plugin-ci@v1
        with:
          php-version: '8.2'
          readme: readme.txt
```

Turn on the official Plugin Check too:

```yaml
      - uses: gunjanjaswal/wp-plugin-ci@v1
        with:
          plugin-check: 'true'
```

## Inputs

| Input | Default | What it does |
| --- | --- | --- |
| `php-version` | `8.2` | PHP version used to lint. |
| `plugin-dir` | `.` | Directory scanned for `.php` files. |
| `readme` | `readme.txt` | Path to the readme to validate. Set empty to skip. |
| `plugin-check` | `false` | When `true`, runs [WordPress Plugin Check](https://github.com/WordPress/plugin-check-action) against the repo root. |

## What it checks in readme.txt

Required (a failure if missing): the `=== Name ===` header, `Stable tag`, `Requires at least`, `Tested up to`, `License`, and a `== Changelog ==` section. It also warns if the short description runs past the 150-character limit WordPress.org expects.

## Pairs well with

[wp-plugin-version-guard](https://github.com/gunjanjaswal/wp-plugin-version-guard), which fails the build when your version numbers drift apart. Run both and your plugin repo has a solid gate before every release.

## License

MIT. See [LICENSE](LICENSE).

## Author

Built by [Gunjan Jaswal](https://www.gunjanjaswal.me). If it helps, [buy me a coffee](https://ko-fi.com/gunjanjaswal).
