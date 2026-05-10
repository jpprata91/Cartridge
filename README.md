# Cartridge

Cartridge é um bot para Discord desenvolvido em Elixir com o framework **Nostrum**.  
O projeto foi criado para atender aos requisitos da atividade da disciplina de Programação Funcional, incluindo:

- uso de API REST externa;
- despacho de comandos com pattern matching;
- organização em módulos com responsabilidades separadas;
- persistência de dados em JSON;
- supervisão com OTP.

## Estrutura do projeto

- `Cartridge.Application` → ponto de entrada da aplicação e supervisor principal
- `Cartridge.Consumer` → recebe eventos do Discord e despacha comandos
- `Cartridge.Commands` → contém a lógica de todos os comandos
- `Cartridge.Store` → leitura e escrita do arquivo JSON de persistência
- `Cartridge.Http` → centraliza requisições HTTP
- `Cartridge.Api.*` → módulos de integração com APIs externas

## Requisitos

- Elixir
- Erlang/OTP
- Conta de bot no Discord
- Token do bot
- Chave da API do TheGamesDB

## Dependências utilizadas

- `nostrum`
- `httpoison`
- `jason`

## Comandos disponíveis

| Comando | Descrição | Exemplo |
|---|---|---|
| `!ping` | Verifica se o bot está online | `!ping` |
|`!pokemon <nome\|id>` | Busca informações de um Pokémon usando a PokéAPI | `!pokemon pikachu` |
| `!nintendogame <console> <random\|índice>` | Busca um jogo de um console Nintendo | `!nintendogame SNES random` |
| `!clima <cidade>` | Mostra informações climáticas da cidade | `!clima fortaleza` |
| `!conv <valor> <origem> <destino>` | Converte moedas usando API de câmbio | `!conv 100 USD BRL` |
| `!lembrar <texto>` | Salva um lembrete no JSON | `!lembrar estudar elixir` |
| `!lembretes` | Lista os lembretes salvos | `!lembretes` |
| `!curiosidade <cidade>` | Combina APIs para mostrar curiosidades sobre uma cidade | `!curiosidade fortaleza` |

---


## Configuração

### 1. Variáveis de ambiente

Antes de executar o projeto, defina as variáveis de ambiente:

#### Windows CMD
```cmd
set DISCORD_TOKEN=seu_token_aqui
set THEGAMESDB_KEY=sua_chave_aqui