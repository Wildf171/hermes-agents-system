# TypeScript Specialization - Advanced Type Patterns

**Agent**: @typescript  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready TypeScript code with:
- Strict mode (strictNullChecks, noImplicitAny)
- Advanced types (Generics, Unions, Conditional)
- Utility types (Partial, Pick, Omit, Record)
- Type narrowing & guards
- Discriminated unions
- Decorators & metadata

---

## 🔑 Key Patterns

### Generic Repository
```typescript
interface Repository<T, ID> {
  findById(id: ID): Promise<T | null>;
  save(entity: T): Promise<T>;
}

class UserRepository implements Repository<User, number> {
  async findById(id: number): Promise<User | null> { }
}
```

### Constrained Generics
```typescript
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
```

### Utility Types
```typescript
type UserUpdate = Partial<User>; // All optional
type UserResponse = Pick<User, 'id' | 'name'>; // Select fields
type UserInput = Omit<User, 'id'>; // Exclude fields
```

### Discriminated Union
```typescript
type Result<T> =
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };

function handle<T>(result: Result<T>) {
  if (result.status === 'success') {
    console.log(result.data);
  } else {
    console.log(result.error);
  }
}
```

### Type Guard
```typescript
function isUser(obj: unknown): obj is User {
  return typeof obj === 'object' && 'id' in obj && 'name' in obj;
}
```

### Conditional Types
```typescript
type IsString<T> = T extends string ? true : false;
```

---

## ✅ Checklist

- [ ] Strict mode enabled
- [ ] All variables typed
- [ ] Function parameters typed
- [ ] Return types specified
- [ ] No 'any' types (if possible)
- [ ] Generic factories for reuse
- [ ] Type guards for narrowing
- [ ] Utility types for DRY

Tags: #typescript #types #generics #strict-mode #discriminated-unions
