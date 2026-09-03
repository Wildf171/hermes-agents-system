# Code Training para Hermes Agents

Currículo completo para treinar agents a gerar código production-ready e educational para qualquer tipo de sistema.

---

## 📖 Módulos de Treinamento

### **Módulo 1: Arquitetura e Design Patterns**

#### 1.1 Princípios SOLID
```
S — Single Responsibility Principle
   Uma classe, uma responsabilidade
   ✅ class UserRepository { }  // só salva usuários
   ❌ class UserRepository + EmailService  // múltiplas responsabilidades

O — Open/Closed Principle
   Aberto para extensão, fechado para modificação
   ✅ interface PaymentStrategy { process() }
   ✅ class CreditCardPayment implements PaymentStrategy { }

L — Liskov Substitution Principle
   Subclasses devem substituir superclasses sem quebrar

I — Interface Segregation Principle
   Interfaces específicas, não genéricas
   ✅ interface Flyable { fly() }
   ❌ interface Animal { fly(), swim(), walk() }  // nem todo animal faz tudo

D — Dependency Inversion Principle
   Depender de abstrações, não de concretizações
   ✅ constructor(UserRepository repo) { }
   ❌ constructor() { this.repo = new UserRepository() }
```

#### 1.2 Design Patterns Essenciais
- **Singleton** — instância única (logger, config)
- **Factory** — criar objetos sem especificar classe
- **Repository** — abstração de acesso a dados
- **Decorator** — adicionar comportamento dinamicamente
- **Observer** — notificar múltiplos observers
- **Strategy** — múltiplas algoritmos intercambiáveis
- **Dependency Injection** — injetar dependências

#### 1.3 Clean Code Principles
```javascript
// ❌ BAD
function p(u) {
  if (u.a && u.a > 18) return true;
  return false;
}

// ✅ GOOD
function isAdult(user) {
  const minimumAge = 18;
  return user.age >= minimumAge;
}
```

**Regras:**
1. Nomes descritivos (variáveis, funções, classes)
2. Funções pequenas (< 20 linhas)
3. DRY — Don't Repeat Yourself
4. KISS — Keep It Simple, Stupid
5. Sem side effects desnecessários
6. Comentários explicam o "por quê", não o "quê"

#### 1.4 Arquitetura de Sistemas
```
┌─────────────────────────────────────┐
│  Presentation Layer (Frontend/API)  │
├─────────────────────────────────────┤
│  Business Logic Layer               │
├─────────────────────────────────────┤
│  Data Access Layer (Repository)     │
├─────────────────────────────────────┤
│  Database                           │
└─────────────────────────────────────┘
```

---

### **Módulo 2: Backend Development**

#### 2.1 Node.js + Express (JavaScript)

**Estrutura Padrão:**
```
/projeto
  /src
    /controllers    # Lidam com requisições HTTP
    /services       # Lógica de negócio
    /repositories   # Acesso a dados
    /middleware     # Auth, logging, validação
    /models         # Schema de dados
    /routes         # Definição de rotas
    /utils          # Funções utilitárias
  /tests
  /config
  app.js            # Inicializar app
```

**Exemplo: CRUD de Usuários**
```javascript
// middleware/auth.js
const authenticate = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'No token' });
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(403).json({ error: 'Invalid token' });
  }
};

// controllers/userController.js
class UserController {
  constructor(userService) {
    this.userService = userService; // Dependency Injection
  }

  async create(req, res) {
    try {
      const user = await this.userService.create(req.body);
      res.status(201).json(user);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  }

  async getById(req, res) {
    try {
      const user = await this.userService.getById(req.params.id);
      if (!user) return res.status(404).json({ error: 'Not found' });
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

// routes/users.js
router.post('/users', authenticate, userController.create.bind(userController));
router.get('/users/:id', authenticate, userController.getById.bind(userController));
```

#### 2.2 Java + Spring Boot

