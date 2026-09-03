---
title: "Coesão e Acoplamento"
category: "05 - PRINCÍPIOS DE SOFTWARE"
tags:
  - engenharia-software
  - principios
  - design
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Coesão e Acoplamento

## Resumo

**Coesão** mede o quanto os elementos *dentro* de um módulo pertencem juntos (querer forte relação = bom). **Acoplamento** mede a interdependência *entre* módulos (querer relação fraca = bom). O objetivo de design é **alta coesão + baixo acoplamento** — a dupla que mais influencia manutenibilidade.

## O que é?

- **Coesão:** força da relação entre métodos e dados de um módulo/classe em torno de um propósito único. Medida ordinal: "alta" ou "baixa".
- **Acoplamento:** grau de dependência de um módulo em relação a outros.

Foram inventados por **Larry Constantine** no fim dos anos 1960 (Structured Design), publicados em **Stevens, Myers & Constantine (1974)** e no livro **Yourdon & Constantine (1979)**. Tornaram-se termos padrão da engenharia de software.

> Regra de ouro: **alta coesão costuma correlacionar com baixo acoplamento**, e vice-versa.

## Por que existe?

Constantine buscava características de "boa" programação que **reduzissem custos de manutenção e modificação**. Módulos coesos e desacoplados podem ser entendidos, testados, reusados e alterados isoladamente.

## Como funciona? — Tipos (do pior ao melhor)

### Coesão (quanto mais alta, melhor)
1. Coincidental (pior — elementos sem relação)
2. Lógica
3. Temporal
4. Procedural
5. Comunicacional
6. Sequencial
7. **Funcional** (melhor — tudo contribui para uma única tarefa bem definida)

### Acoplamento (quanto mais baixo, melhor)
1. **Acoplamento de conteúdo** (pior — um módulo mexe no interior do outro)
2. Comum (variáveis globais compartilhadas)
3. Externo
4. De controle (um módulo controla o fluxo do outro via flags)
5. Stamp (passa estrutura inteira usando só parte)
6. **De dados** (melhor — troca só os dados necessários por parâmetros)

## Conceitos fundamentais

- **Módulo** — classe, função, pacote, serviço.
- Relação com [[32 - SOLID/_INDEX|SOLID]]: SRP aumenta coesão; DIP e ISP reduzem acoplamento.
- Relação com [[DRY, KISS e YAGNI|DRY]]: eliminar duplicação de conhecimento sem criar acoplamento indevido.

## Exemplo prático

```python
# BAIXA coesão + ALTO acoplamento (ruim)
class Utils:
    def calcular_imposto(self, v): ...
    def enviar_email(self, msg): ...
    def salvar_no_banco(self, x): ...   # faz coisas não relacionadas

# ALTA coesão + BAIXO acoplamento (bom)
class CalculadoraImposto:               # um propósito
    def calcular(self, valor): ...

class NotificadorEmail:                 # outro propósito
    def enviar(self, msg): ...
# Dependências injetadas (parâmetros/interfaces) -> acoplamento de dados
```

## Quando utilizar

Sempre como critério de design ao dividir código em módulos, classes e serviços — inclusive ao definir fronteiras de [[34 - MICROSERVICOS/_INDEX|microsserviços]] e [[33 - DDD/_INDEX|bounded contexts]].

## Quando NÃO utilizar (nuance)

- Buscar acoplamento "zero" é irreal: módulos precisam colaborar. O alvo é **acoplamento fraco e explícito** (via interfaces/contratos), não ausência de dependências.
- Coesão levada ao extremo pode fragmentar demais o código.

## Erros comuns / Anti-patterns

- **God object / classe "Utils"** — baixa coesão.
- **Acoplamento por estado global** (variáveis globais, singletons abusivos).
- **Acoplamento de controle** via flags booleanas que dishowram o fluxo alheio.
- Vazar detalhes internos entre módulos (quebra encapsulamento).

## Boas práticas

- Aplicar **SRP** (uma razão para mudar) → aumenta coesão.
- **Injeção de dependência** e programar para **interfaces** → reduz acoplamento.
- Definir fronteiras por **capacidade de negócio**, não por camada técnica.

## Conceitos relacionados

- [[DRY, KISS e YAGNI]]
- [[32 - SOLID/_INDEX|SOLID]]
- [[Orientacao a Objetos]]
- [[09 - ARQUITETURA DE SOFTWARE/_INDEX|Arquitetura]]
- [[43 - ANTIPATTERNS/_INDEX|Anti-patterns]]

## Perguntas importantes

### Qual a relação entre coesão e acoplamento?
São complementares: alta coesão (elementos do módulo bem relacionados) tende a produzir baixo acoplamento (menos dependências entre módulos). Design bom busca as duas.

### Quem criou esses conceitos?
Larry Constantine (fim dos anos 1960), formalizados por Stevens, Myers & Constantine (1974) e Yourdon & Constantine (1979).

## Fontes

1. Wikipedia — Cohesion (computer science) — https://en.wikipedia.org/wiki/Cohesion_(computer_science) (consultado 2026-09-03)
2. Wikipedia — Coupling (computer programming) — https://en.wikipedia.org/wiki/Coupling_(computer_programming)
3. Stevens, Myers & Constantine (1974), "Structured Design", IBM Systems Journal.
4. Yourdon, E. & Constantine, L. (1979). *Structured Design.*

## Observações

Escalas de tipos de coesão/acoplamento conforme literatura clássica (Structured Design). Status: verified.
