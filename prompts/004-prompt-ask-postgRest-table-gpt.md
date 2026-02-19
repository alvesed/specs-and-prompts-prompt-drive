Com base no seu conhecimento do meu banco postgre no supabase, gere pra mim o detalhamento das chamadas da tabela prompt (`public.prompts`) no padrão `PostgREST`

Crie as 4 operações abaixo:
#### Criar prompt
#### Atualizar prompt
#### Deletar prompt
#### Listar prompt

Quero no mesmo formato do padrão abaixo, e deixe no formato markdown a resposta

EXEMPLO
```
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
`201 Created`

🚨 [Throws]
❌ `401 Unauthorized`

Você não enviou o Authorization Bearer.

❌ `403 Row Level Security`

O user_id do body é diferente do usuário do token.

❌ `409 Conflict`

Já existe pasta com mesmo nome (case-insensitive) por causa do índice:

unique (user_id, lower(name))
```