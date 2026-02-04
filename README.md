# Salesforce Trigger Framework

## Overview

This repository contains a lightweight and reusable **Salesforce Apex Trigger Framework** designed to standardize trigger development, improve maintainability, and enforce clean architecture principles.

The framework separates trigger logic from the trigger itself by using a **Handler Pattern** and a **Dispatcher**, making it easier to scale and maintain enterprise-level Salesforce implementations.

---

## Architecture

The framework consists of three main parts:

### 1. TriggerHandler (Base Class)

A virtual base class that defines all trigger event methods. Individual object handlers extend this class and override only the required logic.

Supported Events:

* BeforeInsert
* BeforeUpdate
* BeforeDelete
* AfterInsert
* AfterUpdate
* AfterDelete
* AfterUndelete

The `IsDisabled()` method allows enabling or disabling trigger execution dynamically.

---

### 2. TriggerDispatcher

The dispatcher is responsible for routing Salesforce trigger context events to the appropriate handler methods.

Responsibilities:

* Detect Trigger context (Before/After)
* Detect operation (Insert/Update/Delete/Undelete)
* Call the correct handler method
* Centralize execution logic

This ensures all triggers follow a consistent structure.

---

### 3. Object Trigger + Handler

Each object has:

* A **single trigger** (thin trigger pattern)
* A dedicated **TriggerHandler** class

Example:

* `CaseTrigger` → Entry point
* `CaseTriggerHandler` → Business logic

---

## Repository Structure

```
force-app
└── main
    └── default
        └── classes
            ├── TriggerHandler.cls
            ├── TriggerDispatcher.cls
            ├── CaseTriggerHandler.cls
        └── triggers
            └── CaseTrigger.trigger
```

---

## How It Works

### Step 1 — Trigger Calls Dispatcher

The trigger contains no business logic. It only invokes the dispatcher:

```
trigger CaseTrigger on Case (...) {
    TriggerDispatcher.Run(new CaseTriggerHandler());
}
```

### Step 2 — Dispatcher Detects Context

The dispatcher evaluates:

* Trigger.isBefore
* Trigger.isAfter
* Trigger.isInsert
* Trigger.isUpdate
* Trigger.isDelete
* Trigger.isUndelete

and calls the matching handler method.

---

### Step 3 — Handler Executes Logic

Handlers override only the needed methods:

```
public override void BeforeInsert(List<SObject> newItems) {
    // Business logic here
}
```

---

## Creating a New Trigger Using This Framework

Follow these steps:

1. Create a new Handler class extending `TriggerHandler`
2. Override `IsDisabled()` and return `false`
3. Implement required event methods
4. Create a thin trigger that calls `TriggerDispatcher.Run()`

Example:

```
public class AccountTriggerHandler extends TriggerHandler {

    public override Boolean IsDisabled() {
        return false;
    }

    public override void BeforeInsert(List<SObject> newItems) {
        // Your logic here
    }
}
```

Trigger:

```
trigger AccountTrigger on Account (...) {
    TriggerDispatcher.Run(new AccountTriggerHandler());
}
```

---

## Key Benefits

* Single responsibility principle
* Clean separation of concerns
* Reusable architecture
* Easier unit testing
* Scalable for enterprise orgs
* Consistent trigger structure
* Prevents logic duplication

---

## Best Practices

* Keep triggers thin — no business logic inside triggers
* Use one trigger per object
* Bulkify all handler logic
* Avoid SOQL/DML inside loops
* Use helper/service classes for complex logic
* Add logging and error handling inside handlers

---

## Error Handling & Logging

Handlers can implement try/catch blocks and use a centralized logging utility for better monitoring and debugging.

---

## Future Enhancements (Optional Ideas)

* Add recursion control
* Add feature toggle/custom metadata control
* Add unit of work pattern
* Add async execution support
* Add dependency injection support

---

## Author

Built for scalable Salesforce Apex trigger development using a modular handler-dispatcher pattern.
