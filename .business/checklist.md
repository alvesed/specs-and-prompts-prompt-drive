# TO-DO LIST
- [X] Definir a visão da nossa aplicação
- [X] Arquitetura de solução da aplicação (high level design)

# COPILOTOS
- [X] Copiloto de Product Owner
- [X] Criou primeira spec

# SEED SPEC
- [x] Executou no copiloto de programação
- [x] Check de Fake Functional
- [x] Check de Qualidade de Código
- [ ] Check de Segurança de Aplicação [001-spec-fix]
- [ ] Não ativar a chave duas vezes [002-spec-fix]

# Perssistência de dados
- [X] Salvar Pastas e Prompts em algum lugar
- [X] Controle de usuários
- [X] Garantiu Campos referente aos campos do Stripe

# Construir e Documentar o Back End
- [X] Ter um registro inicial de amostragem
- [X] Construir e Documentar o back End
    - [X] Testar Auth
        - [X] criar usuário
        - [X] logar usuário
    - [X] Testar e Listar endpoints de `Folders`
        - [X] Criar uma pasta
        - [X] Editar uma pasta
        - [X] Deletar uma pasta
        - [X] Listar pastas
    - [X] Testar e Listar endpoints de `Prompts`
        - [X] Criar prompt
        - [X] Editar prompt
        - [X] Deletar prompt
        - [X] Listar prompts

# Como Conectar seu front-end com seu back-end
## Setup 
    - [X] constante: SUPABASE_URL
    - [X] constante: SUPABASE_ANON_KEY
    - [ ] armazenar o `USER_ACCESS_TOKEN`
    - [ ] Query De listagem Geral (dados do usuário, relação pastas e prompts para serem renderizados)
## Features

### Feature De Login
    - [X] Sistema de Login
      - [X] Query De listagem Geral (dados do usuário, relação pastas e prompts para serem renderizados)
        - [X] Tela de Login 
        - [X] Regra quando não tiver logado
        - [X] Hooks: O que disparar ao logar
        - [X] Cadastrar Novo usuário
      
### Feature de persistência
    - [X] Persistência de dados
        - [X] Pastas
        - [X] Prompts





# Comandos importantes
## Iniciar o projeto backend no Cursor

Hit (alt+L, alt+O) to Open the Server and (alt+L, alt+C) to Stop the server (You can change the shortcut form keybinding). [On MAC, cmd+L, cmd+O and cmd+L, cmd+C]

Open the Command Pallete by pressing F1 or ctrl+shift+P and type Live Server: Open With Live Server to start a server or type Live Server: Stop Live Server to stop a server.        

http://127.0.0.1:5500/index.html

## Banco de dados:

https://supabase.com/dashboard/project/qeqjpesoyopjytbavemk/database/tables

## Testes api banco de dados:

Collection postman