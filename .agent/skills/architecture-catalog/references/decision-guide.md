## Decision Guide

```
START
  │
  ├─ Team size < 10? ──────────────────→ Monolith
  │
  ├─ Need independent deployments? ────→ Microservices
  │
  ├─ Audit trail required? ────────────→ Event Sourcing
  │
  ├─ Variable/unpredictable load? ─────→ Serverless
  │
  ├─ Complex business logic? ──────────→ Clean Architecture + DDD
  │
  └─ Default ──────────────────────────→ Modular Monolith
```

## Common Pitfalls

### 1. Premature Microservices
**Problem**: Starting with microservices for a simple application
**Solution**: Start monolithic, extract services when boundaries are clear

### 2. Distributed Monolith
**Problem**: Microservices that must deploy together
**Solution**: Ensure services are truly independent with clear API contracts

### 3. Ignoring Data Boundaries
**Problem**: Shared database across services
**Solution**: Each service owns its data, use events for synchronization

---

## Architecture Patterns Comparison

| Pattern | Complexity | Scalability | Team Size | Best For |
|---------|------------|-------------|-----------|----------|
| Monolith | Low | Vertical | Small (2-10) | MVPs, Simple apps |
| Modular Monolith | Medium | Vertical | Medium (5-20) | Growing apps |
| Microservices | High | Horizontal | Large (20+) | Complex domains |
| Serverless | Medium | Auto | Any | Event-driven, Variable load |
| Event-Driven | High | Horizontal | Medium-Large | Async workflows |
