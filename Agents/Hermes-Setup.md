# Hermes Agent Setup Guide

## 9 Agents Disponíveis

### Como Usar

#### Backend Agent
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile backend"
```

#### Frontend Agent
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile frontend"
```

#### Especialistas
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile java"      # Java específico
wsl -d Ubuntu-24.04 -- bash -c "hermes profile django"    # Django ORM
wsl -d Ubuntu-24.04 -- bash -c "hermes profile postgresql" # SQL queries
wsl -d Ubuntu-24.04 -- bash -c "hermes profile typescript" # TypeScript types
```

## Hermes Memory & Skills

Ver memory do agent:
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile backend memory show"
```

Ver skills que aprendeu:
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile backend skills list"
```

---

**Próximos passos:** Use [[Tasks/In-Progress]] pra criar suas primeiras tarefas

---

## 🇧🇷 Tradução em Português

# Guia de Configuração do Agente Hermes

## 9 Agentes Disponíveis

### Como Usar

#### Agente Backend
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile backend"
```

#### Agente Frontend
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile frontend"
```

#### Especialistas
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile java"      # Java específico
wsl -d Ubuntu-24.04 -- bash -c "hermes profile django"    # Django ORM
wsl -d Ubuntu-24.04 -- bash -c "hermes profile postgresql" # Consultas SQL
wsl -d Ubuntu-24.04 -- bash -c "hermes profile typescript" # Tipos TypeScript
```

## Memória e Habilidades do Hermes

Ver memória do agente:
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile backend memory show"
```

Ver habilidades que ele aprendeu:
```bash
wsl -d Ubuntu-24.04 -- bash -c "hermes profile backend skills list"
```

---

**Próximos passos:** Use [[Tasks/In-Progress]] para criar suas primeiras tarefas
