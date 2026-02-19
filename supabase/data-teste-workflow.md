## 👨 User teste:
user jb@dio.me
UUID: 43a2c103-b1c9-41a1-a693-622044f33163

user alvesed@gmail.com
UUID: 28b90e45-a1db-40d2-b3f1-ae09727bc2c3

## 📲 Enpoints:

### 👨 [Users]

#### ➕ Create User (Supabase Auth — Signup)

```js
POST: `https://qeqjpesoyopjytbavemk.supabase.co/auth/v1/signup`
```

[PARAMS]
Sem parâmetros

[HEADER]

apikey: {{SUPABASE_ANON_KEY}}
Content-Type: application/json


⚠️ Para signup, não é necessário Authorization Bearer.
Apenas a anon public key (publishable) é suficiente.

[BODY]

{
  "email": "SatoruGojo@dio.me",
  "password": "123456",
  "data": {
    "full_name": "Satoru"
  }
}


📦 [Expect]
 - `200 OK`

Resposta típica:

{
  "user": {
    "id": "uuid-gerado",
    "email": "SatoruGojo@dio.me"
  },
  "session": {
    "access_token": {{ACCESS_TOKEN}}
  }
}


Se seu trigger handle_new_user() estiver ativo:

create trigger trg_on_auth_user_created
after insert on auth.users


➡️ Um registro será automaticamente criado em public.profiles com:

plan = 'free'


🚨 [Throws]

❌ 400 Bad Request
Email inválido ou senha muito curta.

❌ 422 Unprocessable Entity
Email já cadastrado.

❌ 429 Too Many Requests
Rate limit do Supabase.

❌ 500
Problema interno no projeto Supabase.

🔐 Observação Arquitetural Importante

No seu modelo de banco:

profiles é criado automaticamente via trigger.

folders e prompts dependem de auth.uid() via JWT.

Após signup, você deve:

Fazer login (/token?grant_type=password)

Usar o access_token para chamadas PostgREST




#### 🔑 Login User

🔐 Login (Supabase Auth — Password Grant)
POST: `https://qeqjpesoyopjytbavemk.supabase.co/auth/v1/token?grant_type=password`


[PARAMS]

grant_type=password (obrigatório na query string)

[HEADER]

apikey: {{SUPABASE_ANON_KEY}}
Content-Type: application/json


[BODY]

{
  "email": "alvesed@gmail.com",
  "password": {{SENHA_USUARIO}}
}


📦 [Expect]
 - `200 OK`

Resposta típica:

{
  "access_token": {{ACCESS_TOKEN}},
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "....",
  "user": {
    "id": "uuid-do-usuario",
    "email": "alvesed@gmail.com"
  }
}


✅ Use o access_token retornado no header das chamadas PostgREST:

Authorization: Bearer {{USER_ACCESS_TOKEN}}

🚨 [Throws]

❌ 400 Bad Request
Payload inválido (faltando email ou password) ou formato incorreto.

❌ 401 Unauthorized
Email/senha incorretos ou usuário não permitido autenticar (ex.: bloqueado).

❌ 422 Unprocessable Entity
Email inválido.

❌ 429 Too Many Requests
Rate limit / muitas tentativas de login.


### 📁 [Folders]
#### ➕ Criar pasta:

```js
POST: `https://{{PROJECT_ID}}.supabase.co/rest/v1/folders`
```

[PARAMS] Sem parâmetros

[HEADER]

apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Content-Type: application/json'
Prefer: return=representation'

[BODY]

```js
{
  "user_id": "28b90e45-a1db-40d2-b3f1-ae09727bc2c3",
  "name": "Desenvolvimento"
}
```

📦 [Expect]
 - `201 Created`

🚨 [Throws]
 - `401 Unauthorized`

Você não enviou o Authorization Bearer.

 - `403 Row Level Security`

O user_id do body é diferente do usuário do token.

 - `409 Conflict`

Já existe pasta com mesmo nome (case-insensitive) por causa do índice:

unique (user_id, lower(name))


#### 📝 Atualizar pasta:

```js:
PATCH: `https://{{PROJECT_ID}}.supabase.co/rest/v1/folders?id=eq.{{FOLDER_ID}}`
```

[PARAMS] id:eq.{{FOLDER_ID}}

[HEADER]

apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Content-Type: application/json'
Prefer: return=representation'

[BODY]

```js
{
  "name": "Desenvolvimento 2"
}
```


📦 [Expect]
 - `200 Ok`

🚨 [Throws]
 - `401 Unauthorized`

Você não enviou o Authorization Bearer.

 - `403 Row Level Security`

O user_id do body é diferente do usuário do token.

 - `409 Conflict`

Já existe pasta com mesmo nome (case-insensitive) por causa do índice:

unique (user_id, lower(name))

 - `0 linhas afetadas`

O id está errado ou não pertence ao usuário do token.


#### 🔴 Deletar pasta:

```js:
DELETE: `https://{{PROJECT_ID}}.supabase.co/rest/v1/folders?id=eq.{{FOLDER_ID}}`
```

[PARAMS] id:eq.{{FOLDER_ID}}

[HEADER]

apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Content-Type: application/json'
Prefer: return=representation'

[BODY]

Sem body.

📦 [Expect]
 - `200 Ok`

🚨 [Throws]
 - `401 Unauthorized`

Você não enviou o Authorization Bearer.

 - `403 Row Level Security`

O user_id do body é diferente do usuário do token.

 - `404 Not found`

UUID inexistente.


#### 📰 Listar pastas:

```js:
GET: `https://{{PROJECT_ID}}.supabase.co/rest/v1/folders?select=*&order=created_at.asc`
```
Ou especificando os campos:
```js:
GET: `https://{{PROJECT_ID}}.supabase.co/rest/v1/folders?select=id,user_id,name,created_at,updated_at&order=created_at.asc`
```

[PARAMS] 
select:{{COLUNAS OU * PARA TODAS}}
order:{{COLUNA DE ORDENAÇÃO}} (opcional)

[HEADER]

apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Content-Type: application/json'
Prefer: return=representation'

[BODY]

Sem body.


📦 [Expect]

- `200 Ok`


🔥 Forma mais segura (recomendada)

Não filtre por user_id na URL.

 - Evite:

?user_id=eq.43a2c103...


Porque:

Você já tem RLS

Evita dependência de parâmetro manipulável

🚨 [Throws]

 - 401 Unauthorized

Sem Authorization header.

 - 403

Token inválido.

 - Retorno vazio

Usuário não possui pastas.


Você pode:

🔹 Selecionar apenas campos necessários
GET /rest/v1/folders?select=id,name,created_at

🔹 Paginação
GET /rest/v1/folders?select=*&limit=10&offset=0

🔹 Contagem total

Adicionar header:

Prefer: count=exact


E olhar o header:

Content-Range: 0-2/3



---

### 📄 [Prompts]

#### 📌 Observações
public.prompts — Operações via PostgREST (Supabase)

Baseado no seu schema:

user_id obrigatório

folder_id deve pertencer ao mesmo usuário (trigger enforce_prompt_folder_ownership)

Limite Free (5 prompts) via trigger enforce_free_prompt_limit()

Unicidade case-insensitive por pasta:
unique (user_id, folder_id, lower(name))

RLS ativo: auth.uid() = user_id

#### ➕ Criar Prompt
POST: `https://{{PROJECT_ID}}.supabase.co/rest/v1/prompts`

