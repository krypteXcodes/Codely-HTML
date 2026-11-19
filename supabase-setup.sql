create table if not exists public.learner_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  profile jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.learner_profiles enable row level security;

drop policy if exists "Learners can read their own profile" on public.learner_profiles;
create policy "Learners can read their own profile"
  on public.learner_profiles for select to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Learners can create their own profile" on public.learner_profiles;
create policy "Learners can create their own profile"
  on public.learner_profiles for insert to authenticated
  with check ((select auth.uid()) = user_id);

drop policy if exists "Learners can update their own profile" on public.learner_profiles;
create policy "Learners can update their own profile"
  on public.learner_profiles for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

grant select, insert, update on public.learner_profiles to authenticated;