**Estrutura Padrão:**
```
com/empresa/projeto/
  controller/         # REST controllers
  service/            # Business logic
  repository/         # Data access (JPA)
  model/              # Entity classes
  dto/                # Data Transfer Objects
  config/             # Configuration
  exception/          # Custom exceptions
  Application.java    # Entry point
```

**Exemplo:**
```java
// User.java (Entity)
@Entity
@Table(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String name;
    
    private LocalDateTime createdAt;
}

// UserRepository.java
@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);
    List<User> findByNameContaining(String name);
}

// UserService.java
@Service
@Transactional
public class UserService {
    @Autowired
    private UserRepository userRepository;
    
    public User create(UserDTO dto) {
        if (userRepository.findByEmail(dto.getEmail()).isPresent()) {
            throw new IllegalArgumentException("Email already exists");
        }
        User user = new User();
        user.setEmail(dto.getEmail());
        user.setName(dto.getName());
        user.setCreatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }
    
    public User getById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new NotFoundException("User not found"));
    }
}

// UserController.java
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;
    
    @PostMapping
    public ResponseEntity<User> create(@RequestBody UserDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(userService.create(dto));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<User> getById(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getById(id));
    }
}
```

#### 2.3 API RESTful Best Practices
```
✅ GET    /api/users           # Listar (200)
✅ POST   /api/users           # Criar (201)
✅ PUT    /api/users/{id}      # Atualizar tudo (200)
✅ PATCH  /api/users/{id}      # Atualizar parcial (200)
✅ DELETE /api/users/{id}      # Deletar (204)

❌ /getUsers, /createUser, /updateUser  # Evitar verbo no path
```

---

### **Módulo 3: Frontend Development**

#### 3.1 React Best Practices

**Estrutura de Componente:**
```javascript
// components/UserCard.jsx
import PropTypes from 'prop-types';

const UserCard = ({ user, onDelete, isLoading }) => {
  const handleDelete = async () => {
    if (window.confirm(`Deletar ${user.name}?`)) {
      onDelete(user.id);
    }
  };

  return (
    <div className="user-card">
      <h3>{user.name}</h3>
      <p>{user.email}</p>
      <button 
        onClick={handleDelete}
        disabled={isLoading}
        aria-label={`Deletar usuário ${user.name}`}
      >
        {isLoading ? 'Deletando...' : 'Deletar'}
      </button>
    </div>
  );
};

UserCard.propTypes = {
  user: PropTypes.shape({
    id: PropTypes.number.required,
    name: PropTypes.string.required,
    email: PropTypes.string.required,
  }).required,
  onDelete: PropTypes.func.required,
  isLoading: PropTypes.bool,
};

UserCard.defaultProps = {
  isLoading: false,
};

export default UserCard;
```

**Hooks Essenciais:**
```javascript
// useState — state local
const [users, setUsers] = useState([]);

// useEffect — side effects
useEffect(() => {
  fetchUsers();
}, []); // [] = executar só uma vez

// useContext — evitar prop drilling
const { user } = useContext(AuthContext);

// useReducer — state complexo
const [state, dispatch] = useReducer(reducer, initialState);

// useMemo — memoizar cálculos caros
const memoizedValue = useMemo(() => expensiveCalculation(a, b), [a, b]);

// useCallback — memoizar funções
const memoizedCallback = useCallback(() => {
  doSomething();
}, []);
```

#### 3.2 State Management
```javascript
// Context API (simples)
const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  
  const login = (userData) => setUser(userData);
  const logout = () => setUser(null);
  
  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

// Usar em componente
const { user, logout } = useContext(AuthContext);
```

---

### **Módulo 4: Testing**

#### 4.1 Unit Tests (JavaScript com Jest)
```javascript
// utils/userUtils.test.js
describe('userUtils', () => {
  describe('isAdult', () => {
    it('should return true for age >= 18', () => {
      expect(isAdult({ age: 25 })).toBe(true);
    });
    
    it('should return false for age < 18', () => {
      expect(isAdult({ age: 16 })).toBe(false);
    });
  });
});
```

