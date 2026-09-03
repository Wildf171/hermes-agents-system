# OpenClaw + Obsidian - Practical Workflows & Examples

Exemplos concretos de como usar agents pra rodar seus projetos.

---

## 📋 Exemplos de Tarefas Reais

### **Exemplo 1: Implementar API Endpoint**

**File:** `Tasks/In-Progress.md`

```markdown
## task_backend_001: Implement GET /patients Endpoint
- Project: [[Instituto-Seroto]]
- Assigned to: @openclaw (Backend Agent)
- Created: 2024-01-20
- Deadline: 2024-01-25
- Priority: HIGH
- Status: READY
- Time Estimate: 4h

### Description
Implement REST endpoint to list all patients with pagination and filtering.

### Requirements
- [ ] GET /v1/patients endpoint
- [ ] Pagination (limit, offset)
- [ ] Filtering (name, email, created_date)
- [ ] Sorting options
- [ ] Request validation with Pydantic
- [ ] Response formatting
- [ ] Error handling (400, 401, 500)
- [ ] Unit tests (min 80% coverage)
- [ ] Integration tests
- [ ] API documentation (Swagger)

### Technical Details
```python
# Expected response structure
{
    "total": 1234,
    "limit": 20,
    "offset": 0,
    "data": [
        {
            "id": "uuid",
            "name": "John Doe",
            "email": "john@example.com",
            "phone": "+55 61 98181-0571",
            "clinic_id": "uuid",
            "created_at": "2024-01-15T10:30:00Z"
        }
    ]
}
```

### Success Criteria
- ✓ Endpoint works as expected
- ✓ All tests pass
- ✓ Code follows SOLID principles
- ✓ PR reviewed and approved
- ✓ Merged to main branch

### Agent Instructions
1. Read endpoint spec in [[Instituto-Seroto]]
2. Create FastAPI endpoint in src/api/routes/patients.py
3. Add Pydantic models for request/response
4. Write comprehensive unit + integration tests
5. Create git branch, commit, push
6. Create PR with automated testing
7. Update [[Instituto-Seroto]] with link
8. Mark task DONE when PR merged

### Related Tasks
- [[#task_backend_000]] (prerequisite: database schema - DONE ✓)

---

**Progress Log**
- 2024-01-20 10:15 Agent started task
- 2024-01-20 11:30 Endpoint implementation 50%
- ...

---

## task_backend_002: Add Request Validation
- Assigned to: @openclaw
- Prerequisite: [[#task_backend_001]]
- Status: BLOCKED (waiting for task_001)

[More task details...]
```

---

### **Exemplo 2: Database Optimization**

**File:** `Tasks/In-Progress.md`

```markdown
## task_db_001: Optimize Patient Queries Performance

- Project: [[Instituto-Seroto]]
- Assigned to: @openclaw (PostgreSQL Agent)
- Created: 2024-01-20
- Deadline: 2024-01-23
- Priority: CRITICAL
- Status: READY
- Time Estimate: 3h

### Problem Statement
Query `SELECT * FROM patients WHERE clinic_id = $1 ORDER BY created_at DESC` 
is taking 2+ seconds for large clinics.

Database has 500k patient records. Query is running 10k times/day.

### Analysis Needed
1. Run EXPLAIN ANALYZE on slow query
2. Identify bottlenecks
3. Check current indexes
4. Propose solutions

### Expected Solutions
- Add composite index: clinic_id + created_at
- Maybe partition table by clinic_id
- Consider caching strategy

### Deliverables
1. EXPLAIN ANALYZE output before/after
2. New index creation SQL
3. Benchmark results (target: <100ms)
4. Applied to database
5. Documentation update

### Agent Instructions
1. Connect to PostgreSQL database
2. Run EXPLAIN ANALYZE on slow query
3. Identify missing indexes
4. Create indexes
5. Benchmark improvement
6. Document in [[Knowledge/Performance-Tips]]
7. Update task status DONE

### Success Criteria
- ✓ Query time reduced to <100ms
- ✓ Index sizes documented
- ✓ Write performance impact assessed
- ✓ Backup created before changes

---

**Technical Notes**
Database: postgresql://localhost/clinica
User: admin (configured in ~/.openclaw/config.yaml)

Current indexes:
```
- patients_pkey (id)
- patients_email_idx (email)
```
```

