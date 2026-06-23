## Resources

- **references/clean-architecture-guide.md**: Detailed layer breakdown
- **references/hexagonal-architecture-guide.md**: Ports and adapters patterns
- **references/ddd-tactical-patterns.md**: Entities, value objects, aggregates
- **assets/clean-architecture-template/**: Complete project structure
- **assets/ddd-examples/**: Domain modeling examples

## Best Practices

1. **Dependency Rule**: Dependencies always point inward
2. **Interface Segregation**: Small, focused interfaces
3. **Business Logic in Domain**: Keep frameworks out of core
4. **Test Independence**: Core testable without infrastructure
5. **Bounded Contexts**: Clear domain boundaries
6. **Ubiquitous Language**: Consistent terminology
7. **Thin Controllers**: Delegate to use cases
8. **Rich Domain Models**: Behavior with data

## Common Pitfalls

- **Anemic Domain**: Entities with only data, no behavior
- **Framework Coupling**: Business logic depends on frameworks
- **Fat Controllers**: Business logic in controllers
- **Repository Leakage**: Exposing ORM objects
- **Missing Abstractions**: Concrete dependencies in core
- **Over-Engineering**: Clean architecture for simple CRUD
