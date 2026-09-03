---
title: "Git - Fundamentos"
category: "26 - GIT E VERSIONAMENTO"
tags:
  - engenharia-software
  - git
  - versionamento
  - ferramenta
status: "verified"
created: "2026-09-03"
updated: "2026-09-03"
sources_checked: 2026-09-03
---

# Git — Fundamentos

## Resumo

**Git** é um sistema de controle de versão **distribuído (DVCS)**, livre e open source, criado por **Linus Torvalds em 2005** para o desenvolvimento do kernel Linux. Rastreia mudanças no código ao longo do tempo, permite colaboração e é hoje o padrão da indústria: segundo a Stack Overflow Developer Survey 2022, **96% dos desenvolvedores profissionais usam Git**.

## O que é?

- **Distribuído:** cada clone é um repositório completo com todo o histórico — não depende de um servidor central para trabalhar.
- **Rápido e eficiente:** projetado para o kernel Linux (dezenas de milhões de linhas). Guarda todo o histórico do Linux (1,4 milhão de commits) em ~5,5 GB.
- **Licença:** GNU GPL v2.0 (open source).

## Por que existe?

Antes do Git, o kernel Linux usava o BitKeeper (proprietário); quando o acesso gratuito foi revogado em 2005, Torvalds criou o Git com metas de **velocidade, design distribuído e integridade** para grandes bases de código com muitos colaboradores.

## Como funciona?

### Modelo de dados: snapshots, não diffs
Git armazena o projeto como uma **série de snapshots** do sistema de arquivos. A cada commit, tira uma "foto" do estado; arquivos inalterados são referenciados (não recopiados). Cada objeto é identificado por um **hash SHA** do conteúdo → integridade garantida.

### Os três estados
1. **Working directory** — arquivos de trabalho
2. **Staging area (index)** — mudanças preparadas para o próximo commit
3. **Repository (.git)** — histórico commitado

Fluxo: `modificar → git add (stage) → git commit (grava)`.

### Conceitos centrais
- **Commit** — snapshot com autor, mensagem, timestamp e ponteiro para o pai.
- **Branch** — ponteiro leve para um commit; ramificar é barato.
- **HEAD** — ponteiro para o commit/branch atual.
- **Merge / Rebase** — integrar históricos (merge preserva; rebase reescreve linearizando).
- **Remote** — repositório em outro lugar (ex.: GitHub, GitLab).

## Exemplo prático

```bash
git init                      # cria repositório
git add arquivo.py            # stage
git commit -m "mensagem"      # grava snapshot
git branch feature-x          # cria branch
git checkout feature-x        # muda para a branch (ou: git switch)
git merge feature-x           # integra na branch atual
git remote add origin <url>   # conecta remoto
git push -u origin main       # envia commits
git pull                      # busca + integra do remoto
```

## Quando utilizar

Praticamente **sempre** — qualquer projeto de código (e muitos de texto/config) se beneficia de versionamento. É pré-requisito para [[16 - CI-CD/_INDEX|CI/CD]] e colaboração.

## Quando NÃO utilizar (ou com cuidado)

- **Arquivos binários grandes** e que mudam muito (vídeos, datasets): Git incha; use **Git LFS** ou storage dedicado.
- **Segredos** (senhas, chaves): nunca commitar; use `.gitignore` e gerenciadores de segredo.

## Trade-offs

- **Merge** preserva o histórico real (mais "sujo"); **Rebase** deixa linear (mais limpo, mas reescreve história — não usar em branches compartilhadas publicadas).
- Distribuído = poderoso, porém curva de aprendizado maior que VCS centralizados (SVN).

## Erros comuns

- Commitar segredos ou `node_modules`/artefatos (faltou `.gitignore`).
- `git push --force` em branch compartilhada (sobrescreve trabalho alheio) — prefira `--force-with-lease`.
- Commits gigantes e vagos ("fix", "wip") em vez de commits pequenos e descritivos.
- Confundir `git` (a ferramenta) com `GitHub` (serviço de hospedagem).

## Boas práticas

- Commits pequenos, atômicos, com mensagens claras (imperativo: "Adiciona X").
- Adotar um workflow: **GitHub Flow** (simples) ou **Git Flow** (releases) — ver notas na categoria 26.
- `.gitignore` desde o início; nunca versionar segredos.
- Branches por feature; revisão via Pull Request.

## Conceitos relacionados

- [[Engenharia de Software]]
- [[16 - CI-CD/_INDEX|CI/CD]] (depende de Git)
- [[27 - DOCUMENTACAO/_INDEX|Documentação]]

## Perguntas importantes

### Git é o mesmo que GitHub?
Não. **Git** é a ferramenta de versionamento (roda localmente). **GitHub/GitLab/Bitbucket** são serviços que hospedam repositórios Git e agregam colaboração (PRs, issues, CI).

### Qual a diferença entre merge e rebase?
`merge` cria um commit de junção e preserva o histórico paralelo. `rebase` reescreve os commits sobre outra base, deixando histórico linear — não deve ser usado em commits já publicados/compartilhados.

### Git guarda diffs ou snapshots?
Snapshots (com deduplicação por hash). Diferente de sistemas antigos que guardavam listas de diferenças por arquivo.

## Fontes

1. Git — About — https://git-scm.com/about (consultado 2026-09-03)
2. Pro Git book (Chacon & Straub) — https://git-scm.com/book — "Getting Started" e "Git Basics"
3. Stack Overflow Developer Survey 2022 (uso de 96%) — citado em git-scm.com/about

## Observações

Detalhar em notas próprias: workflows (Git Flow, GitHub Flow, Trunk-Based), rebase interativo, resolução de conflitos, monorepo. Status: verified (fatos centrais confirmados em git-scm.com).
