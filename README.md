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