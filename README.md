# BankingApi

Aplicação para gerenciamento de contas bancarias.

> Elixir, Erlang, Postgres.

---


## Guia de Instalação

Para começar, clone o projeto na pasta desejada:
  1. `git clone git@github.com:viniciusilveira/banking_api.git`
  2. Entre no diretório do projeto: `cd banking_api

## Requisitos

- `Elixir 1.8.1`
- `Erlang 21.0`
- `PostgreSQL 9.6+`

#### 1. Instalar o PostgreSQL

Servidor de banco de dados utilizado.

> OSX:

  ```bash
  brew install postgres
  ```

> Ubuntu:

  ```bash
  sudo apt update
  sudo apt install postgresql postgresql-contrib
  ```

#### 2. Instalar o asdf através deste [Tutorial](https://github.com/asdf-vm/asdf#setup).

> O `asdf` serve para gerenciar múltiplas versões de uma linguagem em tempo de execução.

#### 3. Instalar Erlang e Elixir

> Link da [Documentação](https://elixir-lang.org/install.html#setting-path-environment-variable) da linguagem;

Instalar o `Elixir` e `Erlang` utilizando `asdf`:

  ```bash
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

  asdf install erlang 23.0
  asdf install elixir 1.10
  ```

Setar as versões utilizadas como globais:

  ```bash
  asdf global erlang 23.0
  asdf global elixir 1.10
  ```

> Caso ocorra algum erro com a versão do `Erlang`, substitua o número da versão por `ref:master`;

#### 4. Configurar Banco de Dados

Duplique os arquivos `dev` e `test` da pasta `banking_api/config/db`

  ```bash
  cd banking_api
  cp config/db/dev.secret.exs.example config/db/dev.secret.exs
  cp config/db/test.secret.exs.example config/db/test.secret.exs
  ```

Configure de acordo com as informações do seu banco de dados;

Crie e atualize seu banco com:

  ```bash
  mix ecto.create
  mix ecto.migrate
  ```
Instale as dependências do projeto:

  ```bash
  mix deps.get
  ```

#### 5. Executar a aplicação Phoenix

Inicie o servidor Phoenix e execute a aplicação

  ```bash
  mix phx.server
  ```
Agora você já pode acessar a API através do link `http://localhost:4000/`.

#### 6. Testar

Para executar os testes, utilize:

  ```bash
  mix test
  ```

## Instalando com Docker


1. Duplique os arquivos `dev` e `test` da pasta `banking_api/config/db`

  ```bash
  cd banking_api
  cp config/db/dev.secret.exs.example config/db/dev.secret.exs
  cp config/db/test.secret.exs.example config/db/test.secret.exs
  ```

2. Execute o comando abaixo:

```bash
docker-compose up --build
```

3. Testar

```bash
docker-compose run web mix test
```


### Postman

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/c62adbe83b7c4db42d51#?env%5BBanking%20API%5D=W3sia2V5IjoiQVBJX1VSTCIsInZhbHVlIjoiaHR0cHM6Ly9ndWFyZGVkLXJlZWYtNzI3OTYuaGVyb2t1YXBwLmNvbS8iLCJlbmFibGVkIjp0cnVlfSx7ImtleSI6IlVOSVFVRV9TVFJJTkciLCJ2YWx1ZSI6MTU2NDU4MzA1MDMxOSwiZW5hYmxlZCI6dHJ1ZX1d)

O Postman é uma ferramenta que tem como objetivo testar serviços RESTful (Web APIs) por meio do envio de requisições HTTP e da análise do seu retorno.

Para utilizar os endpoints da aplicação com o postman, importe a collection pelo link https://www.getpostman.com/collections/9d43de74607f4889360a
e importe as environments a partir do arquivo BankApi.postman_environment.json

Para executar autenticações autenticadas na aba `Authorization` do postman selecione a opção `Baerer Token` em type e adicione o token retornado na requisição de login ou autenticação.

Documentação da API: https://blue-robot-6636.postman.co/collections/1274212-f59ef137-3d6a-461a-8355-24a99bebc382?version=latest&workspace=1c405cba-a1ae-44cd-8b6a-8fde20c46a62

Para mais informações sobre o postman, acesse: https://www.getpostman.com/


