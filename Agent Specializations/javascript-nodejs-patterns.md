# JavaScript Specialization - Node.js Async Patterns

**Agent**: @javascript  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready Node.js code with:
- ES2022+ (async/await, optional chaining, nullish coalescing)
- Async patterns (Promise, async/await)
- Error handling (custom errors, recovery)
- Memory management
- Streams & Worker threads

---

## 🔑 Key Patterns

### Async/Await
```javascript
async function fetchData(userId) {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) throw new Error(`API error: ${response.status}`);
    return await response.json();
  } catch (error) {
    console.error('Failed:', error.message);
    throw new AppError('Fetch failed', 500);
  }
}
```

### Custom Errors
```javascript
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    Error.captureStackTrace(this, this.constructor);
  }
}
```

### Promise Patterns
```javascript
// Promise.all
const [users, posts] = await Promise.all([
  fetchUsers(),
  fetchPosts()
]);

// Promise.race
const result = await Promise.race([
  fetchServer(),
  delay(5000) // Timeout
]);
```

### Retry with Backoff
```javascript
async function retryWithBackoff(fn, maxAttempts = 3) {
  for (let i = 1; i <= maxAttempts; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxAttempts) throw error;
      const delay = 1000 * Math.pow(2, i - 1);
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
}
```

### Streams
```javascript
fs.createReadStream('large-file.txt')
  .pipe(new Transform({
    transform(chunk, encoding, callback) {
      callback(null, chunk.toString().toUpperCase());
    }
  }))
  .pipe(fs.createWriteStream('output.txt'));
```

---

## ✅ Checklist

- [ ] Use async/await, not callbacks
- [ ] Custom Error classes
- [ ] Proper error handling with try/catch
- [ ] Promise.all for parallel operations
- [ ] Retry logic with exponential backoff
- [ ] Streams for large data
- [ ] Memory efficient patterns
- [ ] No callback hell
- [ ] Tests with Jest

Tags: #javascript #nodejs #async #promises #es2022 #error-handling
