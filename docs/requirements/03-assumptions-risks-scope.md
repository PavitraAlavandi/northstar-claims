# Assumptions, Risks, and Phase 1 Scope

## Assumptions Log

| ID | Assumption | Owner to confirm | Impact if wrong | Status |
|----|------------|------------------|-----------------|--------|
| A1 | Phase 1 covers Auto claims only. Home is added later with a new record type | Rhea | Data model rework | Open |
| A2 | PolicyCore stays the system of record. Policy data is copied nightly into Salesforce, read-only, using Policy Number as External ID | Tom | A real-time lookup means extra callout and error handling work | Open |
| A3 | The fraud vendor offers a REST API (JSON, API key or OAuth) and a test environment | Marcus | Integration design and timeline change | Open |
| A4 | Fraud scoring runs asynchronously and returns within 60 seconds. Intake is never blocked | Marcus | Different architecture, and users wait on screen | Open |
| A5 | About 60,000 claims per year and about 3,000 open claims to migrate (my estimates, not client data) | Greg, Dan | Batch sizes, storage, and migration effort change | Open |
| A6 | Policyholders and partners get no Salesforce logins in Phase 1. Status goes by email and partners use a REST API | Rhea, Leila | Experience Cloud and license cost added | Open |
| A7 | One approval threshold of $10,000 per claim, approved by the adjuster's manager | Rhea | Approval process redesigned | Open |
| A8 | Claims are locked after payment. Only a Claims Admin can edit, with a logged reason. Nobody can delete | Anika | Security and audit design change | Open |
| A9 | Salesforce records payment authorization. A separate finance system pays | Greg | A payment integration is added | Open |
| A10 | This simulation uses Developer Edition limits (storage, API calls). A real client would use Enterprise or higher | Me (developer) | Limits and available features differ | Accepted |

## Risks Log

| ID | Risk | Probability | Impact | Mitigation | Owner |
|----|------|-------------|--------|------------|-------|
| R1 | Fraud vendor API is down or slow, so claims go unscored | Medium | High | Async scoring, retry with backoff, "Fraud Check Pending" status, SIU manual queue, alert on repeated failure | Developer |
| R2 | Blocker questions stay unanswered, causing rework later | High | High | Written assumptions signed off by the end of Sprint 1, and a change request process | Developer |
| R3 | Excel data is dirty (duplicates, missing fields, no unique claim number) | High | Medium | Get a sample early, load into a staging object, produce an error report, use composite External ID | Developer |
| R4 | One developer for 14 weeks: scope creep or key-person risk | Medium | High | Strict Phase 1 scope, ADRs for decisions, everything in Git, CI validation | Developer |
| R5 | Regional data leaks to the wrong users | Low | High | Private OWD, sharing rules tested per role, field-level security review, security test cases in UAT | Developer |
| R6 | Storage or performance problems from the 7-year retention rule | Medium | Medium | Archival design in Sprint 2, selective indexes, scheduled Batch jobs | Developer |
| R7 | License cost grows if external users are added | Medium | Medium | Defer portal, estimate license cost before any decision | Greg |

## Phase 1 Scope

**In scope (Phase 1, Auto claims):** claim intake by internal users, automatic adjuster assignment, approval of claims over the threshold, asynchronous fraud scoring with payment hold for flagged claims, a REST endpoint for partner estimates, regional security with a role hierarchy, dashboards for managers, status notification emails to policyholders, a nightly policy sync from PolicyCore, and migration of open auto claims from Excel.

**Out of scope (later):** Home claims, a policyholder or partner login portal, payment execution, archiving of old data, and mobile app features.

**Designed for, but not built:** a Claim object with record types so Home can be added without rework, an archive-friendly data model, and security that can later extend to external users.