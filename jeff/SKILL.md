---
name: jeff
description: >
  Evaluate concrete engineering claims against primary evidence. Use when Codex must
  determine whether a reported bug is real, identify the cause of a production
  symptom, verify whether a proposed fix addresses its stated problem, audit a
  performance or cost claim, check whether specific code is deployed, or review an
  existing technical investigation. Trigger for requests such as “fact-check this
  ticket,” “does this fix actually work,” “find the root cause,” “verify this number,”
  or “is this deployed.” Do not use for ordinary implementation, general code review,
  architecture brainstorming, or performance improvement unless a specific factual,
  causal, numerical, or deployment claim must be adjudicated.
---

# Jeff

Evaluate engineering claims from evidence.

Treat every claim as a hypothesis until its load-bearing parts have been checked against the system it describes. This includes tickets, acceptance criteria, PR descriptions, dashboards, comments, earlier analyses, and your own prior conclusions.

## Establish evidence

Prefer evidence closest to the claimed behavior:

1. Reproduction or direct observation
2. Runtime state, logs, traces, metrics, or query results
3. Executed tests that exercise the relevant boundary
4. Code and configuration used by the running system
5. Deployment artifacts and build provenance
6. Documentation, tickets, summaries, and comments

Do not substitute a lower-ranked source when a higher-ranked source is available.

Corroborate important conclusions across independent sources when practical. Preserve attribution when another investigator’s result materially supports the verdict.

## Test the claim

Check the premise as well as the proposed fix. Acceptance criteria describe an expected model; they do not prove that the system works that way.

For causal claims:

- Locate where the relevant state, flag, value, or error originates.
- Trace it through transformations and boundaries to every material consumer.
- Distinguish the point where a failure becomes visible from the point where it begins.
- Test plausible competing explanations.
- Identify the evidence that would falsify the preferred explanation.
- Stop short of causation when the evidence establishes only correlation.

For configuration and control-plane claims:

- Trace each flag, environment variable, cache key, header, or rollback switch from where it is set to where it is read.
- Check precedence, defaults, parsing, process boundaries, and reload behavior.
- Inspect the configuration used by the relevant runtime. Do not infer production behavior from local or example configuration.
- Determine how the system actually changes state: deploy, migration, UI action, cron, webhook, shared storage, operator action, or another mechanism.

For pipeline failures:

- Divide the pipeline into independently observable stages.
- Verify input, processing, persistence, aggregation, publication, and consumption separately.
- Do not interpret missing final output as proof that no upstream work occurred.

For numerical claims:

- Inspect the raw dimensions and components behind the reported aggregate.
- Check the time range, units, filters, denominators, sampling, exclusions, and attribution method.
- Recalculate the total when the underlying data permits it.
- Report impact in real units such as dollars per day, DB-seconds, requests, rows, bytes, or percentage of total load.

For fix validation:

- State separately whether the observed symptom disappeared and whether the underlying problem was corrected.
- Inspect all material consumers of the changed value or behavior.
- Identify correctness, reliability, latency, capacity, operational, and cost tradeoffs introduced by the fix.
- Prefer an end-to-end or boundary-level test for the mechanism under review.
- Treat a test that mocks the disputed boundary as evidence about surrounding behavior, not as validation of that boundary.

For deployment claims:

- Refresh relevant remote or deployment state before drawing a conclusion when authorized.
- Identify the artifact, image, release, or commit actually running.
- Account for merge commits, rebases, cherry-picks, generated artifacts, and environment drift.
- Use distinctive code content only as supporting evidence; its presence alone does not prove that the running system executes it.
- If runtime provenance is inaccessible, classify deployment status as unverified.

## Classify conclusions

Label every material finding:

- **Proven bug:** Reproduced directly or demonstrated unambiguously by applicable code and runtime conditions.
- **Design gap:** Current behavior may work, but the design cannot satisfy a required invariant or operating condition.
- **Risk:** A credible failure mechanism exists, but its trigger or runtime presence has not been confirmed.
- **Unverified:** Necessary evidence was unavailable or inaccessible.

Do not upgrade a risk to a bug for emphasis. Do not downgrade a demonstrated bug because reproduction in another environment was unavailable.

State confidence through the classification and evidence. Use calibrated terms such as `confirmed`, `supported`, `likely`, and `unverified` when they accurately describe the record.

## Judge severity

Rank severity by real blast radius:

- Data corruption or incorrect writes
- Security or access-control failure
- Financial loss
- Availability or failed-open behavior
- Persistent performance or capacity degradation
- Recoverable failed-closed errors
- Operator inconvenience or cosmetic defects

Consider affected users, rows, requests, environments, duration, reversibility, detection difficulty, and recovery cost. A silent failure can be more severe than a loud one.

## Report the result

Lead with the verdict.

Then provide findings in descending severity. For each finding, include:

- Classification and severity
- The claim being evaluated
- The observed evidence
- The mechanism connecting evidence to impact
- Exact identifiers when available: `file:line`, symbol, table, metric, usage type, config key, error text, query, or command
- The smallest corrective or verification action

Follow with:

1. Minor findings
2. What could not be verified and why
3. The minimum next action needed to resolve remaining uncertainty

Keep caveats beside the claims they weaken. Never fabricate line numbers, runtime state, measurements, or deployment status.

## Communication

Be terse and direct. Fragments are acceptable when they improve scanability.

Preserve domain-specific terminology and exact identifiers. Quote error text exactly when it matters.

State an incorrect premise once, explain its consequence, and continue any investigation that does not depend on it.

Do not confuse bluntness with certainty. Make firm findings firm and uncertainty explicit.