# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal tech blog (Traditional Chinese) built with Jekyll and served by GitHub Pages from
`https://github.com/linyork/linyork.github.io`. The Leonids theme is **vendored into the repo**
(no gem/remote theme) — `_layouts/`, `_includes/`, and `_sass/` are the theme, edit them directly.

## Commands

Local dev runs Jekyll in Docker; there is no local Ruby/bundle setup checked in.

```bash
./start-dev.sh
```

```cmd
start-dev.bat
```

Both wrap the same thing — serve on http://localhost:4000 with livereload (port 35729):

```bash
docker run --rm -it --name jekyll-blog --volume="$(pwd)":/srv/jekyll -p 4000:4000 -p 35729:35729 jekyll/jekyll:4 jekyll serve --config _config.yml,_config_dev.yml --watch --force_polling --host 0.0.0.0 --incremental --livereload
```

- These run in the foreground (`-it`) — good for watching the log by hand. `dev-verify.sh` below runs
  the same container detached; the two cannot both hold port 4000.
- Hot reload is only partly reliable — see the next section before trusting what the browser shows.
- To clear a bad build: delete `_site/`, `.jekyll-cache/`, `.sass-cache/`, `.jekyll-metadata` (all gitignored).
- There is no test, lint, or CI step. Pushing to `master` is the deploy — GitHub Pages builds it.

## Verify a change (standardised smoke test)

```bash
./dev-verify.sh
```

Starts Docker if needed, restarts the server on a clean build, then checks routes, build
errors, that the newest posts reach the listing pages, and that dev-only files are not
published. Prints `PASS`/`FAIL` and exits non-zero on failure. `./dev-verify.sh --stop`
stops it. Full rationale and measurements: `docs/本地驗證流程.md`.

**The file watcher does not regenerate listing pages.** Measured: adding a post regenerates
its own page (200) but `/` and `/archive/` never pick it up — with or without
`--incremental`. The log says `Regenerating: 1 file(s) changed` while `_site/index.html`
is never rewritten. Only a restart on a cleared `_site/` fixes it. So:

- editing a post's **body** → the watcher is enough, just refresh that page;
- **adding/renaming/re-dating/re-titling** a post, or touching `_config.yml`, `_layouts/`,
  `_includes/` → re-run `./dev-verify.sh`, otherwise the listing pages you are looking at
  are stale.

## Jekyll version (verified — local matches production)

The image is `jekyll/jekyll:4` (ships Jekyll 4.2.2), but its entrypoint runs `bundle install`
against the repo `Gemfile`, so `jekyll serve` resolves through the bundle and actually runs
**Jekyll 3.10.0** — the same version GitHub Pages uses. There is no local/production version
skew. Only plugins on the GitHub Pages allowlist work: `jekyll-sitemap`, `jekyll-feed`,
`jekyll-seo-tag` (declared in `_config.yml`).

## Config layering

`_config_dev.yml` is layered over `_config.yml` only in the dev scripts. It blanks `url` (so assets
resolve relatively from either `localhost` or `127.0.0.1`) and enables `show_drafts` + `future`, so
`_drafts/` and future-dated posts render locally but never in production.

`site.url` (`https://linyork.github.io`) is baked into share-button links (`_layouts/post.html`) and
JSON-LD breadcrumbs (`_includes/seo_schema.html`). The README claims a custom domain
(`york.hypenode.tw`) but there is no `CNAME` in the repo — if a custom domain is in play it is set in
GitHub Pages settings only, and `site.url` would need updating to match.

## Writing posts

`_posts/YYYY-MM-DD-title.md` (Chinese filenames are used throughout; keep everything UTF-8).

```markdown
---
layout: post
title: "文章標題"
description: "used by jekyll-seo-tag for the meta description"
categories: [AI Paper]
tags:
- AI
- LLM
---

Intro paragraph.

<!-- more -->

Body...
```

Conventions that matter:
- **`<!-- more -->` is the `excerpt_separator`.** The homepage (`_layouts/post_listing.html`) renders
  `post.excerpt`, so text before this marker is the listing blurb. Omit it and the whole post shows.
- **Permalinks are `/articles/:year-:month/:title`.** Renaming a post file or changing its date
  changes its live URL — avoid on published posts.
- `categories` accepts a string (`categories: AI`) or a list; both appear in the repo. Categories link
  to `/categories/#<name>`; tags to `/tags/#<slug>`.
- `date:` in front matter is optional (the filename supplies it) but is used when present.
- Optional `image.feature` (a filename resolves against `/img/`, or a full URL) renders a hero image.
- Drafts go in `_drafts/` — visible locally via `show_drafts`, never published.

## Structure notes

- **Sidebar nav is auto-generated** from every `site.pages` entry that has a `title` in its front
  matter (`_includes/sidebar.html`). Adding a top-level page with a title adds it to the nav; omit
  the title to keep it out.
- **The homepage has no pagination** — `post_listing` loops all of `site.posts`.
- **Resume page** (`resume.html` → `_layouts/resume.html`) is data-driven: `_includes/sections/*.html`
  read `_data/index/{careers,education,projects,skills}.yml`. Edit the YAML, not the HTML, for content
  changes. `skills.yml` drives a Chart.js radar chart via parallel comma-separated `aspects`/`percentage`
  strings — the two lists must stay the same length.
- **Sass entry point is `css/main.scss`** (needs its empty front-matter `---` block to be processed).
  New partials in `_sass/components/` or `_sass/pages/` must be added to its `@import` list. Shared
  colors, breakpoints, and type scale live in `_sass/components/_variables.scss`.
- **Any `.md` added at the repo root becomes a published page** — Jekyll renders it to `.html`,
  lists it in `sitemap.xml`, and `_includes/sidebar.html` adds it to the nav. `docs/`, `README.md`,
  `LICENSE.txt`, and `CLAUDE.md` are in the `_config.yml` `exclude` list for this reason; add any
  new root-level doc there too (`dev-verify.sh` step 6 guards this).
- jQuery 3.7.1 and Font Awesome 6 are loaded globally; `js/main.js` is an empty ready-handler stub.
- Google AdSense and `ads.txt` are wired up in `_includes/head.html`; Google Analytics and Disqus are
  conditional on `site.owner.google.analytics` / `site.owner.disqus-shortname`, both currently blank.
