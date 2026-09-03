---
title: "RAG - Retrieval-Augmented Generation"
category: "38 - IA PARA ENGENHARIA DE SOFTWARE"
tags:
  - engenharia-software
  - ia
  - rag
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# RAG — Retrieval-Augmented Generation

## Resumo

**RAG** é uma técnica que permite a um LLM **recuperar e incorporar informação de fontes externas** antes de responder. O modelo consulta um conjunto de documentos e usa esse conteúdo para fundamentar a resposta — trazendo dados **específicos do domínio e atualizados** que não estão no treino, e **reduzindo alucinações**. Proposto em um **paper de 2020**.

## O que é?

Combina **recuperação de informação** (busca) com **geração** (LLM):
1. A pergunta é convertida em busca sobre uma base (documentos, banco, web).
2. Os trechos mais relevantes são recuperados.
3. Esses trechos são **injetados no prompt** como contexto.
4. O LLM gera a resposta **fundamentada** nesses trechos (e pode **citar as fontes**).

Une um modelo **paramétrico** (o LLM) a uma **memória externa não paramétrica** acessada por recuperação no momento da inferência.

## Por que existe?

LLMs têm **knowledge cutoff** e **alucinam**. RAG resolve isso sem **retreinar** o modelo:
- Acesso a dados **privados/atuais** (docs internos, base de conhecimento — como este vault!).
- **Menos alucinação** (respostas ancoradas em fontes).
- **Transparência** — pode citar e o usuário verifica.
- **Custo** — evita fine-tuning caro para conhecimento factual.

## Como funciona? — Pipeline típico

```
Ingestão (offline):
  Documentos → chunking (dividir) → embeddings → Vector DB

Consulta (online):
  Pergunta → embedding → busca por similaridade no Vector DB
          → top-k trechos → montar prompt (pergunta + trechos)
          → LLM gera resposta com as fontes
```

### Componentes
- **Chunking** — dividir documentos em pedaços (tamanho/overlap importam).
- **Embeddings** — vetores que capturam significado (busca **semântica**).
- **Vector Database** — Pinecone, Weaviate, pgvector, Qdrant, Chroma.
- **Retriever** — recupera top-k por similaridade (às vezes + reranking).
- **Busca híbrida** — combina semântica (vetorial) + léxica (BM25).

## Exemplo prático (conceito)

```python
# 1) offline: indexar
for chunk in split(documentos):
    vectordb.add(embed(chunk), metadata=chunk.source)

# 2) online: responder
trechos = vectordb.search(embed(pergunta), k=5)
prompt = f"Contexto:\n{trechos}\n\nPergunta: {pergunta}\nResponda citando as fontes."
resposta = llm(prompt)
```

## Quando utilizar

- Q&A sobre **dados próprios** (documentação, políticas, base de conhecimento).
- Chatbots corporativos, assistentes de suporte, busca semântica.
- Quando precisa de **fontes citáveis** e informação atualizada.

## Quando NÃO utilizar

- Conhecimento já coberto pelo modelo e estável → RAG adiciona complexidade sem ganho.
- Tarefas puramente de raciocínio/estilo (não de recuperação de fatos).
- Quando fine-tuning é melhor (mudar comportamento/estilo, não injetar fatos).

## Trade-offs

- Fatos atualizados e citáveis **vs.** complexidade (pipeline, vector DB, chunking).
- Qualidade depende **muito** da recuperação: "garbage in, garbage out".

## Erros comuns / Anti-patterns

- **Chunking ruim** (grande/pequeno demais) → contexto irrelevante.
- Recuperar top-k demais → dilui o contexto e estoura tokens.
- Ignorar **reranking**/busca híbrida quando a semântica sozinha falha.
- Não tratar o caso "nada relevante encontrado" (modelo alucina para preencher).
- Não citar/rastrear as fontes.

## Boas práticas

- Ajustar chunk size/overlap ao domínio; testar com evals.
- **Busca híbrida** + reranking para relevância.
- Instruir o modelo a responder **apenas** com base no contexto e dizer quando não sabe.
- Citar fontes; monitorar qualidade (relevância, groundedness).

## Conceitos relacionados

- [[LLMs - Fundamentos]]
- [[Prompt Engineering]]
- [[AI Agents - Introduction]]
- [[12 - BANCOS DE DADOS/_INDEX|Bancos de Dados (vector DB / pgvector)]]

## Perguntas importantes

### RAG ou fine-tuning?
**RAG** para injetar **conhecimento** (fatos, dados atuais/privados) com fontes. **Fine-tuning** para mudar **comportamento/estilo/formato**. Muitas vezes se combinam.

### RAG elimina alucinação?
Reduz bastante ao ancorar em fontes, mas **não elimina** — a qualidade depende da recuperação e do prompt (instruir a admitir quando não há resposta).

## Fontes

1. Wikipedia — Retrieval-augmented generation — https://en.wikipedia.org/wiki/Retrieval-augmented_generation (consultado 2026-09-03)
2. Lewis et al. (2020). "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks."
3. Anthropic / provedores — guias de RAG e embeddings.

## Observações

Aprofundar: embeddings, vector DBs, reranking, avaliação de RAG (RAGAS). Status: verified.
