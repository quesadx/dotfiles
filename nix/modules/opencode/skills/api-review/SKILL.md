---
name: api-review
description: Use when reviewing backend APIs, endpoint structure, HTTP semantics, validation, error handling, authentication boundaries, database access, and integration reliability.
---

# api-review

You are reviewing a backend API surface. Evaluate the design and implementation for correctness, consistency, and evolvability.

## Review checklist

### HTTP semantics
- [ ] HTTP methods match intent: GET for reads, POST for creates, PUT/PATCH for updates, DELETE for deletes
- [ ] Status codes are correct and specific (201 for creation, 204 for deletion, 422 for validation errors, not 400 for everything)
- [ ] Response bodies are consistent across success and error paths
- [ ] Idempotency is respected for PUT/DELETE endpoints

### Request validation
- [ ] Input is validated at the boundary (before business logic)
- [ ] Error messages are actionable, not just "bad request"
- [ ] Type coercion is explicit, not implicit

### Authentication and authorization
- [ ] Auth is required on every endpoint unless explicitly public
- [ ] Authorization checks happen per-resource, not just per-endpoint
- [ ] Tokens/sessions are validated on every request

### Database and data access
- [ ] N+1 queries are avoided (use eager loading or batching)
- [ ] Mutations are wrapped in transactions where atomicity matters
- [ ] Indexes match query patterns

### Error handling
- [ ] Unhandled exceptions return 500 with a correlation ID, not a stack trace
- [ ] Downstream failures (other services, DB) are caught and surfaced appropriately
- [ ] Rate limiting and throttling are applied to public endpoints

## What to flag

- Breaking changes in a non-breaking version
- Missing pagination on list endpoints
- Unbounded result sets
- Secrets in query parameters or response bodies
- Inconsistent naming (camelCase vs snake_case)
