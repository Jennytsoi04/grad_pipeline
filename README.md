# Grad Pipeline — hosted build

The app shell only. **No job data is in this folder**, by design: GitHub Pages
sites are public, so nothing about the job search is published. Your board
lives in your browser's local storage, per device.

## Publish it once

1. On github.com, create a new repository named `grad-pipeline`. Public.
   Do not add a README or .gitignore — this folder already has what it needs.
2. In Terminal:

       cd ~/Desktop/job_seeking/grad-pipeline-site
       ./publish.sh https://github.com/YOUR-USERNAME/grad-pipeline.git

   Git will ask you to sign in to GitHub. That happens in your own terminal —
   Claude never sees the credential.
3. In the repo: **Settings → Pages → Source: Deploy from a branch → main →
   /(root) → Save.**
4. Wait about a minute. The site is at
   `https://YOUR-USERNAME.github.io/grad-pipeline/`

## Load your board onto it

Open `../pipeline.html` on your laptop, click **Copy JSON**, then on the
hosted site click **Paste JSON**. Repeat once per device (phone, other laptop).

## When Claude changes the app

Claude rewrites `index.html` here. Then:

    cd ~/Desktop/job_seeking/grad-pipeline-site
    ./publish.sh

with no argument — it reuses the remote you set the first time. Your board is
untouched: it lives in the browser, not in the file.

## Syncing your board back to Claude

Click **Copy JSON** on whichever device is most current and paste it into
Claude. Claude writes the changes into `01_Jobs/` — that folder, not the
browser, is the permanent record.
