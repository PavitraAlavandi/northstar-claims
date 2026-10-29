# ClaimsConnect (NorthStar Mutual Insurance)

Salesforce claims management platform. Built as a solo end-to-end project.

## Branching Strategy
- `main`: production-ready code. Deployed to Prod.
- `develop`: integration branch. Deployed to UAT.
- `feature/US-<id>-<short-name>`: one user story = one branch, created from `develop`.
- `hotfix/<short-name>`: urgent production fix, created from `main`, merged into `main` AND `develop`.

## Rules
- No direct commits to `main` or `develop`. Use pull requests, even when working solo.
- Commit message format: `US-1.2: short description`
- Never commit passwords, tokens, or keys.

## Environments
See `docs/decisions/ADR-001-environments.md`.

Workflow tested
## Decisions
- **Policyholder model:** Person Accounts (individuals) + Business Accounts (small businesses). Chosen because ~95% of policyholders are individuals and a portal is planned later. Trade-off: cannot be disabled once enabled. Risk: enabling in UAT/Prod DE orgs must be verified before Sprint 9.