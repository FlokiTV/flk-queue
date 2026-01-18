## DESAFIO
Desenvolver um sistema de fila PvP automático (standalone), onde:

- Jogadores podem entrar e sair de uma fila PvP
- Quando houver jogadores suficientes, o sistema deve criar automaticamente um match 1x1
- Os jogadores pareados devem ser teleportados para uma arena selecionada aleatoriamente (pode ser um local comum do mapa)
- O sistema deve salvar a posição original de cada jogador antes do teleporte

### Ao término da partida (quando um jogador eliminar o outro):

- A partida deve ser finalizada corretamente
- Ambos os jogadores devem retornar para suas posições originais
- Todos os dados da partida devem ser limpos corretamente

## Requisitos adicionais:

- O sistema deve suportar múltiplas partidas acontecendo simultaneamente
- As partidas devem ser totalmente isoladas entre si
- Após o encerramento de uma partida, o sistema deve continuar funcionando normalmente, sem necessidade de reiniciar a resource
- O sistema deve ser 100% standalone, sem dependência de frameworks externos
- Deve ser exibido:
  - Quantidade de jogadores atualmente na fila
  - Quantidade de partidas em andamento
- As informações podem ser exibidas utilizando texto 2D simples (não é necessário UI)

### NÃO É NECESSÁRIO
- Interface gráfica
- Banco de dados
- Ranking ou estatísticas

### PRAZO
- 2 dias corridos

### ENTREGA
- Pasta repositório Git
- Arquivo README.md simples explicando:
  - Funcionamento da fila
  - Gerenciamento das partidas
  - Principais decisões técnicas