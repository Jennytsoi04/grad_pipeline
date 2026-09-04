-- ============================================================
-- Grad Pipeline — database schema
-- Run this once in Supabase: SQL Editor → New query → paste → Run
-- ============================================================

create table if not exists public.jobs (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,

  company      text not null,
  role         text,
  location     text,
  source       text,
  link         text,

  status       text not null default 'interested'
               check (status in ('interested','applied','assessment','interview','offer','closed')),
  deadline     date,
  applied_on   date,
  fit          smallint default 0 check (fit between 0 and 5),

  jd           text,
  notes        text,
  requirements jsonb not null default '[]'::jsonb,
  keywords     jsonb not null default '[]'::jsonb,
  timeline     jsonb not null default '[]'::jsonb,

  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ============================================================
-- Row Level Security — this is what makes the app multi-user safe.
-- Without these policies, any signed-in user could read everyone's
-- data. With them, the database itself refuses: a user can only ever
-- touch rows where user_id matches their own auth id. Enforced in
-- Postgres, not the frontend, so a bug in the app cannot leak one
-- person's applications to another.
-- ============================================================

alter table public.jobs enable row level security;

drop policy if exists "read own jobs"   on public.jobs;
drop policy if exists "insert own jobs" on public.jobs;
drop policy if exists "update own jobs" on public.jobs;
drop policy if exists "delete own jobs" on public.jobs;

create policy "read own jobs"   on public.jobs for select using (auth.uid() = user_id);
create policy "insert own jobs" on public.jobs for insert with check (auth.uid() = user_id);
create policy "update own jobs" on public.jobs for update using (auth.uid() = user_id)
                                                   with check (auth.uid() = user_id);
create policy "delete own jobs" on public.jobs for delete using (auth.uid() = user_id);

create index if not exists jobs_user_deadline_idx on public.jobs (user_id, deadline);
create index if not exists jobs_user_status_idx   on public.jobs (user_id, status);

create or replace function public.touch_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end $$;

drop trigger if exists jobs_touch_updated_at on public.jobs;
create trigger jobs_touch_updated_at
  before update on public.jobs
  for each row execute function public.touch_updated_at();