---

### **Exemplo 3: Frontend Component Development**

**File:** `Tasks/In-Progress.md`

```markdown
## task_frontend_001: Create PatientList Component

- Project: [[Instituto-Seroto]]
- Assigned to: @openclaw (Frontend Agent)
- Created: 2024-01-20
- Deadline: 2024-01-28
- Priority: HIGH
- Status: READY
- Time Estimate: 8h

### Specifications
Create reusable React component to display list of patients.

### Requirements
- [ ] Display patients in table format
- [ ] Pagination support (20 items per page)
- [ ] Sortable columns (name, email, created_at)
- [ ] Filterable by: name, email, clinic
- [ ] Row selection checkbox
- [ ] Bulk actions (delete, update)
- [ ] Type-safe with TypeScript (strict mode)
- [ ] Responsive design (mobile-friendly)
- [ ] Accessibility (WCAG 2.1 AA)
- [ ] Unit tests (Jest) - 80%+ coverage
- [ ] Storybook stories
- [ ] Error handling + loading states

### Design
Use Tailwind CSS, follow design system from [[Knowledge/Design-System]]

UI Mockup:
```
┌─────────────────────────────────────┐
│ Patients List                   [+] │
├─────────────────────────────────────┤
│ ☑ Name      Email      Created   ... │
├─────────────────────────────────────┤
│ ☑ John Doe  john@...   2024-01-15   │
│ ☐ Jane Smith jane@...  2024-01-14   │
├─────────────────────────────────────┤
│ < 1 of 50 >         [Bulk Delete]   │
└─────────────────────────────────────┘
```

### Data Structure
```typescript
interface Patient {
  id: string;
  name: string;
  email: string;
  phone: string;
  clinicId: string;
  createdAt: string;
}

interface PatientListProps {
  patients: Patient[];
  isLoading: boolean;
  onSelect?: (id: string[]) => void;
  onDelete?: (id: string[]) => void;
}
```

### Deliverables
1. src/components/PatientList/PatientList.tsx
2. src/components/PatientList/PatientList.test.tsx
3. src/components/PatientList/PatientList.stories.tsx
4. src/components/PatientList/types.ts
5. src/components/PatientList/index.ts

### Agent Instructions
1. Create component structure
2. Implement table with Tailwind
3. Add pagination logic
4. Add filtering + sorting
5. Type with TypeScript (strict)
6. Write tests (80%+ coverage)
7. Create Storybook stories
8. Validate accessibility
9. Create PR
10. Mark task DONE when merged

### Success Criteria
- ✓ Component works as spec
- ✓ All tests pass
- ✓ 80%+ test coverage
- ✓ TypeScript strict compliance
- ✓ Accessibility WCAG AA
- ✓ Mobile responsive
- ✓ PR approved and merged

### Related
- Dependency: [[#task_backend_001]] API endpoint (READY ✓)
- Related: [[#task_frontend_002]] PatientForm component
```

---

## 🔄 Multi-Agent Coordination Workflow

### **Scenario: Implement Patient Management Feature (Full-Stack)**

```
TIMELINE: Jan 20 - Feb 3 (2 weeks)

Day 1 (Jan 20): Design Phase
├─ 09:00 Backend Agent
│   ├─ Read requirements
│   ├─ Design API endpoints
│   ├─ Design database schema
│   └─ Create tasks: backend_001-005
│
├─ 10:00 Frontend Agent
│   ├─ Read requirements
│   ├─ Design components
│   ├─ Design state management
│   └─ Create tasks: frontend_001-005
│
└─ 11:00 You
    └─ Review designs, approve, start tasks

Day 2-3 (Jan 21-22): Backend Implementation
├─ Backend Agent: task_backend_001
│   └─ Database schema + migrations (DONE)
│
├─ Backend Agent: task_backend_002-003
│   └─ API endpoints implementation (IN PROGRESS)
│
└─ PostgreSQL Agent (parallel)
    └─ Optimize queries, add indexes (READY)

Day 4-5 (Jan 23-24): Frontend Implementation
├─ Frontend Agent: task_frontend_001
│   └─ PatientList component (IN PROGRESS)
│
├─ Frontend Agent: task_frontend_002-003
│   └─ PatientForm, PatientDetail (BACKLOG)
│
└─ TypeScript Agent (as needed)
    └─ Type-safe integration (READY)

Day 6-7 (Jan 25-26): Integration
├─ All agents coordinating
├─ Backend → Frontend API integration
├─ Testing (unit, integration, E2E)
└─ Bug fixes

Day 8-9 (Jan 27-28): Polish & Deploy
├─ Code review
├─ Performance optimization
├─ Deployment
└─ Monitoring

RESULT: Complete feature shipped in 2 weeks with multiple agents
```

