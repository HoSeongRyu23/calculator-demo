# SOLID Principles

## Overview
All code implementation must follow SOLID principles to ensure maintainable, scalable, and robust software design.

## The Five Principles

### 1. Single Responsibility Principle (SRP)
**A class should have only one reason to change.**

- Each class/module should have a single, well-defined responsibility
- Separate concerns into distinct classes
- Avoid "god objects" that do too much

**Example**: Separate calculation logic from UI rendering, data validation from data persistence

### 2. Open/Closed Principle (OCP)
**Software entities should be open for extension but closed for modification.**

- Design classes to be extended without modifying existing code
- Use abstractions (interfaces, abstract classes) to allow new behavior
- Favor composition and polymorphism over modification

**Example**: Use strategy pattern for different calculation modes instead of modifying core calculator class

### 3. Liskov Substitution Principle (LSP)
**Derived classes must be substitutable for their base classes.**

- Subclasses should enhance, not replace, base class behavior
- Maintain the contract defined by the base class
- Avoid breaking expectations of base class users

**Example**: If a base Calculator class defines calculate(), all derived calculators must implement it correctly

### 4. Interface Segregation Principle (ISP)
**Clients should not be forced to depend on interfaces they don't use.**

- Create focused, specific interfaces
- Avoid "fat interfaces" with many methods
- Split large interfaces into smaller, cohesive ones

**Example**: Separate IBasicCalculator and IScientificCalculator interfaces instead of one large ICalculator

### 5. Dependency Inversion Principle (DIP)
**Depend on abstractions, not concretions.**

- High-level modules should not depend on low-level modules
- Both should depend on abstractions
- Use dependency injection to provide implementations

**Example**: Calculator depends on IOperationProvider interface, not concrete OperationProvider class

## Application Guidelines

- **Design Phase**: Consider SOLID principles when designing new features
- **Code Reviews**: Evaluate adherence to SOLID principles
- **Refactoring**: Apply SOLID principles to improve existing code
- **Testing**: SOLID code is easier to test and mock

## Benefits

- **Maintainability**: Easier to understand and modify
- **Testability**: Simpler to write unit tests
- **Flexibility**: Easier to extend and adapt
- **Reusability**: Components can be reused in different contexts