#### 4.2 Integration Tests
```javascript
// tests/api/users.test.js
describe('GET /api/users', () => {
  it('should return list of users', async () => {
    const res = await request(app).get('/api/users');
    
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
  });
});
```

#### 4.3 Test Coverage Target
```
✅ 80%+ line coverage (target)
✅ 100% critical paths (auth, payment)
✅ 70%+ branch coverage
```

---

### **Módulo 5: DevOps & CI/CD**

#### 5.1 Docker
```dockerfile
# Dockerfile
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY src ./src

EXPOSE 3000

CMD ["node", "src/index.js"]
```

#### 5.2 GitHub Actions
```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '20'
      - run: npm install
      - run: npm test
      - run: npm run lint
```

---

### **Módulo 6: Security**

#### 6.1 OWASP Top 10
```
1. Injection (SQL, NoSQL) — Use prepared statements
2. Broken Authentication — Use strong JWT/OAuth
3. XSS — Sanitize user input
4. CSRF — Use tokens
5. Insecure Serialization — Validate data
6. Weak Access Control — Enforce permissions
7. Using Components with Known Vulnerabilities — Update deps
8. Insufficient Logging — Log important events
9. Misconfiguration — Use security headers
10. Using Outdated Libraries — `npm audit`
```

#### 6.2 Authentication Exemplo
```javascript
// middleware/authMiddleware.js
const verifyToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Token not provided' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(403).json({ error: 'Invalid token' });
  }
};
```

---

## 🎯 Guidelines para Agents

### Quando Gerar Código:
1. **Estrutura** — respeite a arquitetura em camadas
2. **Nomes** — descritivos, sem abreviações
3. **Tratamento de Erro** — try/catch ou promises
4. **Documentação** — JSDoc ou Javadoc para funções públicas
5. **Testes** — criar testes unitários
6. **Performance** — considerar scalabilidade
7. **Security** — validar input, sanitizar output
8. **Logs** — adicionar logs em operações críticas

### Code Review Checklist:
- [ ] Segue SOLID principles?
- [ ] Tem tratamento de erro?
- [ ] Código está testado?
- [ ] Performance adequada?
- [ ] Sem vulnerabilidades óbvias?
- [ ] Segue convenções do projeto?
- [ ] Documentado?

---

## 📚 Stack Reference

### Node.js + MongoDB
```
npm create vite@latest app -- --template react
npm install express dotenv mongoose bcryptjs jsonwebtoken cors
npm install -D jest supertest nodemon
```

### Node.js + MySQL
```
npm install express mysql2 sequelize dotenv
npm install -D jest supertest nodemon
```

### Java + PostgreSQL
```
Spring Boot Starter Web
Spring Data JPA
PostgreSQL Driver
Spring Security
JUnit 5
```

---

## 🚀 Estrutura de Projeto Completo

```
projeto-fullstack/
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── models/
│   │   ├── middleware/
│   │   ├── routes/
│   │   └── app.js
│   ├── tests/
│   ├── .env
│   ├── package.json
│   └── Dockerfile
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   ├── pages/
│   │   ├── hooks/
│   │   ├── context/
│   │   ├── services/
│   │   └── App.jsx
│   ├── tests/
│   ├── package.json
│   └── .env
├── docker-compose.yml
├── .github/workflows/
└── README.md
```

---

## ✅ Checklist para Agents Produzirem Código

**Antes de cada geração:**
- [ ] Entendi o requisito?
- [ ] Identifiquei a arquitetura apropriada?
- [ ] Escolherei o design pattern certo?
- [ ] Vai incluir testes?
- [ ] Vai ter tratamento de erro?
- [ ] Há considerações de segurança?
- [ ] Performance está ok?
- [ ] Documentação vai estar clara?

**Após gerar código:**
- [ ] Testei mentalmente?
- [ ] Revisei para SOLID?
- [ ] Há edge cases descobertos?
- [ ] Performance está bom?
- [ ] Segurança validada?
- [ ] Código é legível?

---

**Data**: 2026-09-03
**Versão**: 1.0
**Target**: Hermes Agents produzindo código production-ready
