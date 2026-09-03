# Frontend Specialization - Complete Stack

**Agent**: @frontend  
**Status**: ✅ Production-ready  
**Updated**: 2026-09-03  

---

## 🎯 Expertise

Generate production-ready frontend components combining:
- **React 18+** with hooks and state management
- **HTML5** semantic markup with accessibility
- **CSS3** (vanilla, SCSS, Tailwind, Bootstrap)
- **Bootstrap 5** for rapid UI development
- **Accessibility** (WCAG 2.1 AA)
- **Testing** (Jest + React Testing Library)

---

## 📚 Knowledge Bases

1. **CODE_TRAINING.md** (Modules 3.3-3.6)
   - 3.3: HTML Semântico & ARIA
   - 3.4: CSS Responsivo & Tailwind
   - 3.5: Bootstrap 5 Integration
   - 3.6: CSS Vanilla (SCSS)

2. **Accessibility**: WCAG 2.1 AA guidelines

---

## 🔑 Trigger Keywords

**React**:
- Component, JSX, hooks, useState, useEffect
- Custom hook, validation, feedback

**HTML/CSS**:
- HTML form, semantic, accessible
- Layout, responsive, mobile-first
- CSS, styling, dark mode, theme

**Bootstrap**:
- Navbar, card, alert
- Grid, row, column, responsive
- Button, form control, spacing

**Accessibility**:
- WCAG, aria, semantic HTML
- Screen reader, keyboard nav

---

## 💡 Key Patterns

### HTML Semântico + ARIA
```html
<form>
  <label htmlFor="email">Email:</label>
  <input 
    id="email"
    aria-required="true"
    aria-describedby="email-help"
  />
  <small id="email-help">Use seu email válido</small>
</form>
```

### Bootstrap Navbar
```jsx
<nav className="navbar navbar-expand-lg navbar-dark bg-dark">
  <div className="container">
    <a className="navbar-brand" href="/">Logo</a>
    <div className="collapse navbar-collapse">
      <ul className="navbar-nav ms-auto">
        <li className="nav-item">
          <a className="nav-link" href="/">Home</a>
        </li>
      </ul>
    </div>
  </div>
</nav>
```

### Tailwind Classes
```jsx
<div className="flex justify-center items-center bg-gradient-to-r from-blue-500 to-purple-600 p-4 rounded-lg shadow-lg">
  Content
</div>
```

### SCSS with Mixins
```scss
@mixin flex-center {
  display: flex;
  justify-content: center;
  align-items: center;
}

.button {
  @include flex-center;
  padding: 1rem;
  
  @media (max-width: 600px) {
    padding: 0.5rem;
  }
}
```

---

## ✅ Generation Checklist

When generating components, ensure:

### HTML & Semantic
- [ ] Use semantic tags (<header>, <nav>, <main>, <footer>)
- [ ] Proper heading hierarchy
- [ ] Label associations (htmlFor)
- [ ] Form inputs have name attributes

### Accessibility (WCAG 2.1 AA)
- [ ] aria-required for required fields
- [ ] aria-describedby linking errors
- [ ] role="alert" for messages
- [ ] aria-busy for loading
- [ ] Focus states visible
- [ ] Keyboard navigation works

### React
- [ ] Functional components with hooks
- [ ] PropTypes validation
- [ ] Custom hooks for logic
- [ ] Controlled inputs
- [ ] useCallback memoization
- [ ] useMemo for expensive calculations

### Styling
- [ ] Mobile-first approach
- [ ] Consistent spacing
- [ ] Color palette as CSS variables
- [ ] Dark mode support
- [ ] No hardcoded colors

### Testing
- [ ] Render tests
- [ ] User interaction tests
- [ ] Error states
- [ ] Loading states
- [ ] Accessibility tests
- [ ] Snapshot tests (sparingly)

---

## 🎨 CSS Strategies

### Strategy 1: Bootstrap + SCSS
Use Bootstrap for layout/components, override with SCSS.

### Strategy 2: Tailwind
Utility-first approach with responsive prefixes.

### Strategy 3: CSS Modules
Scoped styles per component.

### Strategy 4: Styled Components
CSS-in-JS approach.

---

## 📱 Responsive Breakpoints

- `sm`: 640px
- `md`: 768px
- `lg`: 1024px
- `xl`: 1280px
- `2xl`: 1536px

---

## 🧪 Testing Example

```javascript
import { render, screen, fireEvent } from '@testing-library/react';
import UserForm from './UserForm';

describe('UserForm', () => {
  it('should render form with all fields', () => {
    render(<UserForm onSuccess={() => {}} />);
    expect(screen.getByLabelText(/name/i)).toBeInTheDocument();
  });

  it('should validate email', async () => {
    render(<UserForm onSuccess={() => {}} />);
    const submitButton = screen.getByRole('button');
    fireEvent.click(submitButton);
    expect(screen.getByText(/email inválido/i)).toBeInTheDocument();
  });
});
```

---

## 🚀 Quick Start

1. Create component with semantic HTML
2. Add Bootstrap or Tailwind classes
3. Implement React hooks for state
4. Add WCAG accessibility attributes
5. Write tests with React Testing Library
6. Verify with Lighthouse/axe

---

## 📖 References

- CODE_TRAINING.md (Modules 3.3-3.6)
- Bootstrap 5: https://getbootstrap.com/
- Tailwind CSS: https://tailwindcss.com/
- WCAG 2.1: https://www.w3.org/WAI/WCAG21/quickref/

---

**Created**: 2026-09-03  
**Status**: ✅ Ready for Production

Related: [[backend-database-patterns]] | [[CODE_TRAINING]] | [[AGENTS_COMPLETE]]

Tags: #frontend #react #html #css #bootstrap #tailwind #accessibility #wcag
