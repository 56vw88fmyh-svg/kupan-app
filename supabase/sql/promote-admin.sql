-- Convertir vaas.arismendi@gmail.com en admin KUPAN.
-- Ejecutar completo en Supabase SQL Editor.
-- Si el profile no existe, lo crea usando el usuario real de auth.users.

insert into public.profiles (
  id,
  full_name,
  email,
  phone,
  birth_date,
  level,
  role,
  status,
  created_at,
  updated_at
)
select
  u.id,
  coalesce(u.raw_user_meta_data->>'full_name', u.raw_user_meta_data->>'name', 'Admin KUPAN'),
  u.email,
  nullif(u.raw_user_meta_data->>'phone', ''),
  coalesce(nullif(u.raw_user_meta_data->>'birth_date', '')::date, current_date),
  case
    when u.raw_user_meta_data->>'level' in ('Iniciado', 'Rookie', 'Scaled', 'RX')
      then u.raw_user_meta_data->>'level'
    else 'RX'
  end,
  'admin',
  'active',
  now(),
  now()
from auth.users u
where lower(u.email) = 'vaas.arismendi@gmail.com'
on conflict (id) do update
set
  full_name = coalesce(excluded.full_name, public.profiles.full_name),
  email = excluded.email,
  phone = coalesce(excluded.phone, public.profiles.phone),
  birth_date = coalesce(public.profiles.birth_date, excluded.birth_date),
  level = coalesce(public.profiles.level, excluded.level),
  role = 'admin',
  status = 'active',
  updated_at = now();

-- Verificacion 1: debe devolver una fila y role = admin.
select
  p.id,
  p.full_name,
  p.email,
  p.role,
  p.status,
  p.birth_date,
  p.level
from public.profiles p
where lower(p.email) = 'vaas.arismendi@gmail.com';

-- Verificacion 2: debe devolver true si lo ejecutas en una sesion auth compatible.
select exists (
  select 1
  from public.profiles
  where lower(email) = 'vaas.arismendi@gmail.com'
    and role = 'admin'
    and status = 'active'
) as admin_configurado;
