# Aula 07 - MongoDB em Produção (MDB 2B)

## 📋 Resumo
Deployment, escalabilidade, segurança e best practices para MongoDB em ambiente de produção.

## 🎯 Objetivos
- Preparar MongoDB para produção
- Implementar segurança
- Escalar horizontalmente
- Monitorar e manter

## 📚 Conteúdo Principal

### Replication Set

#### O que é?
- Grupo de processos mongod que replicam dados
- Garante alta disponibilidade
- Divide em Primary + Secondaries

#### Configurar Replication
```javascript
// Inicializar ReplicaSet
rs.initiate({
  _id: "myapp",
  members: [
    { _id: 0, host: "server1:27017" },
    { _id: 1, host: "server2:27017" },
    { _id: 2, host: "server3:27017" }
  ]
})

// Ver status
rs.status()
```

### Sharding - Distribuição Horizontal

#### Conceito
- Divide dados entre múltiplos servidores
- Cada shard tem parte dos dados (baseado em shard key)
- Ótimo para BigData

#### Arquitetura
```
┌─────────────┐
│   mongos    │  (Query Router)
└─────────────┘
      │
   ┌──┼──┐
   ▼  ▼  ▼
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Shard 1    │  │  Shard 2    │  │  Shard 3    │
│  (Dados A)  │  │  (Dados B)  │  │  (Dados C)  │
└─────────────┘  └─────────────┘  └─────────────┘
```

#### Escolher Shard Key
```javascript
// Criar índice shard key
db.users.createIndex({ userId: 1 })

// Enabler sharding
sh.shardCollection("myapp.users", { userId: 1 })
```

### Segurança

#### Autenticação
```javascript
// Criar usuário admin
db.createUser({
  user: "admin",
  pwd: "senhaForte123!",
  roles: ["root"]
})

// Criar usuário da aplicação
db.createUser({
  user: "app_user",
  pwd: "appPassword",
  roles: [
    { role: "readWrite", db: "myapp" }
  ]
})
```

#### Conexão com Auth
```javascript
// String de conexão
mongodb://app_user:appPassword@localhost:27017/myapp
```

#### Encryption at Rest
```javascript
// MongoDB Enterprise: ativar encriptação
mongod --encryptionCipherMode=aes256-cbc --encryptionKeyFile=/path/to/keyfile
```

### Backup e Restore

#### Backup com mongodump
```bash
mongodump --uri "mongodb://localhost:27017/myapp" --out ./backup
```

#### Restore com mongorestore
```bash
mongorestore --uri "mongodb://localhost:27017" ./backup
```

#### Backup em Cloud
- MongoDB Atlas tem backups automáticos
- Amazon S3 ou Google Cloud Storage

### Monitoramento

#### Métricas Importantes
- **Operações por segundo** — throughput
- **Latência** — tempo de resposta
- **Tamanho do banco** — crescimento
- **Índices** — performance de queries
- **Replicação lag** — diferença primary/secondary

#### Ferramentas
- **mongostat** — status em tempo real
- **mongotop** — tempo por operação
- **MongoDB Compass** — GUI para monitoramento
- **Prometheus + Grafana** — dashboards

#### Executar mongostat
```bash
mongostat --uri "mongodb://localhost:27017"
```

### Backup Strategy (3-2-1 Rule)
- **3 cópias** dos dados
- **2 tipos de mídia** diferentes
- **1 off-site** (outro local)

### Performance Tuning

1. **Índices** — criar onde necessário
2. **Aggregation Pipeline** — $match primeiro
3. **Read Preference** — usar secondaries para leitura
4. **Connection Pooling** — reutilizar conexões
5. **Batch Operations** — inserir múltiplos por vez

## 🔑 Checklist Produção
- [ ] ReplicaSet configurado (3+ nós)
- [ ] Autenticação ativada
- [ ] Backup automático diário
- [ ] Monitoramento ativo
- [ ] Índices criados
- [ ] Encryption at rest (se Enterprise)
- [ ] Firewall configurado
- [ ] Documentação atualizada

## 📝 Tarefas Práticas
- [ ] Configurar ReplicaSet local (3 instâncias)
- [ ] Criar usuário com permissões limitadas
- [ ] Fazer backup com mongodump
- [ ] Restaurar backup
- [ ] Executar mongostat e ver métricas

## Tags
#mongodb #producao #scaling #seguranca #backup
