# Aula 01 - Introdução ao MongoDB

## 📋 Resumo
Conceitos fundamentais do MongoDB, diferenças entre bancos de dados relacionais e NoSQL, instalação e configuração inicial.

## 🎯 Objetivos
- Entender o que é MongoDB
- Diferenciar SQL vs NoSQL
- Instalar e configurar MongoDB
- Conectar ao banco de dados

## 📚 Conteúdo Principal

### O que é MongoDB?
- Banco de dados NoSQL orientado a **documentos**
- Armazena dados em formato **JSON/BSON**
- Escalável, flexível, open-source
- Ideal para dados não estruturados ou semi-estruturados

### SQL vs NoSQL

| Aspecto | SQL | NoSQL |
|---|---|---|
| Estrutura | Tabelas rígidas | Documentos flexíveis |
| Esquema | Fixo | Dinâmico |
| ACID | Sim | Eventualmente consistente |
| Escalabilidade | Vertical | Horizontal |
| Exemplo | MySQL, PostgreSQL | MongoDB, Redis |

### Instalação
1. Baixar MongoDB Community Server
2. Executar instalador
3. Configurar serviço do Windows
4. Verificar: `mongod --version`

### Conectando ao MongoDB
```bash
mongo
# ou
mongosh
```

### Estrutura de Dados
- **Database** — contém coleções
- **Collection** — contém documentos (tabela em SQL)
- **Document** — registro individual (linha em SQL)

### Primeiro Documento
```json
{
  "_id": ObjectId("..."),
  "nome": "William",
  "idade": 25,
  "skills": ["JavaScript", "Java", "MongoDB"]
}
```

## 🔑 Conceitos-Chave
- NoSQL oferece flexibilidade que SQL não tem
- Documentos BSON (Binary JSON) são mais rápidos que JSON puro
- MongoDB é **schema-less** mas pode impor validação

## 📝 Tarefas Práticas
- [ ] Instalar MongoDB localmente
- [ ] Conectar com mongosh
- [ ] Criar um database de teste
- [ ] Inserir um documento simples

## 🔗 Links Úteis
- [MongoDB Official](https://www.mongodb.com/)
- [MongoDB Community Download](https://www.mongodb.com/try/download/community)

## Tags
#mongodb #nosql #database #introducao
