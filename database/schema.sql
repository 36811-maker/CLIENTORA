-- CLIENTORA: esquema inicial multiempresa para Supabase/PostgreSQL.
-- Execute no SQL Editor. Revise as políticas e adapte a regras da sua organização antes de produção.
create extension if not exists pgcrypto;

create table if not exists public.companies (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 created_at timestamptz not null default now()
);
create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 company_id uuid references public.companies(id) on delete cascade,
 full_name text not null default '',
 role text not null default 'vendedor' check(role in ('administrador','gerente_comercial','vendedor','visualizador')),
 created_at timestamptz not null default now()
);
create table if not exists public.clients (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 name text not null, company text, email text, phone text, category text, owner_id uuid references public.profiles(id),
 city text, notes text, archived boolean not null default false, created_at timestamptz not null default now()
);
create table if not exists public.leads (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 name text not null, company text, email text, source text, status text default 'Novo', priority text default 'Média',
 owner_id uuid references public.profiles(id), converted_client_id uuid references public.clients(id), created_at timestamptz not null default now()
);
create table if not exists public.pipelines (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 name text not null, created_at timestamptz not null default now()
);
create table if not exists public.pipeline_stages (
 id uuid primary key default gen_random_uuid(), pipeline_id uuid not null references public.pipelines(id) on delete cascade,
 name text not null, position integer not null default 0
);
create table if not exists public.opportunities (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 pipeline_id uuid references public.pipelines(id), stage_id uuid references public.pipeline_stages(id),
 name text not null, client_id uuid references public.clients(id), value numeric(14,2) default 0,
 probability integer default 0 check(probability between 0 and 100), owner_id uuid references public.profiles(id),
 due_date date, priority text, status text default 'Aberta', created_at timestamptz not null default now()
);
create table if not exists public.activities (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 client_id uuid references public.clients(id), opportunity_id uuid references public.opportunities(id),
 type text not null, description text, owner_id uuid references public.profiles(id), occurred_at timestamptz default now()
);
create table if not exists public.appointments (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 title text not null, client_id uuid references public.clients(id), owner_id uuid references public.profiles(id),
 starts_at timestamptz not null, status text default 'Agendado'
);
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 title text not null, description text, status text default 'A fazer', priority text default 'Média',
 owner_id uuid references public.profiles(id), due_date date, created_at timestamptz default now()
);
create table if not exists public.teams (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 name text not null, manager_id uuid references public.profiles(id)
);
create table if not exists public.team_members (
 team_id uuid references public.teams(id) on delete cascade, profile_id uuid references public.profiles(id) on delete cascade,
 primary key(team_id,profile_id)
);
create table if not exists public.goals (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 name text not null, target numeric(14,2) default 0, current numeric(14,2) default 0, period text, owner_id uuid references public.profiles(id)
);
create table if not exists public.campaigns (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 name text not null, channel text, status text, starts_on date, ends_on date, created_at timestamptz default now()
);
create table if not exists public.notifications (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 profile_id uuid references public.profiles(id) on delete cascade, title text not null, description text, read_at timestamptz, created_at timestamptz default now()
);
create table if not exists public.activity_logs (
 id uuid primary key default gen_random_uuid(), company_id uuid not null references public.companies(id) on delete cascade,
 actor_id uuid references public.profiles(id), action text not null, entity text not null, record_id uuid,
 old_data jsonb, new_data jsonb, created_at timestamptz default now()
);

create or replace function public.current_company_id()
returns uuid language sql stable security definer set search_path=public
as $$ select company_id from public.profiles where id=auth.uid() $$;

alter table public.companies enable row level security;
alter table public.profiles enable row level security;
alter table public.clients enable row level security;
alter table public.leads enable row level security;
alter table public.pipelines enable row level security;
alter table public.pipeline_stages enable row level security;
alter table public.opportunities enable row level security;
alter table public.activities enable row level security;
alter table public.appointments enable row level security;
alter table public.tasks enable row level security;
alter table public.teams enable row level security;
alter table public.team_members enable row level security;
alter table public.goals enable row level security;
alter table public.campaigns enable row level security;
alter table public.notifications enable row level security;
alter table public.activity_logs enable row level security;

-- Políticas iniciais: isolamento por empresa. Regras finas por função/equipe devem ser ampliadas.
do $$ declare t text; begin
 foreach t in array array['clients','leads','pipelines','opportunities','activities','appointments','tasks','teams','goals','campaigns','notifications','activity_logs'] loop
  execute format('drop policy if exists company_isolation on public.%I',t);
  execute format('create policy company_isolation on public.%I for all using (company_id = public.current_company_id()) with check (company_id = public.current_company_id())',t);
 end loop;
end $$;
drop policy if exists profile_read_company on public.profiles;
create policy profile_read_company on public.profiles for select using (company_id = public.current_company_id() or id = auth.uid());
drop policy if exists profile_update_self on public.profiles;
create policy profile_update_self on public.profiles for update using (id=auth.uid()) with check (id=auth.uid());
drop policy if exists company_read on public.companies;
create policy company_read on public.companies for select using (id=public.current_company_id());
drop policy if exists stages_by_pipeline on public.pipeline_stages;
create policy stages_by_pipeline on public.pipeline_stages for all using (exists(select 1 from public.pipelines p where p.id=pipeline_id and p.company_id=public.current_company_id())) with check (exists(select 1 from public.pipelines p where p.id=pipeline_id and p.company_id=public.current_company_id()));

-- Criação de perfil automática: company_id precisa ser atribuído por fluxo administrativo seguro.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path=public
as $$ begin insert into public.profiles(id,full_name,role) values(new.id,coalesce(new.raw_user_meta_data->>'full_name',''),'vendedor'); return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();
