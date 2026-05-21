-- Funcion segura para que la app lea el perfil del usuario logueado.
-- Ejecutar en Supabase SQL Editor.

create or replace function public.get_my_profile()
returns table (
  id uuid,
  full_name text,
  email text,
  phone text,
  birth_date date,
  level text,
  role text,
  status text
)
language sql
security definer
set search_path = public
stable
as $$
  select
    p.id,
    p.full_name,
    p.email,
    p.phone,
    p.birth_date,
    p.level,
    p.role,
    p.status
  from public.profiles p
  where p.id = auth.uid()
  limit 1;
$$;

grant execute on function public.get_my_profile() to authenticated;

select public.get_my_profile();
