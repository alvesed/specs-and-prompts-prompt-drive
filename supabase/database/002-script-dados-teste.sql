-- =====================================================================================
-- AMOSTRA COMPLETA (Supabase/Postgres) - usando usuário já existente em auth.users
-- user_id: 43a2c103-b1c9-41a1-a693-622044f33163
-- Usuário (referência): Johny Blaze | email: jb@dio.me
--
-- Cria/atualiza:
-- - public.profiles (plan + stripe_customer_id)
-- - 3 public.folders
-- - 3 public.prompts
-- - 1 public.subscriptions
--
-- Observações:
-- - Se o trigger handle_new_user já criou profiles, este script faz UPSERT.
-- - RLS pode bloquear se você rodar sem Service Role / sem estar autenticado como esse user.
-- - Unicidade case-insensitive: nomes de pasta e prompt devem ser únicos dentro do escopo.
-- =====================================================================================

begin;

do $$
declare
  v_user_id uuid := '43a2c103-b1c9-41a1-a693-622044f33163'::uuid;

  v_folder_1 uuid := gen_random_uuid();
  v_folder_2 uuid := gen_random_uuid();
  v_folder_3 uuid := gen_random_uuid();

  v_prompt_1 uuid := gen_random_uuid();
  v_prompt_2 uuid := gen_random_uuid();
  v_prompt_3 uuid := gen_random_uuid();

  v_stripe_customer_id text := 'cus_demo_43a2c103_johny_blaze_001';
  v_stripe_subscription_id text := 'sub_demo_43a2c103_johny_blaze_001';
begin
  -- =========================================================
  -- 1) profiles (UPSERT)
  -- =========================================================
  insert into public.profiles (
    user_id,
    plan,
    stripe_customer_id
  ) values (
    v_user_id,
    'premium',
    v_stripe_customer_id
  )
  on conflict (user_id) do update
    set plan = excluded.plan,
        stripe_customer_id = excluded.stripe_customer_id;

  -- =========================================================
  -- 2) folders (3 pastas)
  -- =========================================================
  insert into public.folders (id, user_id, name)
  values
    (v_folder_1, v_user_id, 'Marketing'),
    (v_folder_2, v_user_id, 'Desenvolvimento'),
    (v_folder_3, v_user_id, 'Suporte');

  -- =========================================================
  -- 3) prompts (3 prompts)
  -- - enforce_prompt_folder_ownership: ok (mesmo user_id)
  -- - enforce_free_prompt_limit: não bloqueia (plan premium)
  -- =========================================================
  insert into public.prompts (id, user_id, folder_id, name, content)
  values
    (
      v_prompt_1,
      v_user_id,
      v_folder_1,
      'Post para Redes Sociais',
      'Crie um post engajador para [plataforma] sobre [tema]. Inclua uma CTA clara e use linguagem [tom].'
    ),
    (
      v_prompt_2,
      v_user_id,
      v_folder_2,
      'Revisão de Código',
      'Revise o seguinte código [código] e forneça feedback sobre performance, segurança e legibilidade.'
    ),
    (
      v_prompt_3,
      v_user_id,
      v_folder_3,
      'Resposta de Suporte',
      'Crie uma resposta empática para: [descrição do problema]. Explique a solução e próximos passos.'
    );

  -- =========================================================
  -- 4) subscriptions (Stripe mirror)
  -- =========================================================
  insert into public.subscriptions (
    user_id,
    stripe_subscription_id,
    stripe_customer_id,
    status,
    price_id,
    product_id,
    currency,
    interval,
    interval_count,
    current_period_start,
    current_period_end,
    cancel_at_period_end
  ) values (
    v_user_id,
    v_stripe_subscription_id,
    v_stripe_customer_id,
    'active',
    'price_demo_monthly_001',
    'prod_demo_premium_001',
    'usd',
    'month',
    1,
    now(),
    now() + interval '30 days',
    false
  );

  -- =========================================================
  -- 5) OUTPUT (IDs gerados)
  -- =========================================================
  raise notice 'USER_ID: %', v_user_id;
  raise notice 'FOLDER_1: %', v_folder_1;
  raise notice 'FOLDER_2: %', v_folder_2;
  raise notice 'FOLDER_3: %', v_folder_3;
  raise notice 'PROMPT_1: %', v_prompt_1;
  raise notice 'PROMPT_2: %', v_prompt_2;
  raise notice 'PROMPT_3: %', v_prompt_3;
  raise notice 'STRIPE_CUSTOMER_ID: %', v_stripe_customer_id;
  raise notice 'STRIPE_SUBSCRIPTION_ID: %', v_stripe_subscription_id;
end $$;

commit;