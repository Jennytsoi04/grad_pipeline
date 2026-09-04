# Grad Pipeline

A job application tracker. Multi-user: people sign up with an email and
password, and each account sees only its own applications. Static frontend,
Supabase for auth and storage — so it runs on free static hosting with no
server to maintain.

    index.html    the whole app
    config.js     your Supabase project URL + anon key (you fill this in)
    schema.sql    run once in Supabase to create the table + security rules
    seed.sql      optional: loads the jobs you were tracking before
    publish.sh    pushes to GitHub Pages

## Setup, once

**1. Create the database**

Sign up at supabase.com (free) and create a project. Then in the project:
**SQL Editor -> New query**, paste the whole of `schema.sql`, press **Run**.

That creates one table and four Row Level Security policies. The policies are
the important part: they live in Postgres, not in the app, and they make it
impossible for one signed-in user to read another's rows. A bug in the
frontend cannot leak someone's applications.

**2. Connect the app**

In Supabase: **Project Settings -> API**. Copy two values into `config.js`:

- **Project URL** -> `SUPABASE_URL`
- **anon public** key -> `SUPABASE_ANON_KEY`

The anon key is *designed* to be published in browser code. Row Level
Security is what protects the data, not key secrecy. This is why the whole
app can live in a public repo.

**Never** put the `service_role` key in `config.js`. It bypasses every
security policy. If you ever commit it by accident, rotate it immediately in
the Supabase dashboard.

**3. Publish**

    ./publish.sh

Then GitHub: repo -> **Settings -> Pages -> Deploy from a branch -> main ->
/(root) -> Save**.

## Before other people use it

Two Supabase defaults that matter for a real product:

- **Email confirmation is on by default.** New users get a confirmation link
  before they can sign in. Good for production, annoying while testing. Toggle
  it under **Authentication -> Sign In / Providers -> Email**.
- **The built-in email sender is rate-limited** to a handful of messages per
  hour. Fine for you and a few friends, not enough for real signups. For that,
  connect your own SMTP under **Authentication -> Emails -> SMTP Settings**
  (Resend, Postmark and SendGrid all have free tiers).

Also worth knowing: **free Supabase projects pause after about a week of no
activity.** One click in the dashboard unpauses it and nothing is lost, but a
paused project means the app cannot load.

And once other people's data is in your database, you are holding their
personal information. Hong Kong's PDPO applies, and GDPR too if anyone
signing up is in the EU. At minimum that means a way for someone to delete
their account and a short note saying what you store. Worth doing before you
share the link widely.

## Using it

- **Add job** — company is the only required field. Paste the full JD.
- Drag cards between stages, or change the stage in the detail panel.
- **Deadlines** view sorts by what closes soonest. Cards turn amber at ten
  days out, red at three or overdue.
- **Expand** in the detail panel (or press `E`) opens the JD full width.
- Press `N` anywhere to add a job.

## Getting the JDs to an AI

Two routes, neither needing an API key:

- **Copy for AI** — builds a prompt containing every open role with its full
  job description, your recorded gaps and keywords, and an instruction not to
  invent anything. Paste it into Claude or ChatGPT along with your CV.
- **Export CSV** — every application with its full JD, opens in Excel or
  Google Sheets.

One-click tailoring against an AI API is not built yet. When it is, it will
work the same way: the user supplies their own key, kept in their own
browser, with requests going straight from their browser to the provider — so
nobody else's usage lands on your bill.
