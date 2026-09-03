---
title: "DRY, KISS e YAGNI"
category: "05 - PRINCÍPIOS DE SOFTWARE"
tags:
  - engenharia-software
  - principios
  - conceito
  - clean-code
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# DRY, KISS e YAGNI

## Resumo

Três princípios fundamentais que combatem, respectivamente, **duplicação**, **complexidade desnecessária** e **antecipação especulativa**. São heurísticas de design de código — não leis absolutas — que, bem aplicadas, produzem software mais simples e manutenível.

---

## DRY — Don't Repeat Yourself

### Definição
> "Cada pedaço de conhecimento deve ter uma representação única, não ambígua e autoritativa dentro de um sistema."

Formulado por **Andy Hunt e Dave Thomas** em *The Pragmatic Programmer* (1999). Aplica-se amplamente: código, schema de banco, planos de teste, build, documentação.

### Como funciona
Quando aplicado com sucesso, **modificar um elemento não exige alterar elementos logicamente não relacionados**, e elementos relacionados mudam de forma previsível e uniforme (ficam em sincronia). Além de funções/subrotinas, apoia-se em geradores de código, build automatizado e scripting.

### Caso especial — Single Choice Principle (Bertrand Meyer)
"Sempre que um sistema deve suportar um conjunto de alternativas, um e apenas um módulo deve conhecer a lista exaustiva delas."

### Opostos e nuances
- **WET** ("Write Everything Twice" / "We Enjoy Typing") — o anti-padrão da duplicação.
- **AHA** ("Avoid Hasty Abstractions", Kent C. Dodds) — cuidado: DRY prematuro cria abstrações erradas e rígidas. **Duplicação é mais barata que a abstração errada** (Sandi Metz). Prefira duplicar até o padrão ficar claro.

---

## KISS — Keep It Simple, Stupid

### Definição
Sistemas funcionam melhor quando **mantidos simples**; evite complexidade desnecessária. Atribuído a **Kelly Johnson**, engenheiro-chefe da Lockheed Skunk Works (US Navy, ~1960).

### Como aplicar
- Prefira a solução mais simples que resolve o problema.
- Evite "esperteza" que dificulta leitura.
- Divida problemas grandes em partes simples.

---

## YAGNI — You Aren't Gonna Need It

### Definição
Princípio que surgiu do **Extreme Programming (XP)**: um programador **não deve adicionar funcionalidade até que seja realmente necessária**.

**Ron Jeffries** (cofundador do XP): *"Always implement things when you actually need them, never when you just foresee that you will need them."*

### Contexto
É a base da prática XP **"do the simplest thing that could possibly work" (DTSTTCPW)**. Depende de práticas de suporte: **refatoração contínua, testes automatizados e integração contínua**. Sem elas, pode gerar retrabalho e [[43 - ANTIPATTERNS/_INDEX|dívida técnica]].

---

## Quando utilizar

- **DRY:** quando a duplicação representa o *mesmo conhecimento* que muda junto.
- **KISS:** sempre; simplicidade é default.
- **YAGNI:** ao sentir vontade de construir "para o futuro" sem necessidade concreta.

## Quando NÃO utilizar (armadilhas)

- **DRY em excesso:** unir código que *parece* igual mas representa conhecimentos diferentes cria acoplamento indevido. Duplicação coincidental ≠ duplicação de conhecimento.
- **KISS mal entendido:** simples ≠ simplista; não sacrifique corretude/robustez.
- **YAGNI radical:** não use como desculpa para ignorar arquitetura essencial ou pontos de extensão realmente previsíveis.

## Erros comuns

- Abstrair cedo demais (viola AHA) em nome do DRY.
- Confundir DRY (conhecimento) com "nunca repetir nenhuma linha".
- Usar YAGNI sem refatoração contínua → código desorganizado.

## Boas práticas

- Regra prática: **duplique 2×, abstraia na 3ª** (rule of three).
- Combine YAGNI com testes automatizados e refatoração ([[29 - REFATORACAO/_INDEX|Refatoração]]).
- Meça simplicidade pela facilidade de ler e mudar, não por menos linhas.

## Conceitos relacionados

- [[Engenharia de Software]]
- [[32 - SOLID/_INDEX|SOLID]] — princípios de design OO
- [[31 - CLEAN CODE/_INDEX|Clean Code]]
- [[43 - ANTIPATTERNS/_INDEX|Anti-patterns]] (WET, over-engineering)

## Perguntas importantes

### DRY e YAGNI conflitam?
Podem parecer opostos, mas são complementares: YAGNI evita abstrações especulativas; DRY elimina duplicação de conhecimento *real e presente*. AHA reconcilia: não abstraia com pressa.

### KISS tem origem formal?
É atribuído a Kelly Johnson (Lockheed). Não é um princípio "acadêmico" com paper — é heurística de engenharia amplamente adotada.

## Fontes

1. Wikipedia — Don't repeat yourself — https://en.wikipedia.org/wiki/Don%27t_repeat_yourself (consultado 2026-09-03)
2. Wikipedia — You aren't gonna need it — https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it (consultado 2026-09-03)
3. Wikipedia — KISS principle — https://en.wikipedia.org/wiki/KISS_principle
4. Hunt, A. & Thomas, D. (1999). *The Pragmatic Programmer.*
5. Jeffries, R., Anderson, A., Hendrickson, C. (2001). *Extreme Programming Installed.*

## Observações

Origem de KISS citada via Wikipedia (não fetchada nesta sessão) — validar atribuição a Kelly Johnson antes de citar academicamente. Status: verified (DRY e YAGNI confirmados em fonte; KISS pendente de fetch direto).
