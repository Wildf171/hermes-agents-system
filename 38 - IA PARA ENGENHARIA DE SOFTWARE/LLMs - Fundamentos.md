---
title: "LLMs - Fundamentos"
category: "38 - IA PARA ENGENHARIA DE SOFTWARE"
tags:
  - engenharia-software
  - ia
  - llm
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# LLMs — Fundamentos (Large Language Models)

## Resumo

Um **LLM (Large Language Model)** é um modelo de IA — tipicamente uma **rede neural transformer** — treinado em grandes volumes de texto para tarefas de processamento de linguagem natural, especialmente **geração de texto**. É a base de assistentes como Claude, ChatGPT, Gemini e Grok.

## O que é?

Modelo que aprende padrões estatísticos da linguagem para **gerar, resumir, traduzir e analisar** texto. A maioria é baseada na arquitetura **Transformer** (paper "Attention Is All You Need", 2017). Os **GPTs** (Generative Pre-trained Transformers) são LLMs **pré-treinados para prever a próxima palavra (token)** e depois **ajustados (fine-tuned)** para seguir instruções e agir como assistentes.

## Por que existe?

Antes dos transformers (2017), modelos de linguagem eram limitados. A combinação de **transformers + escala (dados + compute)** produziu capacidades emergentes de compreensão e geração, viabilizando aplicações antes inviáveis.

## Como funciona? — Conceitos centrais

- **Token** — unidade de texto (≈ ¾ de palavra); o modelo processa e gera tokens.
- **Transformer / Self-attention** — mecanismo que pondera a relação entre tokens do contexto.
- **Pré-treino** — aprende a prever o próximo token em corpus massivo.
- **Fine-tuning / RLHF** — alinha o modelo a instruções e preferências humanas.
- **Context window** — quantidade de tokens que o modelo "vê" de uma vez (entrada + saída).
- **Parâmetros** — pesos aprendidos (bilhões); mais ≈ mais capacidade (e custo).
- **Temperatura** — controla aleatoriedade da geração (0 = determinístico).
- **Embeddings** — representação vetorial de texto (base de busca semântica e [[RAG - Retrieval-Augmented Generation|RAG]]).

## Limitações importantes

- **Alucinação** — pode gerar informação plausível porém **falsa** (mitigável com [[RAG - Retrieval-Augmented Generation|RAG]]).
- **Knowledge cutoff** — conhecimento congelado na data de treino (sem RAG/ferramentas).
- **Não "raciocina" como humano** — prevê tokens; pode errar em lógica/matemática.
- **Viés** — herda vieses dos dados de treino.
- **Custo/latência** — proporcionais ao tamanho e aos tokens.

## Exemplo prático (uso via API)

```python
# Pseudocódigo de chamada a um LLM
resp = client.messages.create(
    model="claude-...",
    max_tokens=1024,
    temperature=0,                 # saída mais determinística
    messages=[{"role":"user","content":"Resuma este texto: ..."}]
)
```

## Quando utilizar

- Geração/resumo/tradução/classificação de texto.
- Assistentes, extração de dados, [[AI Coding Agents|geração de código]].
- Combinado com [[RAG - Retrieval-Augmented Generation|RAG]] para dados próprios/atualizados.

## Quando NÃO utilizar

- Tarefas que exigem **exatidão garantida** sem verificação (cálculos críticos, decisões legais/médicas sem revisão).
- Onde não se pode tolerar alucinação nem revisar a saída.
- Dados sensíveis sem política de privacidade adequada.

## Trade-offs

- Poder e flexibilidade **vs.** custo, latência, alucinação e imprevisibilidade.
- Modelos maiores: mais capazes, porém mais caros/lentos.

## Erros comuns / Anti-patterns

- Confiar na saída sem verificar (alucinação).
- Enviar dados sensíveis sem cuidado.
- Ignorar limite de contexto (truncamento silencioso).
- Usar modelo enorme para tarefa trivial (custo).

## Boas práticas

- **Verificar** saídas factuais; usar [[RAG - Retrieval-Augmented Generation|RAG]] para grounding.
- Bom [[Prompt Engineering|prompt engineering]]; temperatura baixa para tarefas determinísticas.
- Escolher o modelo pelo trade-off custo × capacidade da tarefa.
- Guardrails, avaliação (evals) e observabilidade.

## Conceitos relacionados

- [[Prompt Engineering]]
- [[RAG - Retrieval-Augmented Generation]]
- [[AI Agents - Introduction]]
- [[MCP - Model Context Protocol]]
- [[Claude - Capabilities]]

## Perguntas importantes

### O que é um token?
A unidade de texto que o LLM processa (~¾ de palavra). Custo e limite de contexto são medidos em tokens.

### Por que LLMs alucinam?
Eles preveem o próximo token com base em padrões, não consultam uma base de fatos. Sem grounding (RAG/ferramentas), podem gerar afirmações plausíveis mas falsas.

## Fontes

1. Wikipedia — Large language model — https://en.wikipedia.org/wiki/Large_language_model (consultado 2026-09-03)
2. Vaswani et al. (2017). "Attention Is All You Need."
3. Documentação Anthropic — https://docs.anthropic.com

## Observações

Para uso prático de modelos Claude (IDs, preços, parâmetros), consultar a skill/documentação oficial atualizada. Aprofundar: embeddings, fine-tuning, evals. Status: verified.