[PARAMS]

Sem parâmetros

[HEADER]
apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Content-Type: application/json
Prefer: return=representation

[BODY]
{
  "user_id": "43a2c103-b1c9-41a1-a693-622044f33163",
  "folder_id": "{{FOLDER_ID}}",
  "name": "Revisão de Código",
  "content": "Revise o código [código] e forneça feedback sobre performance e segurança."
}

📦 [Expect]

 - 201 Created

[
  {
    "id": "uuid-gerado",
    "user_id": "...",
    "folder_id": "...",
    "name": "Revisão de Código",
    "content": "...",
    "created_at": "...",
    "updated_at": "..."
  }
]

🚨 [Throws]

 - 401 Unauthorized
Token não enviado.

 - 403 Row Level Security
user_id diferente do usuário do token.

 - 409 Conflict
Já existe prompt com mesmo nome (case-insensitive) na mesma pasta.

 - 500
"Folder does not belong to user" (trigger de ownership).

 - 500
"Free plan limit reached (5 prompts)".

#### 📝 Atualizar Prompt
PATCH: `https://{{PROJECT_ID}}.supabase.co/rest/v1/prompts?id=eq.{{PROMPT_ID}}`

[PARAMS]

id=eq.{{PROMPT_ID}}

[HEADER]
apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Content-Type: application/json
Prefer: return=representation

[BODY] (exemplo)
{
  "name": "Revisão de Código (v2)",
  "content": "Atualize a análise considerando performance, segurança e padrões."
}

📦 [Expect]

 - 200 OK

[
  {
    "id": "...",
    "name": "Revisão de Código (v2)",
    "content": "...",
    "updated_at": "..."
  }
]

🚨 [Throws]

 - 403 Row Level Security
Prompt não pertence ao usuário.

 - 409 Conflict
Nome duplicado na mesma pasta.

 - 500
Folder inválida (caso altere folder_id para pasta de outro usuário).

#### 🔴 Deletar Prompt
DELETE: `https://{{PROJECT_ID}}.supabase.co/rest/v1/prompts?id=eq.{{PROMPT_ID}}`

[PARAMS]

id=eq.{{PROMPT_ID}}

[HEADER]
apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}
Prefer: return=representation

[BODY]

Sem body

📦 [Expect]

 - 200 OK

ou

204 No Content

🚨 [Throws]

 - 403 Row Level Security
Prompt não pertence ao usuário.

 - 404
ID inexistente (ou invisível por RLS).

#### 📰 Listar Prompts
GET: `https://{{PROJECT_ID}}.supabase.co/rest/v1/prompts?select=*`

[PARAMS] (opcionais)

Filtrar por pasta:

folder_id=eq.{{FOLDER_ID}}


Ordenar:

order=name.asc


Paginar:

limit=20&offset=0


Exemplo completo:

GET: `https://{{PROJECT_ID}}.supabase.co/rest/v1/prompts?select=*&folder_id=eq.{{FOLDER_ID}}&order=name.asc`

[HEADER]
apikey: {{SUPABASE_ANON_KEY}}
Authorization: Bearer {{USER_ACCESS_TOKEN}}

📦 [Expect]

 - 200 OK

[
  {
    "id": "...",
    "folder_id": "...",
    "name": "...",
    "content": "...",
    "created_at": "...",
    "updated_at": "..."
  }
]

🚨 [Throws]

 - 401 Unauthorized
Token não enviado.

 - 403
Token inválido ou expirado.

🔒 Observação Importante

Você não precisa filtrar por user_id na query.

O RLS já garante:

auth.uid() = user_id


Ou seja, o Supabase retorna automaticamente apenas os prompts do usuário autenticado.