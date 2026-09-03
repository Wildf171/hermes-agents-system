---
type: conceito
status: ready
created: 2026-09-03
updated: 2026-09-03
tags: [conceito, react, frontend, ready]
related: []
---

# React — Fundamentals

React é uma biblioteca JavaScript para construir **interfaces de usuário interativas** com componentes reutilizáveis.

---

## Por Que React?

✅ **Component-based** — Reutilizar componentes  
✅ **Declarativo** — Descrever UI, React cuida de atualizar  
✅ **Virtual DOM** — Atualizações eficientes  
✅ **Comunidade enorme** — Muitas bibliotecas e recursos  
✅ **Usado em produção** — Facebook, Netflix, Airbnb, etc.  

---

## Conceitos Chave

### 1. Components (Functional)
```jsx
function Welcome({ name }) {
    return <h1>Hello, {name}!</h1>;
}

// Uso
<Welcome name="John" />
```

---

### 2. JSX
```jsx
// JSX — mistura HTML com JavaScript
const element = <h1>Hello, World!</h1>;

// Se compila para:
const element = React.createElement('h1', null, 'Hello, World!');
```

---

### 3. useState Hook (State)
```jsx
import { useState } from 'react';

function Counter() {
    const [count, setCount] = useState(0);

    return (
        <div>
            <p>Você clicou {count} vezes</p>
            <button onClick={() => setCount(count + 1)}>
                Clique aqui
            </button>
        </div>
    );
}
```

---

### 4. useEffect Hook (Side Effects)
```jsx
import { useEffect, useState } from 'react';

function UserProfile({ userId }) {
    const [user, setUser] = useState(null);

    useEffect(() => {
        // Fetch quando userId muda
        fetch(`/api/users/${userId}`)
            .then(res => res.json())
            .then(data => setUser(data));
    }, [userId]);  // Dependency array

    return user ? <h1>{user.name}</h1> : <p>Loading...</p>;
}
```

---

### 5. Props (Dados Pai → Filho)
```jsx
// Pai
function App() {
    return <Card title="My Card" content="Hello" />;
}

// Filho recebe props
function Card({ title, content }) {
    return (
        <div>
            <h2>{title}</h2>
            <p>{content}</p>
        </div>
    );
}
```

---

## Estrutura Típica

```
src/
├── components/
│   ├── Header.jsx
│   ├── Navbar.jsx
│   └── Card.jsx
├── pages/
│   ├── Home.jsx
│   ├── About.jsx
│   └── Contact.jsx
├── hooks/
│   ├── useAuth.js
│   └── useFetch.js
├── services/
│   └── api.js
├── App.jsx
└── index.js
```

---

## Armadilhas Comuns

⚠️ **Modificar State Diretamente**
```jsx
// ❌ Ruim
count = count + 1;  // Não vai re-render!

// ✅ Bom
setCount(count + 1);  // Re-render!
```

⚠️ **Esquecer Dependency Array**
```jsx
// ❌ Ruim — roda toda vez!
useEffect(() => {
    fetchData();
});

// ✅ Bom — roda uma vez
useEffect(() => {
    fetchData();
}, []);
```

---

## Performance Tips

### 1. useMemo — Memoize valores
```jsx
const expensiveValue = useMemo(() => {
    return complexCalculation(data);
}, [data]);
```

### 2. useCallback — Memoize funções
```jsx
const handleClick = useCallback(() => {
    // fazer algo
}, []);
```

### 3. React.memo — Memoize componentes
```jsx
export default React.memo(MyComponent);
```

---

## Próximas Leituras

- [[08 - FRONTEND/React - Hooks]] — Mais sobre Hooks
- [[08 - FRONTEND/React - State Management]] — Redux, Zustand, etc

---

**Status**: ready  
**Usada em**: Sistema André, neo-clinica
