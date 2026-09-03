---
title: "Prompt Engineering"
category: "38 - IA PARA ENGENHARIA DE SOFTWARE"
tags:
  - engenharia-software
  - ia
  - prompt-engineering
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Prompt Engineering

## Resumo

**Prompt engineering** é o processo de **estruturar as instruções em linguagem natural** (prompts) para obter as saídas desejadas de um modelo de IA generativa. **Context engineering** é a área relacionada que gerencia todo o contexto fornecido ao modelo (instruções de sistema, metadados, ferramentas/tokens), não só o prompt.

## O que é?

Projetar e refinar as instruções dadas a um LLM para respostas mais **precisas, relevantes e úteis**. Exige entender **como o modelo interpreta a linguagem**. Envolve técnicas como few-shot, chain-of-thought e atribuição de papel.

## Por que existe?

A mesma pergunta, formulada de formas diferentes, produz resultados muito diferentes. Bons prompts reduzem ambiguidade, alucinação e retrabalho — extraindo melhor desempenho do modelo sem alterar o modelo em si.

## Como funciona? — Técnicas principais

- **Zero-shot** — só a instrução, sem exemplos.
- **Few-shot (multi-shot)** — inclui exemplos de entrada→saída para guiar o formato/estilo.
- **Chain-of-Thought (CoT)** — pedir para "pensar passo a passo"; melhora raciocínio em tarefas complexas.
- **Tree-of-Thought** — explora múltiplos caminhos de raciocínio.
- **Role assignment** — "Você é um revisor de segurança..." define persona/contexto.
- **Structured output** — pedir JSON/formato específico.
- **RAG** ([[RAG - Retrieval-Augmented Generation]]) — injeta contexto recuperado para fundamentar a resposta.

## Anatomia de um bom prompt

1. **Papel/contexto** — quem o modelo é e para quê.
2. **Tarefa clara** — o que fazer, específico.
3. **Restrições** — formato, tamanho, tom, o que evitar.
4. **Exemplos** (few-shot) quando o formato importa.
5. **Dados/contexto** relevantes.

## Exemplo prático

```
❌ Fraco: "Escreva sobre segurança."

✅ Forte:
"Você é um engenheiro de AppSec. Explique os 3 riscos mais críticos
do OWASP Top 10 2025 para uma API REST em FastAPI. Para cada um:
o risco, um exemplo de código vulnerável e a mitigação.
Responda em português, em markdown, máximo 400 palavras."
```

## Quando utilizar

- Sempre que interagir com LLMs para tarefas não triviais.
- Automação com IA (extração, classificação, geração) onde consistência importa.

## Quando NÃO utilizar (nuance)

- Não substitui **grounding** (RAG/ferramentas) quando o problema é falta de dados — prompt não inventa fatos corretos.
- Modelos modernos já geram bons prompts; "engenheiro de prompt" como cargo tornou-se menos comum.

## Erros comuns / Anti-patterns

- Prompt vago/ambíguo.
- Pedir muitas coisas de uma vez sem estrutura.
- Não especificar formato de saída quando ele importa.
- **Prompt injection** — não tratar entrada não confiável como potencial ataque (dados podem conter instruções maliciosas). Ver [[OWASP Top 10]] (segurança de IA).

## Boas práticas

- Ser **específico**: papel, tarefa, restrições, formato.
- Few-shot para formato; CoT para raciocínio.
- Iterar e avaliar (evals) com casos reais.
- Isolar **dados** de **instruções** (mitiga prompt injection).

## Conceitos relacionados

- [[LLMs - Fundamentos]]
- [[RAG - Retrieval-Augmented Generation]]
- [[AI Agents - Introduction]]
- [[Claude - Capabilities]]

## Perguntas importantes

### O que é chain-of-thought?
Técnica de pedir ao modelo para raciocinar **passo a passo**, melhorando o desempenho em tarefas que exigem lógica/multi-etapas.

### Prompt engineering vs context engineering?
Prompt engineering foca no texto da instrução; context engineering gerencia todo o contexto (system prompt, ferramentas, metadados, memória) entregue ao modelo.

## Fontes

1. Wikipedia — Prompt engineering — https://en.wikipedia.org/wiki/Prompt_engineering (consultado 2026-09-03)
2. Anthropic — Prompt engineering guide — https://docs.anthropic.com
3. Wei et al. (2022) — "Chain-of-Thought Prompting."

## Observações

Aprofundar: prompt injection (segurança), few-shot vs fine-tuning, evals. Status: verified.
