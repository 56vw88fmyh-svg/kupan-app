-- Reparacion RLS para panel admin KUPAN.
-- Ejecutar en Supabase SQL Editor si el admin inicia sesion, pero el panel no carga datos.

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'admin'
      and status = 'active'
  );
$$;

grant execute on function public.is_admin() to authenticated;

alter table public.profiles enable row level security;
alter table public.plans enable row level security;
alter table public.memberships enable row level security;
alter table public.class_schedule enable row level security;
alter table public.reservations enable row level security;
alter table public.personal_records enable row level security;
alter table public.wod enable row level security;
alter table public.community_posts enable row level security;
alter table public.app_settings enable row level security;

drop policy if exists "Profiles read own or admin" on public.profiles;
create policy "Profiles read own or admin"
on public.profiles
for select
to authenticated
using (id = auth.uid() or public.is_admin());

drop policy if exists "Admins manage profiles" on public.profiles;
create policy "Admins manage profiles"
on public.profiles
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Plans read active or admin" on public.plans;
create policy "Plans read active or admin"
on public.plans
for select
to authenticated
using (active = true or public.is_admin());

drop policy if exists "Admins manage plans" on public.plans;
create policy "Admins manage plans"
on public.plans
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Memberships read own or admin" on public.memberships;
create policy "Memberships read own or admin"
on public.memberships
for select
to authenticated
using (profile_id = auth.uid() or public.is_admin());

drop policy if exists "Admins manage memberships" on public.memberships;
create policy "Admins manage memberships"
on public.memberships
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Schedule read active or admin" on public.class_schedule;
create policy "Schedule read active or admin"
on public.class_schedule
for select
to authenticated
using (active = true or public.is_admin());

drop policy if exists "Admins manage schedule" on public.class_schedule;
create policy "Admins manage schedule"
on public.class_schedule
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Reservations read own or admin" on public.reservations;
create policy "Reservations read own or admin"
on public.reservations
for select
to authenticated
using (profile_id = auth.uid() or public.is_admin());

drop policy if exists "Admins manage reservations" on public.reservations;
create policy "Admins manage reservations"
on public.reservations
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "PR read own or admin" on public.personal_records;
create policy "PR read own or admin"
on public.personal_records
for select
to authenticated
using (profile_id = auth.uid() or public.is_admin());

drop policy if exists "PR manage own or admin" on public.personal_records;
create policy "PR manage own or admin"
on public.personal_records
for all
to authenticated
using (profile_id = auth.uid() or public.is_admin())
with check (profile_id = auth.uid() or public.is_admin());

drop policy if exists "WOD read all" on public.wod;
create policy "WOD read all"
on public.wod
for select
to authenticated
using (true);

drop policy if exists "Admins manage wod" on public.wod;
create policy "Admins manage wod"
on public.wod
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Community read active or admin" on public.community_posts;
create policy "Community read active or admin"
on public.community_posts
for select
to authenticated
using (active = true or public.is_admin());

drop policy if exists "Admins manage community" on public.community_posts;
create policy "Admins manage community"
on public.community_posts
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "Settings read all" on public.app_settings;
create policy "Settings read all"
on public.app_settings
for select
to authenticated
using (true);

drop policy if exists "Admins manage settings" on public.app_settings;
create policy "Admins manage settings"
on public.app_settings
for all
to authenticated
using (public.is_admin())
with check (public.is_admin());

-- Verificacion rapida: debe devolver true con tu usuario admin logueado.
select public.is_admin() as usuario_actual_es_admin;
