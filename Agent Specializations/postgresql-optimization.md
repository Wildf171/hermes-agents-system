# PostgreSQL Specialization - Query Optimization

**Agent**: @postgresql  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready PostgreSQL code with:
- Query optimization (EXPLAIN ANALYZE)
- Index strategies (B-tree, GIN, GiST, BRIN)
- Window functions for analytics
- CTEs (Common Table Expressions)
- Partitioning for large tables
- VACUUM & ANALYZE maintenance

---

## 🔑 Key Patterns

### EXPLAIN ANALYZE
```sql
EXPLAIN ANALYZE
SELECT * FROM users WHERE created_at > '2026-01-01';
-- Check for sequential scan vs index scan
```

### Indexes
```sql
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_composite ON orders(user_id, created_at DESC);
CREATE INDEX idx_tags_array ON posts USING GIN(tags);
CREATE INDEX idx_active_users ON users(id) WHERE status = 'active';
```

### Window Functions
```sql
SELECT 
  user_id,
  amount,
  SUM(amount) OVER (PARTITION BY user_id ORDER BY created_at) as running_total
FROM orders;
```

### CTEs
```sql
WITH recent_orders AS (
  SELECT * FROM orders
  WHERE created_at > NOW() - INTERVAL '30 days'
)
SELECT * FROM recent_orders;
```

### Query Optimization
```sql
-- Avoid N+1
SELECT u.*, o.* 
FROM users u
JOIN orders o ON u.id = o.user_id;

-- Vacuum & Analyze
VACUUM ANALYZE users;
```

---

## ✅ Checklist

- [ ] Use EXPLAIN ANALYZE
- [ ] Index on WHERE/JOIN columns
- [ ] Composite indexes for complex queries
- [ ] Partial indexes for subsets
- [ ] Window functions for analytics
- [ ] CTEs for readability
- [ ] Regular VACUUM/ANALYZE
- [ ] Monitor cache hit ratio
- [ ] Check for sequential scans

Tags: #postgresql #sql #optimization #indexes #performance #database
