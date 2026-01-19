# Sistema de Fila

[Read in English](README.md)

Este recurso fornece um sistema simples de fila e gerenciamento de partidas para FiveM.

## Como Funciona

### Fila
- Os jogadores podem entrar ou sair da fila usando o comando `/queue`.
- O sistema gerencia os jogadores em uma lista, esperando participantes suficientes para iniciar uma partida.
- Quando um jogador entra na fila, o sistema verifica se há jogadores suficientes para criar uma nova partida.

### Gerenciamento de Partidas
- Quando uma partida começa, os jogadores são teleportados para um local predefinido e seu *routing bucket* é alterado para isolar a partida.
- O sistema monitora continuamente a vida dos jogadores na partida.
- Se a vida de um jogador atingir um nível crítico (considerado morto), ele é declarado o perdedor.
- O outro jogador é declarado o vencedor e a partida termina.
- Após a partida, os jogadores são retornados do *bucket* isolado.
- O sistema então atualiza as estatísticas gerais (`queueCount` e `matchesCount`).

## Comandos

- `/queue`: Entra ou sai da fila.
- `/status`: Mostra o número atual de jogadores na fila e as partidas ativas.
- `/bucket`: (Debug) Mostra o *routing bucket* atual do jogador.

## Decisões Técnicas

### Função `Event`

No arquivo `shared/utils.lua`, a função `Event(name)` é usada para padronizar os nomes dos eventos, adicionando um prefixo (`Config.eventPrefix`).

**Justificativa:**

- **Evita Conflitos:** Impede colisões de nomes de eventos com outros recursos no servidor. Usando um prefixo único (ex: `flk-queue:`), garantimos que nossos eventos sejam únicos.
- **Manutenibilidade:** Se precisarmos alterar o prefixo do evento, só precisamos modificá-lo em um lugar (`Config.eventPrefix`), e ele será atualizado em todo o recurso.
- **Legibilidade:** Torna o código mais limpo e legível, pois fica claro quais eventos pertencem a este recurso.

### Arquitetura do `Queue.lua`

O arquivo `server/libs/Queue.lua` foi projetado como uma classe usando metatables para fornecer uma estrutura orientada a objetos.

**Estruturas de Dados:**

- `self.queue` (tabela como lista): Uma tabela usada como uma lista FIFO (First-In, First-Out) para manter a ordem dos jogadores que entram na fila. Isso garante justiça, pois os jogadores que entram primeiro serão os primeiros a entrar em uma partida.
- `self.inQueue` (tabela como mapa de hash): Uma tabela usada para pesquisas rápidas (complexidade O(1) em média) para verificar se um jogador já está na fila. Isso é muito mais eficiente do que iterar pela lista `self.queue` toda vez que uma verificação é necessária.

**Métodos Principais:**

- `Queue:add(userId)`: Adiciona um jogador a ambas as estruturas `self.queue` e `self.inQueue`. Após adicionar, chama `_tryCreateMatch()` para verificar if uma nova partida pode ser iniciada.
- `Queue:remove(userId)`: Remove um jogador de ambas as estruturas de dados.
- `Queue:_tryCreateMatch()`: Um método privado que verifica se há jogadores suficientes na fila para atingir `self.maxPlayers`. Se sim, ele remove o número necessário de jogadores do início da fila e cria uma nova partida com eles.

### Arquitetura do `Match.lua`

O arquivo `server/libs/Match.lua` também foi projetado como uma classe e é responsável por gerenciar o ciclo de vida de uma única partida.

**Gerenciamento Global:**

- `matches` (tabela): Uma lista global que armazena todas as instâncias de partidas ativas.
- `playersMatch` (tabela): Um mapa de hash global para pesquisas rápidas para encontrar o `matchId` em que um jogador está. Isso permite verificações eficientes (ex: `isPlayerInMatch`).
- Uma `CreateThread` global executa um loop contínuo, chamando o método `tick()` em cada partida ativa. Isso permite que cada partida tenha sua própria lógica executando periodicamente (ex: verificar a vida do jogador).

**Ciclo de Vida da Partida:**

- `Match.new(players, cfg)`: Cria uma nova instância de partida. Ele atribui um `matchId` único, salva o estado original de cada jogador (`setPlayerData`) e os move para um *routing bucket* isolado (`Config.bucketOffset + self.matchId`) para evitar interferência de outros jogadores no servidor.
- `Match:stop()`: Termina a partida. Ele remove a partida da lista global `matches` e, o mais importante, restaura o estado original dos jogadores (`resetPlayerData`), incluindo sua vida, colete, coordenadas e *routing bucket* original.
- `Match:setPlayerData(playerId)` / `Match:resetPlayerData(playerId)`: Esses métodos são cruciais para garantir uma experiência sem interrupções. Eles salvam o estado de um jogador antes do início da partida e o restauram após o término da partida, tornando a transição transparente.

## Melhorias Futuras

Este recurso tem uma base sólida, mas há muitas oportunidades de expansão:

- **Múltiplos Tipos de Fila:** Implementar um sistema para gerenciar diferentes filas, cada uma com seu próprio conjunto de regras, como:
  - Diferentes modos de jogo (ex: 1v1, 2v2, 5v5, capture a bandeira).
  - Diferentes mapas ou locais para as partidas.
  - Loadouts de armas específicos.

- **Interface NUI:** Criar uma interface de usuário baseada na web (NUI) amigável para:
  - Listar todas as filas disponíveis e o número de jogadores atual.
  - Permitir que os jogadores entrem ou saiam das filas com um clique.
  - Exibir estatísticas de partidas e placares de líderes.

- **Filas Protegidas por Senha:** Adicionar a capacidade de criar filas privadas protegidas por senha, permitindo que os jogadores organizem partidas privadas com amigos.

- **Sistema de Classificação/MMR:** Implementar um sistema ELO ou MMR (Matchmaking Rating) para criar partidas mais equilibradas com base na habilidade do jogador.

- **Modo Espectador:** Permitir que os jogadores assistam às partidas em andamento.
