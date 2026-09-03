# NoSQL Specialization - MongoDB Advanced

**Agent**: @nosql  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready MongoDB code with:
- Document design patterns
- Aggregation framework (complex pipelines)
- Sharding strategies
- Replication sets
- Multi-document transactions
- Change streams for real-time
- Index optimization

---

## 🔑 Key Patterns

### Document Design
```javascript
// Embedded (one-to-few)
{
  _id: ObjectId(),
  name: "John",
  addresses: [
    { type: "home", street: "123 Main St" }
  ]
}

// Reference (one-to-many)
// users collection
{ _id: ObjectId(), name: "John" }

// posts collection
{ _id: ObjectId(), author_id: ObjectId(), title: "Post" }
```

### Aggregation Pipeline
```javascript
db.orders.aggregate([
  { $match: { status: "completed" } },
  { $group: { _id: "$category", total: { $sum: "$amount" } } },
  { $sort: { total: -1 } },
  { $limit: 10 }
])
```

### Sharding
```javascript
sh.enableSharding("db_name");
db.adminCommand({
  shardCollection: "db_name.collection",
  key: { user_id: 1 }
});
```

### Transactions
```javascript
const session = db.getMongo().startSession();
session.startTransaction();
try {
  db.accounts.updateOne({ _id: "A" }, { $inc: { balance: -100 } }, { session });
  db.accounts.updateOne({ _id: "B" }, { $inc: { balance: 100 } }, { session });
  session.commitTransaction();
} catch (error) {
  session.abortTransaction();
}
```

### Change Streams
```javascript
db.orders.watch([
  { $match: { operationType: "insert", "fullDocument.status": "urgent" } }
]).on("change", (change) => {
  console.log("Order changed:", change.fullDocument);
});
```

### Indexes
```javascript
db.users.createIndex({ email: 1 }, { unique: true });
db.orders.createIndex({ user_id: 1, created_at: -1 });
db.posts.createIndex({ title: "text", content: "text" });
db.sessions.createIndex({ created_at: 1 }, { expireAfterSeconds: 86400 });
```

---

## ✅ Checklist

- [ ] Document design (embedded vs reference)
- [ ] Aggregation pipelines for analytics
- [ ] Sharding for horizontal scaling
- [ ] Replica sets for HA
- [ ] Transactions for ACID
- [ ] Indexes on query fields
- [ ] TTL indexes for auto-cleanup
- [ ] Change streams for real-time
- [ ] Backup/recovery strategy

Tags: #mongodb #nosql #aggregation #sharding #replication #database
