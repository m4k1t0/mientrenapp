-- Ejecutar TODO en Supabase > SQL Editor
create table if not exists public.training_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"profile":{},"equipment":[],"loads":{},"logs":{},"routines":[],"sessions":[],"gifs":{}}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.training_data enable row level security;
drop policy if exists "training_select_own" on public.training_data;
create policy "training_select_own" on public.training_data for select to authenticated using (auth.uid()=user_id);
drop policy if exists "training_insert_own" on public.training_data;
create policy "training_insert_own" on public.training_data for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "training_update_own" on public.training_data;
create policy "training_update_own" on public.training_data for update to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);

-- Bucket público para servir GIFs cargados desde cualquier dispositivo.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('exercise-gifs','exercise-gifs',true,8388608,array['image/gif'])
on conflict (id) do update set public=true,file_size_limit=8388608,allowed_mime_types=array['image/gif'];

drop policy if exists "gif_read_public" on storage.objects;
create policy "gif_read_public" on storage.objects for select using (bucket_id='exercise-gifs');
drop policy if exists "gif_upload_own_folder" on storage.objects;
create policy "gif_upload_own_folder" on storage.objects for insert to authenticated with check (bucket_id='exercise-gifs' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "gif_update_own_folder" on storage.objects;
create policy "gif_update_own_folder" on storage.objects for update to authenticated using (bucket_id='exercise-gifs' and (storage.foldername(name))[1]=auth.uid()::text) with check (bucket_id='exercise-gifs' and (storage.foldername(name))[1]=auth.uid()::text);
