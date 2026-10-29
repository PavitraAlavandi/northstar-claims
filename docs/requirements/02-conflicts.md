# Conflicts

## C1: "Declarative only" versus "real-time vendor fraud scoring"
- **Who:** Tom (IT Director) and Marcus (SIU Lead)
- **The tension:** Tom wants no custom code to maintain. Marcus needs a real-time call to an outside fraud API with error handling. Flows can make simple callouts, but retries, logging, and bulk handling are much harder without code.
- **Options:** (A) Flow plus External Service only, (B) Apex Queueable callout with Platform Event for results, (C) Hybrid: Flow starts the process, one small Apex callout class handles retry and logging.
- **Recommended:** Option C. Keep code small, tested, and documented.
- **Who decides:** Tom, with Marcus's input.

## C2: "Real-time" versus "never slow down intake"
- **Who:** Marcus and Priya (adjusters)
- **The tension:** A truly real-time call during save makes the user wait for the vendor. If the vendor is slow, intake slows down. Both statements cannot be fully true.
- **Options:** (A) Synchronous call with a short timeout, (B) Asynchronous scoring right after save, (C) Batch scoring every few minutes.
- **Recommended:** Option B, with "real-time" defined as a score within 60 seconds.
- **Who decides:** Rhea, based on Marcus's risk tolerance.

## C3: "Keep all data 7 years" versus "don't slow things down"
- **Who:** Anika (Compliance) and Tom (IT), with Greg on cost
- **The tension:** Keeping everything in live Salesforce grows storage cost and can slow reports and queries. Archiving risks breaking the audit requirement.
- **Options:** (A) Keep everything in Salesforce, (B) Archive old closed claims to Big Objects or external storage, (C) Keep a summary in Salesforce and full records in an archive.
- **Recommended:** Option C, with a documented retrieval process for auditors.
- **Who decides:** Anika approves retention, Tom approves the technical approach.

## C4: "Dan can override anything" versus "every decision needs an audit trail"
- **Who:** Dan (Operations) and Anika (Compliance)
- **The tension:** Unlimited override power can bypass approvals and change paid claims, which regulators would question.
- **Options:** (A) Dan gets full edit rights, (B) Dan can override only with a mandatory reason, logged in an audit record, (C) Dan can request changes, and a second person approves.
- **Recommended:** Option B for Phase 1.
- **Who decides:** Anika, agreed with Dan and Rhea.

## C5: "Policyholders see their claim status" versus "keep licensing cost down"
- **Who:** Rhea (and policyholder experience) and Greg (CFO)
- **The tension:** About 420,000 policyholders with logins could be very expensive and add large security work. Greg wants lower cost.
- **Options:** (A) Full Experience Cloud portal, (B) Email or SMS status notifications only, (C) Email now, portal later after a license cost estimate.
- **Recommended:** Option C.
- **Who decides:** Greg and Rhea together.

## C6: "Auto and home" versus "Phase 1 is auto only" versus "14 weeks"
- **Who:** Rhea (sponsor), plus the budget of one developer
- **The tension:** Rhea says "design for it," but the timeline allows one developer for 14 weeks. Building both fully will not fit.
- **Options:** (A) Build auto only, with a data model that can grow, (B) Build both thinly, (C) Delay go-live.
- **Recommended:** Option A, with Home as a documented Phase 2.
- **Who decides:** Rhea.