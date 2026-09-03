---
title: "Redes - TCP/IP, HTTP, DNS e TLS"
category: "24 - REDES"
tags:
  - engenharia-software
  - redes
  - http
  - tcp-ip
  - infraestrutura
  - conceito
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Redes — TCP/IP, HTTP, DNS e TLS

## Resumo

A comunicação na internet é organizada pela **suíte de protocolos TCP/IP**, em **4 camadas**. Sobre ela rodam os protocolos que todo desenvolvedor usa: **HTTP** (web), **DNS** (nomes → IPs) e **TLS** (criptografia/HTTPS). Padrões mantidos pela **IETF** (RFCs).

## O que é a suíte TCP/IP?

Framework que especifica como os dados são **empacotados, endereçados, transmitidos, roteados e recebidos**. Protocolos fundamentais: **TCP**, **UDP** e **IP**. Nasceu de pesquisa da **DARPA** (ARPANET, fim dos anos 1960) e **precede o modelo OSI**.

### As 4 camadas
1. **Link** — dentro de um segmento de rede (Ethernet, ARP, MAC).
2. **Internet** — interliga redes; endereçamento e roteamento (**IP** v4/v6, ICMP).
3. **Transporte** — comunicação host-a-host (**TCP**, **UDP**, QUIC).
4. **Aplicação** — processo-a-processo (**HTTP**, **DNS**, **TLS**, SMTP, SSH…).

## TCP vs UDP

| | **TCP** | **UDP** |
|---|---|---|
| Conexão | Orientado a conexão (handshake) | Sem conexão |
| Garantia | Entrega ordenada e confiável | "Best effort", sem garantia |
| Uso | Web, APIs, e-mail | Streaming, jogos, DNS, VoIP |
| Custo | Maior overhead | Rápido, leve |

## HTTP (HyperText Transfer Protocol)

Protocolo de aplicação **request/response**, **stateless**, base da web.
- **Métodos:** GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS.
- **Status:** 2xx sucesso, 3xx redirecionamento, 4xx erro do cliente, 5xx erro do servidor.
- **Versões:** HTTP/1.1 (texto), HTTP/2 (multiplexação binária), **HTTP/3** (sobre QUIC/UDP).
- **Stateless:** estado mantido via cookies, tokens, sessões.
- Base para [[11 - APIs/_INDEX|APIs REST]].

## DNS (Domain Name System)

"Lista telefônica" da internet: traduz **nomes** (`exemplo.com`) em **endereços IP**.
- Hierárquico e distribuído: root → TLD (`.com`) → autoritativo.
- Registros: **A/AAAA** (IP), **CNAME** (alias), **MX** (e-mail), **TXT**, **NS**.
- Usa cache (TTL) para performance.

## TLS (Transport Layer Security) / HTTPS

Protocolo de **criptografia** que protege a comunicação (sucessor do SSL). **HTTPS = HTTP sobre TLS**.
- Garante **confidencialidade** (criptografia), **integridade** e **autenticação** (certificados X.509).
- **Handshake TLS:** negocia cifras e chaves (troca assimétrica → chave simétrica de sessão).
- Certificados emitidos por **CAs**; cadeia de confiança. Ver [[19 - SEGURANCA/_INDEX|Segurança]].

## Exemplo prático

```bash
curl -v https://example.com     # vê handshake TLS + request/response HTTP
dig example.com                 # consulta DNS (registros A)
nslookup example.com
ping / traceroute example.com   # conectividade e rota (ICMP)
```

## Quando importa para o dev

- Depurar latência, timeouts, CORS, certificados, DNS.
- Projetar APIs ([[11 - APIs/_INDEX|REST/HTTP]]), escolher TCP vs UDP.
- Segurança em trânsito (sempre HTTPS/TLS).

## Erros comuns

- Servir dados sensíveis sem HTTPS.
- Ignorar cache/TTL de DNS ao migrar servidores.
- Confundir status HTTP (usar 200 para erro).
- Assumir que HTTP mantém estado (é stateless).

## Boas práticas

- **HTTPS em tudo**; renovar certificados (automatize com ACME/Let's Encrypt).
- Usar códigos de status HTTP corretos.
- TCP para confiabilidade; UDP quando latência > confiabilidade.
- Timeouts e retries em chamadas de rede (assuma falhas — ver [[Teorema CAP e Sistemas Distribuidos|falácias da rede]]).

## Conceitos relacionados

- [[11 - APIs/_INDEX|APIs (REST/HTTP)]]
- [[19 - SEGURANCA/_INDEX|Segurança (TLS, certificados)]]
- [[Teorema CAP e Sistemas Distribuidos]]
- [[Sistemas Operacionais - Fundamentos]]

## Perguntas importantes

### Qual a diferença entre TCP e UDP?
TCP é confiável e ordenado (conexão); UDP é rápido e sem garantias. Web/APIs usam TCP; streaming/jogos/DNS costumam usar UDP.

### O que acontece ao digitar uma URL no navegador?
DNS resolve o nome → IP; abre conexão TCP; faz handshake TLS (se HTTPS); envia request HTTP; recebe response; renderiza. (Pergunta clássica de entrevista.)

## Fontes

1. Wikipedia — Internet protocol suite — https://en.wikipedia.org/wiki/Internet_protocol_suite (consultado 2026-09-03)
2. IETF RFCs: 9110/9111 (HTTP), 1034/1035 (DNS), 8446 (TLS 1.3), 793 (TCP).
3. MDN Web Docs — HTTP — https://developer.mozilla.org/en-US/docs/Web/HTTP

## Observações

Criar notas próprias: HTTP a fundo (métodos/headers/cache), modelo OSI vs TCP/IP, handshake TLS detalhado. Status: verified.
