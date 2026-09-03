# Backend Specialization - Database Patterns

**Agent**: @backend  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready REST APIs with:
- **Repository Pattern** for data abstraction
- **SQL** (PostgreSQL, MySQL) with pooling, migrations, transactions
- **MongoDB** with document design & aggregations
- **Redis** caching & session management
- **Connection optimization** & error handling
- **Testing** with mocked databases

---

## 📚 Knowledge Bases

- CODE_TRAINING.md (Modules 2.4-2.7)
- KNOWLEDGE_BASE.md (SQL, MongoDB aulas)

---

## 🔑 Patterns

### Repository Pattern
```javascript
class UserRepository {
  async create(userData) { }
  async findById(id) { }
  async update(id, userData) { }
  async delete(id) { }
}
```

### SQL Pooling
```javascript
const pool = new Pool({
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});
```

### MongoDB Aggregation
```javascript
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$category", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } },
  { $limit: 10 }
])
```

### Redis Caching
```javascript
const cached = await redis.get(`user:${id}`);
if (!cached) {
  const user = await db.findById(id);
  await redis.setex(`user:${id}`, 3600, JSON.stringify(user));
  return user;
}
```

---

## ✅ Checklist

- [ ] Repository layer (data abstraction)
- [ ] Service layer (business logic)
- [ ] Controller layer (HTTP handling)
- [ ] Connection pooling configured
- [ ] Migrations for schema versioning
- [ ] Indexes on frequently queried columns
- [ ] Transactions for multi-step operations
- [ ] Redis caching with TTL
- [ ] Cache invalidation on updates
- [ ] Error handling & validation
- [ ] Tests with mocked databases

---

## 📖 References

- CODE_TRAINING.md (Modules 2.4-2.7)
- KNOWLEDGE_BASE.md

Related: [[frontend-complete]] | [[java-spring-boot-patterns]] | [[AGENTS_COMPLETE]]

Tags: #backend #api #database #repository #sql #mongodb #redis #caching
