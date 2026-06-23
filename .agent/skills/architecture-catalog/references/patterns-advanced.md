### Clean Architecture

**Description**: Dependency-inverted architecture with domain at center.

**Layer Structure**:
```
┌──────────────────────────────────────┐
│           Frameworks & Drivers       │  ← External (DB, Web, UI)
├──────────────────────────────────────┤
│           Interface Adapters         │  ← Controllers, Gateways
├──────────────────────────────────────┤
│           Application Business       │  ← Use Cases
├──────────────────────────────────────┤
│           Enterprise Business        │  ← Entities, Domain Rules
└──────────────────────────────────────┘
```

**Dependency Rule**: Dependencies point inward. Inner layers know nothing about outer layers.

---

### Domain-Driven Design (DDD)

**Description**: Architecture aligned with business domain.

**Strategic Patterns**:
| Pattern | Purpose |
|---------|---------|
| Bounded Context | Clear domain boundaries |
| Context Map | Relationships between contexts |
| Ubiquitous Language | Shared vocabulary |

**Tactical Patterns**:
| Pattern | Purpose |
|---------|---------|
| Entity | Objects with identity |
| Value Object | Immutable descriptors |
| Aggregate | Consistency boundary |
| Repository | Collection-like persistence |
| Domain Event | Something that happened |

---

### Hexagonal Architecture (Ports & Adapters)

**Description**: Application core isolated from external concerns through ports (interfaces) and adapters (implementations).

**Structure**:
```
┌─────────────────────────────────────────────────────────────┐
│                      Driving Adapters                       │
│    (REST API, CLI, GraphQL, Message Consumer)               │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                    Input Ports                              │
│              (Use Case Interfaces)                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                   APPLICATION CORE                          │
│              (Domain Logic, Entities)                       │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                   Output Ports                              │
│           (Repository, Gateway Interfaces)                  │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                     Driven Adapters                         │
│    (Database, External APIs, Message Publisher)             │
└─────────────────────────────────────────────────────────────┘
```

**TypeScript Example**:
```typescript
// Port (Interface)
interface OrderRepository {
  save(order: Order): Promise<void>;
  findById(id: string): Promise<Order | null>;
}

// Adapter (Implementation)
class PostgresOrderRepository implements OrderRepository {
  constructor(private db: Database) {}

  async save(order: Order): Promise<void> {
    await this.db.query('INSERT INTO orders...', [order]);
  }

  async findById(id: string): Promise<Order | null> {
    const row = await this.db.query('SELECT * FROM orders WHERE id = $1', [id]);
    return row ? this.toDomain(row) : null;
  }
}

// Use Case (Application Core)
class CreateOrderUseCase {
  constructor(private orderRepo: OrderRepository) {} // Depends on Port, not Adapter

  async execute(input: CreateOrderInput): Promise<Order> {
    const order = new Order(input);
    await this.orderRepo.save(order);
    return order;
  }
}
```

**Benefits**:
- Easy to swap implementations (DB, external services)
- Highly testable (mock ports)
- Framework-agnostic domain logic

---

### Modular Monolith

**Description**: Monolith with strict module boundaries, preparing for potential microservices extraction.

**Key Features**:
- Modules communicate via defined interfaces
- Each module owns its data
- Can be deployed as single unit or extracted

**Structure**:
```
src/
├── modules/
│   ├── users/
│   │   ├── api/           # Public API of module
│   │   │   └── UserService.ts
│   │   ├── internal/      # Private implementation
│   │   │   ├── UserRepository.ts
│   │   │   └── UserEntity.ts
│   │   └── index.ts       # Only exports public API
│   ├── orders/
│   │   ├── api/
│   │   │   └── OrderService.ts
│   │   ├── internal/
│   │   └── index.ts
│   └── shared/            # Cross-cutting utilities
├── infrastructure/
│   ├── database/
│   ├── messaging/
│   └── http/
└── main.ts
```

**Module Communication Rules**:
```typescript
// ✅ Good: Use public API
import { UserService } from '@modules/users';
const user = await userService.getById(id);

// ❌ Bad: Direct access to internal
import { UserRepository } from '@modules/users/internal/UserRepository';
```

**Enforcement**:
```json
// eslint rules or ts-paths to prevent internal imports
{
  "rules": {
    "no-restricted-imports": ["error", {
      "patterns": ["@modules/*/internal/*"]
    }]
  }
}
```

---

### Strangler Fig Pattern

**Description**: Gradually replace legacy system by routing traffic to new implementation.

**Migration Process**:
```
Phase 1: Facade
┌─────────┐     ┌─────────┐     ┌─────────────┐
│ Client  │────→│ Facade  │────→│ Legacy      │
└─────────┘     └─────────┘     │ System      │
                                └─────────────┘

Phase 2: Partial Migration
┌─────────┐     ┌─────────┐     ┌─────────────┐
│ Client  │────→│ Facade  │──┬─→│ Legacy      │
└─────────┘     └─────────┘  │  └─────────────┘
                             │  ┌─────────────┐
                             └─→│ New System  │
                                └─────────────┘

Phase 3: Complete Migration
┌─────────┐     ┌─────────┐     ┌─────────────┐
│ Client  │────→│ Facade  │────→│ New System  │
└─────────┘     └─────────┘     └─────────────┘
```

**Implementation**:
```typescript
class PaymentFacade {
  constructor(
    private legacyPayment: LegacyPaymentService,
    private newPayment: NewPaymentService,
    private featureFlags: FeatureFlags
  ) {}

  async processPayment(payment: Payment): Promise<Result> {
    // Gradually migrate traffic
    if (this.featureFlags.isEnabled('new-payment-system', payment.userId)) {
      return this.newPayment.process(payment);
    }
    return this.legacyPayment.process(payment);
  }
}
```

---

### Backend for Frontend (BFF)

**Description**: Dedicated backend for each frontend type (web, mobile, etc.).

**Structure**:
```
                    ┌─────────────┐
                    │ Web Client  │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  Web BFF    │
                    └──────┬──────┘
                           │
       ┌───────────────────┼───────────────────┐
       │                   │                   │
┌──────▼──────┐    ┌──────▼──────┐    ┌──────▼──────┐
│ User Service│    │Order Service│    │Product Svc  │
└─────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                           │
                    ┌──────▼──────┐
                    │ Mobile BFF  │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │Mobile Client│
                    └─────────────┘
```

**Benefits**:
- Optimized payload for each client
- Client-specific authentication
- Independent deployment per frontend
- Reduces over-fetching

**When to Use**:
| Scenario | Recommendation |
|----------|----------------|
| Single client type | Skip BFF |
| Web + Mobile with same needs | Single API Gateway |
| Different UX per platform | Separate BFFs |
| Multiple teams per frontend | Dedicated BFFs |
