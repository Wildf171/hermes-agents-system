---
title: "gRPC"
category: "11 - APIs"
tags:
  - engenharia-software
  - api
  - grpc
  - rpc
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# gRPC

## Resumo

**gRPC** (acrônimo recursivo de *gRPC Remote Procedure Calls*) é um framework **RPC** multiplataforma e de **alto desempenho**, criado pelo **Google** (open source em **2016**). Usa **HTTP/2** como transporte e **Protocol Buffers** como linguagem de definição de interface (IDL) e formato de serialização binária. É muito usado para comunicação entre [[Microsservicos|microsserviços]].

## O que é?

Em vez de recursos/URLs (REST) ou queries (GraphQL), gRPC expõe **métodos/procedimentos** que o cliente chama como se fossem locais (RPC). Você define serviços e mensagens em um arquivo **`.proto`**, e o gRPC **gera código** de cliente e servidor para várias linguagens (Go, Java, Python, C++, C#, etc.).

Origem: o Google tinha o **Stubby** (RPC interno, ~2001) para conectar seus microsserviços; em 2015 decidiu construir a próxima versão como open source → gRPC.

## Por que existe?

Comunicação **serviço-a-serviço** eficiente: binário compacto (Protobuf) + HTTP/2 (multiplexação, streaming) resultam em baixa latência e alto throughput — melhor que JSON/HTTP1.1 para tráfego interno intenso.

## Como funciona?

- **`.proto`** define serviços e mensagens (contrato tipado):
```proto
service PedidoService {
  rpc ObterPedido (PedidoId) returns (Pedido);
  rpc StreamPedidos (Filtro) returns (stream Pedido);
}
message PedidoId { int32 id = 1; }
```
- **Protocol Buffers** serializam em binário (menor/mais rápido que JSON).
- **HTTP/2** permite **4 tipos de chamada**: unary, server-streaming, client-streaming e **bidirectional streaming**.
- Codegen cria stubs de cliente/servidor.
- Segurança: **TLS** + autenticação por token (channel/call credentials, interceptors).

## Quando utilizar

- Comunicação **interna entre microsserviços** (alto desempenho).
- Streaming bidirecional, baixa latência (IoT, tempo real).
- Ambientes **polyglot** que compartilham contratos `.proto`.

## Quando NÃO utilizar

- **APIs públicas para navegadores** — gRPC usa HTTP trailers e **não roda direto no browser**; exige proxy (**gRPC-Web**). Para web pública, REST/GraphQL são mais simples.
- Quando legibilidade (JSON) e ampla compatibilidade importam mais que performance.

## Trade-offs

- **Ganha:** performance (binário + HTTP/2), streaming, contrato tipado forte, codegen multi-linguagem.
- **Perde:** menos legível (binário), não nativo no browser, tooling/depuração menos triviais, curva de aprendizado (Protobuf/HTTP2).

## Erros comuns / Anti-patterns

- Usar gRPC para API pública de browser sem gRPC-Web/proxy.
- Quebrar compatibilidade do `.proto` (renumerar/reusar field numbers) → quebra clientes.
- Ignorar deadlines/timeouts e cancelamento.
- Não versionar contratos com cuidado.

## Boas práticas

- **Nunca reusar/renumerar** field numbers no Protobuf (compatibilidade).
- Definir **deadlines**, timeouts e retries; usar streaming quando fizer sentido.
- TLS sempre; autenticação por interceptors.
- Versionar pacotes `.proto`.

## Conceitos relacionados

- [[APIs REST - Fundamentos e Design]]
- [[GraphQL]]
- [[REST vs GraphQL vs gRPC]]
- [[Microsservicos]]
- [[Redes - TCP-IP, HTTP, DNS e TLS]] (HTTP/2)

## Perguntas importantes

### Por que gRPC é rápido?
Usa **Protocol Buffers** (binário compacto) sobre **HTTP/2** (multiplexação, streaming, compressão de headers) — bem mais eficiente que JSON sobre HTTP/1.1.

### Posso usar gRPC no navegador?
Não diretamente — precisa de **gRPC-Web** com um proxy, por causa do uso de HTTP trailers.

## Fontes

1. Wikipedia — gRPC — https://en.wikipedia.org/wiki/GRPC (consultado 2026-09-03)
2. grpc.io — documentação oficial — https://grpc.io/docs/
3. Protocol Buffers — https://protobuf.dev

## Observações

Criar notas: Protocol Buffers a fundo, tipos de streaming, gRPC-Web. Status: verified.
