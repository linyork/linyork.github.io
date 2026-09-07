#!/bin/bash
# Standardised local smoke test for the blog.
#
#   ./dev-verify.sh          start (or restart) the server, then verify
#   ./dev-verify.sh --stop   stop the server
#
# Always RESTARTS rather than reusing a running container: the Jekyll file
# watcher does not regenerate listing pages (/, /archive/, /tags/,
# /categories/) when a post is added, renamed or re-dated, so a long-lived
# container silently serves a stale index. See docs/本地驗證流程.md.

set -u
NAME=jekyll-blog
BASE=http://localhost:4000
ROOT="$(cd "$(dirname "$0")" && { pwd -W 2>/dev/null || pwd; })"
fail=0

stop() { docker stop "$NAME" >/dev/null 2>&1 && echo "stopped $NAME" || echo "$NAME not running"; }
[ "${1:-}" = "--stop" ] && { stop; exit 0; }

check() { # check <expected-code> <path>
  code=$(curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$BASE$2")
  if [ "$code" = "$1" ]; then printf '  ok   %s  %s\n' "$code" "$2"
  else printf '  FAIL %s (want %s)  %s\n' "$code" "$1" "$2"; fail=1; fi
}
grep_page() { # grep_page <path> <pattern> <description>
  if curl -s --max-time 10 "$BASE$1" | grep -q "$2"; then printf '  ok   %s\n' "$3"
  else printf '  FAIL %s\n' "$3"; fail=1; fi
}
absent() { # absent <path> <pattern> <description>
  if curl -s --max-time 10 "$BASE$1" | grep -q "$2"; then printf '  FAIL %s\n' "$3"; fail=1
  else printf '  ok   %s\n' "$3"; fi
}

echo "== 1. docker daemon =="
if ! docker info >/dev/null 2>&1; then
  echo "  daemon down - launching Docker Desktop"
  powershell.exe -NoProfile -Command 'Start-Process "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe"' >/dev/null 2>&1
  for i in $(seq 1 90); do docker info >/dev/null 2>&1 && break; sleep 2; done
fi
docker info >/dev/null 2>&1 || { echo "  FAIL docker daemon unavailable"; exit 1; }
echo "  ok   daemon $(docker info --format '{{.ServerVersion}}')"

echo "== 2. restart server on a clean build =="
stop >/dev/null
rm -rf _site .jekyll-cache .sass-cache .jekyll-metadata
docker run --rm -d --name "$NAME" \
  --volume "$ROOT:/srv/jekyll" -p 4000:4000 -p 35729:35729 \
  jekyll/jekyll:4 \
  jekyll serve --config _config.yml,_config_dev.yml \
  --watch --force_polling --host 0.0.0.0 --livereload >/dev/null || exit 1

for i in $(seq 1 150); do
  [ "$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 "$BASE/" 2>/dev/null)" = "200" ] && break
  docker ps --format '{{.Names}}' | grep -q "^$NAME\$" || { echo "  FAIL container died"; docker logs "$NAME" 2>&1 | tail -20; exit 1; }
  sleep 2
done
echo "  ok   serving on $BASE"

echo "== 3. build errors =="
if docker logs "$NAME" 2>&1 | grep -qiE '^\s*(Error|Liquid (Exception|Warning))'; then
  echo "  FAIL build errors in log:"; docker logs "$NAME" 2>&1 | grep -iE '^\s*(Error|Liquid (Exception|Warning))' | head; fail=1
else echo "  ok   no build errors"; fi

echo "== 4. routes =="
for p in / /archive/ /tags/ /categories/ /resume/ /feed.xml /sitemap.xml /css/main.css; do check 200 "$p"; done

echo "== 5. newest posts reach the listing pages =="
# ASCII-safe: match the permalink prefix (/articles/YYYY-MM/) of the newest post,
# never the Chinese title - byte-slicing UTF-8 titles corrupts the pattern.
newest=$(ls -1 _posts/*.md | sort | tail -1)
ym=$(basename "$newest" | cut -d- -f1,2)
grep_page / "/articles/$ym/" "homepage lists newest post month ($ym)"
grep_page /archive/ "/articles/$ym/" "archive lists newest post month ($ym)"
want=$(ls -1 _posts/*.md | wc -l)
got=$(curl -s --max-time 10 "$BASE/" | grep -c '<section class="post">')
if [ "$got" -ge "$want" ]; then printf '  ok   homepage lists %s sections (>= %s posts)
' "$got" "$want"
else printf '  FAIL homepage lists %s sections, expected >= %s
' "$got" "$want"; fail=1; fi

echo "== 6. dev-only files must not be published =="
for p in /CLAUDE.md /CLAUDE.html /README.md; do check 404 "$p"; done
absent /sitemap.xml CLAUDE "CLAUDE.md absent from sitemap"
absent / 'claude.md' "CLAUDE.md absent from sidebar nav"

echo
[ $fail -eq 0 ] && echo "PASS - all checks green. Open $BASE" || echo "FAIL - see above"
exit $fail