---

## 📊 Workflow Templates

### **Template 1: Bug Fix**

```markdown
## task_bug_001: [BUG] Patient list crashes on search

- Project: [[Instituto-Seroto]]
- Assigned to: @openclaw
- Priority: CRITICAL
- Status: READY

### Bug Report
When searching patients with special characters (ç, ã, etc), 
list crashes with 500 error.

### Steps to Reproduce
1. Open patient list
2. Search for "João"
3. Crash occurs

### Expected Behavior
Should filter patients correctly regardless of special chars.

### Agent Instructions
1. Reproduce bug in dev environment
2. Debug (check backend logs, API response)
3. Identify root cause
4. Fix in backend (or frontend, or both)
5. Add test case to prevent regression
6. Verify fix works
7. Create PR
8. Mark DONE when merged
```

---

### **Template 2: Performance Optimization**

```markdown
## task_perf_001: Optimize Patient List Load Time

- Project: [[Instituto-Seroto]]
- Assigned to: @openclaw
- Priority: HIGH
- Status: READY

### Current State
- List load time: 3-5 seconds
- API response: 2s
- Frontend rendering: 1.5s
- Network: 0.5s

### Target
- List load time: <1 second
- User satisfaction: High

### Areas to Investigate
1. Backend: Query optimization, add caching (Redis)
2. Frontend: Component optimization, lazy loading
3. Network: Enable compression, CDN

### Agent Instructions
1. Profile current implementation
2. Identify bottlenecks
3. Implement optimizations:
   - Backend: add Redis cache
   - Frontend: React.memo, lazy load
4. Benchmark improvements
5. Document results
6. Merge to main
```

---

### **Template 3: Feature Development**

```markdown
## task_feature_001: Patient Medical History

- Project: [[Instituto-Seroto]]
- Assigned to: @openclaw
- Priority: MEDIUM
- Status: READY
- Estimate: 3 days

### User Story
As a doctor, I want to see patient's medical history
so that I can make informed treatment decisions.

### Acceptance Criteria
- [ ] Display past appointments
- [ ] Show prescriptions history
- [ ] Display lab results
- [ ] Timeline view
- [ ] Searchable by date
- [ ] Exportable as PDF

### Technical Tasks
- [ ] Database migration (add history tables)
- [ ] API endpoint: GET /patients/:id/history
- [ ] Frontend component: MedicalHistory
- [ ] PDF export functionality
- [ ] Tests (unit + integration)

### Agent Instructions
1. Create subtasks for each technical item
2. Execute in order of dependencies
3. Update progress daily
4. Link PRs to main task
5. Mark DONE when fully implemented and tested
```

---

## 🚀 Running Your First Task (Step-by-Step)

### **Complete Example: Implement API Endpoint**

**Step 1: Create Task in Obsidian**

File: `Tasks/In-Progress.md`

```markdown
## task_001: Implement GET /patients Endpoint
- Assigned to: @openclaw
- Deadline: 2024-01-25
- Status: READY
- Project: [[Instituto-Seroto]]

### Requirements
- Endpoint: GET /v1/patients
- Pagination support
- Filtering by name/email
- Response validation
- Unit tests
```

**Step 2: Agent Detects It**

```
[Agent Loop - Every 5 minutes]
1. Agent reads Tasks/In-Progress.md
2. Finds: status = READY, assigned = @openclaw
3. Loads full task details
4. Creates execution plan
```

**Step 3: Agent Executes**

