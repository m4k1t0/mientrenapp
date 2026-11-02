-- Ejecuta este script en Supabase > SQL Editor.
create table if not exists public.training_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"profile":{},"equipment":[],"loads":{},"logs":[],"sessions":[]}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.training_data enable row level security;
drop policy if exists "Users can read own training data" on public.training_data;
create policy "Users can read own training data"
on public.training_data for select to authenticated
using (auth.uid() = user_id);
drop policy if exists "Users can insert own training data" on public.training_data;
create policy "Users can insert own training data"
on public.training_data for insert to authenticated
with check (auth.uid() = user_id);
drop policy if exists "Users can update own training data" on public.training_data;
create policy "Users can update own training data"
on public.training_data for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
