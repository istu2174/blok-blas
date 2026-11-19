-- Blok Blas: skema Supabase. Jalankan sekali di Supabase → SQL Editor → New query → Run.

-- Profil pemain: satu baris per akun auth.
create table if not exists public.profiles (
  id          uuid primary key references auth.users on delete cascade,
  username    text unique not null check (username ~ '^[a-z0-9_]{3,20}$'),
  is_admin    boolean not null default false,
  best_score  integer not null default 0,
  created_at  timestamptz not null default now()
);

alter table public.profiles enable row level security;

-- Semua orang boleh baca (buat cek nama terpakai & papan skor nanti).
drop policy if exists "profil bisa dibaca" on public.profiles;
create policy "profil bisa dibaca" on public.profiles for select using (true);
-- Sengaja TIDAK ada policy insert/update/delete: klien nggak bisa ubah is_admin.
-- Baris dibuat oleh trigger, skor diubah lewat fungsi submit_score.

-- Bikin profil otomatis saat daftar (username dari metadata signUp).
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, username)
  values (new.id, lower(new.raw_user_meta_data->>'username'));
  return new;
end $$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- Simpan skor: cuma boleh naik, cuma untuk akun sendiri.
create or replace function public.submit_score(skor integer) returns integer
language sql security definer set search_path = public as $$
  update public.profiles set best_score = greatest(best_score, skor)
  where id = auth.uid()
  returning best_score;
$$;

revoke execute on function public.submit_score(integer) from public, anon;
grant execute on function public.submit_score(integer) to authenticated;

-- Setelah daftar akun admin lewat game, jadikan admin dengan:
--   update public.profiles set is_admin = true where username = 'admin';
