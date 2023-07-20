<h1 align="center" >
   Code Challenge
</h1>

#### Api que faz o uso da Api do Rick e Morty em suas requisições, deselvolvida em crystal para o processo seletivo da Milênio Capital.

## Sumário

- [Início Rápido](#início-rápido)
  - [Executar o projeto](#executar-o-projeto-docker)
- [Endpoints](#endpoints)
- [Testes](#testes)

## Início Rápido

[ Voltar para o topo ](#sumário)

### Executar o projeto: **Docker**

<h4 align="center"><strong>🚨 Importante 🚨</strong></h4>
Antes de prosseguir confirme que possui o <strong><a href="https://docs.docker.com/get-docker/">Docker</a></strong> e o  <strong><a href="https://docs.docker.com/compose/install/">Docker Compose</a></strong> instalados em sua máquina. Eles são necessários para seguir os proximos passos.

<br>

Faça um clone do projeto na sua máquina:

```shell
git clone git@github.com:jallesbatista/Crystal-RickAndMorty-API.git
```

Entre na pasta do arquivo que clonou:

```shell
cd Crystal-RickAndMorty-API && code .
```

Execute o comando e aguarde as imagens serem compiladas e os containers executados, após isso a aplicação já estará pronta para uso:

```shell
docker compose up -d
```

## Testes

[ Voltar para o topo ](#sumário)

<h4 align="center"><strong>🚨 Importante 🚨</strong></h4>
Antes de prosseguir confirme que possui o <strong><a href="https://crystal-lang.org/install/">Crystal</a></strong> instalado em sua máquina. Ele será necessário para se utilizar dos comando a seguir:

<br>

Para executar os testes pelo módulo padrão utilize:

```shell
crystal spec
```

Caso queira rodar o arquivo de testes individualmente, ele também está localizado no diretório raiz, sendo necessário somente executar:

```shell
crystal runtest
```

## Endpoints

[ Voltar para o topo ](#sumário)

### Índice

- [Travel_Stops](#1-travel_stops)
  - [Criação do plano de viagem](#11-criação-do-plano-de-viagem)
  - [Listar todos os planos de viagem](#12-listar-todos-os-planos-de-viagem)
  - [Buscar plano de viagem](#13-buscar-plano-de-viagem)
  - [Atualizar plano de viagem](#14-atualizar-plano-de-viagem)
  - [Deletar plano de viagem](#15-deletar-o-plano-de-viagem)

<br>

<h4 align="center"><strong>🚨 Importante 🚨</strong></h4>
Todas as rotas que recebem um <strong>id</strong> como parâmetro estão sujeitas a verificação do formato desse id. Não sendo um <strong>número inteiro</strong> será retornado o erro:

| Código do Erro  | Descrição                     |
| --------------- | ----------------------------- |
| 400 Bad Request | "Id param must be an integer" |

## 1. **Travel_stops**

[ Voltar aos Endpoints ](#endpoints)

| Método | Rota              | Descrição                                                               |
| ------ | ----------------- | ----------------------------------------------------------------------- |
| POST   | /travel_stops     | Criação de um plano de viagem.                                          |
| GET    | /travel_stops     | Listar todos os planos de viagem.                                       |
| GET    | /travel_stops/:id | Buscar o plano de viagem referente ao **id** informado.                 |
| PUT    | /travel_stops/:id | Atualizar informações do plano de viagem referente ao **id** informado. |
| DELETE | /travel_stops/:id | Deletar o plano de viagem referente ao **id** informado.                |

### 1.1. **Criação do plano de viagem**

[ Voltar aos Enpoints](#endpoints)

### `POST /travel_stops`

### Exemplo de Request:

```
POST /travel_stops
Host: http://localhost:3000
Authorization: None
Content-type: application/json
```

### Exemplo de Corpo da Requisição:

```json
{
  "travel_stops": [1, 2, 3]
}
```

### Exemplo de Response:

```
201 CREATED
```

```json
{
  "id": 1,
  "travel_stops": [1, 2, 3]
}
```

### Possíveis Erros:

| Código do Erro  | Descrição                          |
| --------------- | ---------------------------------- |
| 404 Not Found   | "Location with id # was not found" |
| 400 Bad Request | "travel_stops required"            |
| 400 Bad Request | "Must be a array of integers"      |

### 1.2 **Listar todos os planos de viagem**

[ Voltar aos Enpoints](#endpoints)

### `GET /travel_stops`

### Query params:

- `optimize`

        Quando verdadeiro, o array de travel_stops é ordenado de maneira a otimizar a viagem. Ao receber esse parâmetro, a API retorna o array de `travel_stops` reordenado com o objetivo de minimizar o número de saltos interdimensionais e organizar as paradas de viagem passando das localizações menos populares para as mais populares.

- `expand`

        Ao receber esse parâmetro, a API deve expandir as paradas de cada viagem de modo que o campo `travel_stops` deixe de ser um array de inteiros representando os IDs de cada localização e passe a ser um array de objetos da forma:

  ```json
  {
    "id": 1,
    "name": "Earth (C-137)",
    "type": "Planet",
    "dimension": "Dimension C-137"
  }
  ```

  Populado com os dados da respectiva localização registrada na Rick and Morty API sob o dado ID. Para mais detalhes sobre a Rick and Morty API acesse: <a href="https://rickandmortyapi.com">Rick and Morty API</a>

<br>

### Exemplo de Request:

```
GET /travel_stops
Host: http://localhost:3000
Authorization: None
Content-type: None
```

### Exemplo de Corpo da Requisição:

```json
Vazio
```

### Exemplo de Response:

```
200 OK
```

```json
[
    {
        "id": 1,
        "travel_stops": [
            1,
            2,
            3
        ]
    },
    ...
]
```

### 1.3 **Buscar plano de viagem**

[ Voltar aos Enpoints](#endpoints)

### `GET /travel_stops/:id`

**Query params**:
<br>
Para mais detalhes veja [a descrição](#query-params).

- `optimize`
- `expand`

### Exemplo de Request:

```
GET /travel_stops/1
Host: http://localhost:3000
Authorization: None
Content-type: None
```

### Exemplo de Corpo da Requisição:

```json
Vazio
```

### Exemplo de Response:

```
200 OK
```

```json
{
  "id": 1,
  "travel_stops": [1, 2, 3]
}
```

### 1.4 **Atualizar plano de viagem**

[ Voltar aos Enpoints](#endpoints)

### `PUT /travel_stops/:id`

### Exemplo de Request:

```
PUT /travel_stops/1
Host: http://localhost:3000
Authorization: None
Content-type: application/json
```

### Exemplo de Corpo da Requisição:

```json
{
  "travel_stops": [3, 4, 5]
}
```

### Exemplo de Response:

```
200 OK
```

```json
{
  "id": 1,
  "travel_stops": [3, 4, 5]
}
```

### Possíveis Erros:

| Código do Erro  | Descrição                          |
| --------------- | ---------------------------------- |
| 404 Not Found   | "Location with id # was not found" |
| 400 Bad Request | "travel_stops required"            |
| 400 Bad Request | "Must be a array of integers"      |

### 1.5 **Deletar o plano de viagem**

[ Voltar aos Enpoints](#endpoints)

### `DELETE /travel_stops/:id`

### Exemplo de Request:

```
DELETE /travel_stops/1
Host: http://localhost:3000
Authorization: None
Content-type: None
```

### Corpo da Requisição:

```json
Vazio
```

### Exemplo de Response:

```
204 NO CONTENT
```

```json
Vazio
```

### Possíveis Erros:

| Código do Erro | Descrição               |
| -------------- | ----------------------- |
| 404 Not Found  | "Travel plan not found" |

---

## Contributors

[ Voltar para o topo ](#sumário)

- [Jalles Batista](https://github.com/your-github-user) - creator and maintainer
