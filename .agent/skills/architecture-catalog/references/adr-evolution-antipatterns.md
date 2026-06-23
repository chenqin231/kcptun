## Architecture Decision Record (ADR) Template

When choosing an architecture, document decisions:

```markdown
# ADR-001: Choose Modular Monolith

## Status
Accepted

## Context
- Team of 8 developers
- MVP deadline in 3 months
- Uncertain about domain boundaries
- Limited DevOps resources

## Decision
Adopt Modular Monolith with strict boundaries

## Consequences
### Positive
- Faster initial development
- Simpler deployment
- Can extract services later

### Negative
- Single point of failure
- Scaling limited to vertical
- Need discipline for module boundaries

## Alternatives Considered
1. Microservices - Too complex for team size
2. Traditional Monolith - No path to scale
```

---

## Evolution Path

```
┌─────────────────────────────────────────────────────────────────┐
│                    Architecture Evolution                        │
│                                                                 │
│   Monolith ──→ Modular Monolith ──→ Microservices              │
│      │              │                     │                     │
│      │              │                     ▼                     │
│      │              │            Event-Driven / CQRS            │
│      │              │                     │                     │
│      ▼              ▼                     ▼                     │
│  [Simple]     [Growing]            [Complex/Scale]              │
│                                                                 │
│   Tip: Don't skip steps. Each stage teaches domain boundaries. │
└─────────────────────────────────────────────────────────────────┘
```

---

## Anti-Patterns to Avoid

### 1. Big Ball of Mud
**Symptom**: No clear structure, everything depends on everything
**Fix**: Introduce module boundaries, apply Clean Architecture principles

### 2. Golden Hammer
**Symptom**: Using same architecture for every project
**Fix**: Evaluate requirements, use decision guide

### 3. Accidental Complexity
**Symptom**: Architecture more complex than domain requires
**Fix**: Start simple, add complexity only when needed

### 4. Resume-Driven Development
**Symptom**: Choosing tech for learning, not solving problems
**Fix**: Align architecture with team skills and project needs

### 5. Vendor Lock-In
**Symptom**: Core logic tightly coupled to cloud provider
**Fix**: Use Hexagonal Architecture, abstract vendor-specific code

---

## Performance Considerations by Pattern

| Pattern | Latency | Throughput | Cold Start |
|---------|---------|------------|------------|
| Monolith | Low | High | N/A |
| Microservices | Medium (network) | High (distributed) | N/A |
| Serverless | Variable | Auto-scale | 100ms-2s |
| Event-Driven | Higher (async) | Very High | Depends |

---

## Testing Strategies by Pattern

### Monolith
```
Unit Tests → Integration Tests → E2E Tests
    70%           20%              10%
```

### Microservices
```
Unit Tests → Contract Tests → Integration → E2E
    60%           20%           15%         5%

// Contract Test Example (Pact)
const provider = new Pact({ consumer: 'OrderService', provider: 'UserService' });
await provider.addInteraction({
  state: 'user exists',
  uponReceiving: 'get user request',
  withRequest: { method: 'GET', path: '/users/123' },
  willRespondWith: { status: 200, body: { id: '123', name: 'John' } }
});
```

### Event-Driven
- Test event producers and consumers independently
- Use event schema validation
- Test saga/workflow orchestration

---

## Related Skills

- [[api-design]] - API design for service communication
- [[system-design]] - Large-scale system considerations
- [[devops-cicd]] - Deployment strategies for each pattern
- [[data-design]] - Database patterns for each architecture
