# ADR-001: Environment Strategy

**Status:** Accepted

## Context
Developer Edition has no sandboxes. We need dev, UAT, and production-like environments.

## Decision
| Environment | Org | Purpose |
|---|---|---|
| Dev Hub | DE #1 | Creates scratch orgs only. No building here. |
| Dev | Scratch orgs | Daily development, disposable |
| UAT | DE #2 | User testing |
| Prod | DE #3 | Go-live simulation |

## Consequences
- Everything must be rebuildable from Git.
- Passwords and keys are never committed.