```
Agent runs:
1. Clone repository
2. Create feature branch: feature/get-patients-endpoint
3. Create FastAPI endpoint
4. Add Pydantic models
5. Write tests
6. Run tests locally
7. Commit code
8. Push to GitHub
9. Create PR

Agent updates: Tasks/In-Progress.md
- Status: IN_PROGRESS
- Progress: 50% (after 1h)
- Progress: 100% (after 2h)
```

**Step 4: Agent Reports Progress**

WhatsApp (to you):
```
Task: GET /patients endpoint
Progress: ✓ COMPLETE
Time: 2h 15m
PR: github.com/.../pull/42

Ready for review!
```

**Step 5: You Review & Approve**

```
1. You review PR on GitHub
2. Approve changes
3. Merge to main
4. Agent detects merge
5. Agent updates: status = DONE
6. Moves to Tasks/Done.md
```

**Step 6: Follow-up Task Triggers**

Agent detects next prerequisite task:
```
task_002: Add Request Validation
- Now READY (depended on task_001 = DONE ✓)
- Agent automatically starts

Obsidian updates:
- task_002 status → READY
```

---

## 💡 Pro Tips

### **Tip 1: Break Tasks into Subtasks**

❌ Bad:
```
task_001: Implement patient management
```

✅ Good:
```
task_001: Database schema
task_002: API endpoints
task_003: Frontend components
task_004: Integration testing
task_005: Deployment
```

---

### **Tip 2: Clear Acceptance Criteria**

❌ Vague:
```
Implement patient features
```

✅ Clear:
```
- [ ] GET /patients with pagination
- [ ] POST /patients with validation
- [ ] PATCH /patients/:id
- [ ] DELETE /patients/:id
- [ ] 80%+ test coverage
- [ ] API documentation
```

---

### **Tip 3: Link Related Tasks**

```markdown
## Dependencies
- Prerequisite: [[#task_001]] Database Design (DONE ✓)
- Blocks: [[#task_003]] Frontend Components

## Related
- Task: [[#task_002]] API Validation
- Task: [[#task_004]] Testing
```

---

### **Tip 4: Daily Progress Updates**

Agents update logs:
```markdown
## Progress Log

**2024-01-20 09:15** - Agent started
**2024-01-20 10:00** - Implementation: 25%
**2024-01-20 11:30** - Implementation: 75%
**2024-01-20 13:00** - Testing: 50%
**2024-01-20 14:30** - Complete ✓
  - PR: github.com/...
  - Time: 5h 15m
```

---

## 🎯 Common Patterns

### **Pattern 1: Cascade of Tasks**

```
task_001: Database (1 day)
  └─ task_002: Backend API (2 days)
      └─ task_003: Frontend UI (2 days)
          └─ task_004: Integration Tests (1 day)
              └─ task_005: Deploy (1 day)
```

Agent automatically:
1. Executes in order
2. Waits for dependencies
3. Starts next when ready
4. Updates you on WhatsApp/Slack

---

### **Pattern 2: Parallel Execution**

```
task_001: Database   (1 day)
├─ task_002: Backend (2 days) - starts day 2
│
└─ task_003: Frontend (2 days) - starts day 2
    └─ task_004: Integration (1 day) - starts day 4
```

Multiple agents working in parallel on independent tasks.

---

### **Pattern 3: Continuous Learning**

```
Day 1: task_001 (agent learns your patterns)
Day 2: task_002 (agent applies learned patterns)
Day 3: task_003 (agent increasingly accurate)
Week 2: task_004-010 (agent very productive)
```

Agent improves quality as it works.

---

## 📈 Measuring Success

### **Key Metrics**

```markdown
## Agent Performance Metrics

- Tasks completed: 23/25 (92%)
- Average task time: 4.2h
- Code quality (tests): 85%+ coverage
- Bug rate: <2% regression
- Time saved vs manual: 60h/week
- Learning progress: High (skills growing)

## Velocity
- Week 1: 4 tasks
- Week 2: 8 tasks
- Week 3: 12 tasks
- Week 4: 15 tasks (velocity increasing!)
```

---

**Your agents are now executing your projects! 🚀**

Start with simple tasks, gradually increase complexity, watch agents become more productive!
