

----------------Profile--Query--------------------


-- Create a table for public profiles
create table profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  name text,

  constraint name_length check (char_length(name) >= 3)
);
-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/database/postgres/row-level-security for more details.
alter table profiles
  enable row level security;

create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

create policy "Users can insert their own profile." on profiles
  for insert with check ((select auth.uid()) = id);

create policy "Users can update own profile." on profiles
  for update using ((select auth.uid()) = id);

-- This trigger automatically creates a profile entry when a new user signs up via Supabase Auth.
-- See https://supabase.com/docs/guides/auth/managing-user-data#using-triggers for more details.
create function public.handle_new_user()
returns trigger
set search_path = ''
as $$
begin
  insert into public.profiles (id, name)
  values (new.id, new.raw_user_meta_data->>'name');
  return new;
end;
$$ language plpgsql security definer;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();











----------------Blogs--Query--------------------



create table blogs (
  id uuid not null primary key,
  updated_at timestamp with time zone,
  title text not null,
  content text not null,
  poster_id uuid not null,
  image_url text,
  topics text array,
  foreign key (poster_id) references public.profiles(id)
);

-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/database/postgres/row-level-security for more details.
alter table profiles
  enable row level security;

create policy "Public blogs are viewable by everyone." on blogs
  for select using (true);

create policy "Users can insert their own blogs." on blogs
  for insert with check ((select auth.uid()) = poster_id);

create policy "Users can update own blog." on blogs
  for update using ((select auth.uid()) = poster_id);




-- Set up Storage!
insert into storage.buckets (id, name)
  values ('blog_images', 'blog_images');

-- Set up access controls for storage.
-- See https://supabase.com/docs/guides/storage/security/access-control#policy-examples for more details.
create policy "Blog images are publicly accessible." on storage.objects
  for select using (bucket_id = 'blog_images');

create policy "Anyone can upload a blog image." on storage.objects
  for insert with check (bucket_id = 'blog_images');

create policy "Users can update their own blog image." on storage.objects
  for update using ((select auth.uid()) = owner) with check (bucket_id = 'blog_images');






--------------------------------------------

In your code, the Bloc (AuthBloc) is responsible for handling the login process and user authentication logic.
After a successful login, the Bloc updates the Cubit (AppUserCubit) with the user data.
The Cubit (AppUserCubit) then stores and manages the user state (such as logged-in user info) for the rest of the app.

Summary:

Bloc (AuthBloc): Handles login/auth events and logic.
Cubit (AppUserCubit): Stores user data and exposes it to the UI after login.




------------------



create table profiles (
  id uuid references auth.users not null primary key,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone,
  first_name text not null,
  last_name text not null,
  role text check (role in ('publisher', 'advertiser')) not null,
  phone text
);


-- Set up Row Level Security (RLS)
-- See https://supabase.com/docs/guides/database/postgres/row-level-security for more details.
alter table profiles
  enable row level security;

create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

create policy "Users can insert their own profile." on profiles
  for insert with check ((select auth.uid()) = id);

create policy "Users can update own profile." on profiles
  for update using ((select auth.uid()) = id);




-- This trigger automatically creates a profile entry when a new user signs up via Supabase Auth.
-- See https://supabase.com/docs/guides/auth/managing-user-data#using-triggers for more details.
create or replace function public.handle_new_user()
returns trigger
set search_path = ''
language plpgsql
security definer
as $$
declare
  raw_role text;
begin
  -- Extract role from signup metadata
  raw_role := new.raw_user_meta_data->>'role';

  insert into public.profiles (id, first_name, last_name, role, phone)
  values (
    new.id,
    new.raw_user_meta_data->>'first_name',
    new.raw_user_meta_data->>'last_name',
    case
      when raw_role in ('publisher', 'advertiser') then raw_role
      else 'publisher'  -- fallback if missing/invalid
    end,
    new.phone
  );

  return new;
end;
$$;

create or replace trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
