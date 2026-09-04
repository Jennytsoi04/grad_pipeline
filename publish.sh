#!/bin/bash
# Publish this folder to GitHub Pages.
#   First time:  ./publish.sh https://github.com/USER/grad-pipeline.git
#   After that:  ./publish.sh
set -e
cd "$(dirname "$0")"

if [ ! -d .git ]; then
  echo "Setting up the repository for the first time..."
  git init -b main
fi

if [ -n "$1" ]; then
  git remote remove origin 2>/dev/null || true
  git remote add origin "$1"
  echo "Remote set to $1"
fi

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "No remote set yet. Run it once with your repo URL:"
  echo "  ./publish.sh https://github.com/YOUR-USERNAME/grad-pipeline.git"
  exit 1
fi

if [ -z "$(git config user.email)" ] && [ -z "$(git config --global user.email)" ]; then
  echo "Git needs to know who you are. Run these two lines once, then try again:"
  echo '  git config --global user.name "Your Name"'
  echo '  git config --global user.email "your@email.com"'
  exit 1
fi

git add -A
if git diff --cached --quiet; then
  echo "Nothing has changed since the last publish."
  exit 0
fi

git commit -m "Update grad pipeline ($(date +%Y-%m-%d))"
git push -u origin main
echo
echo "Pushed. If this was the first time, now turn Pages on:"
echo "  repo -> Settings -> Pages -> Deploy from a branch -> main -> /(root) -> Save"
