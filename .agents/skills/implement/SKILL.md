---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, use /code-review to review the work.

Commit your work to the current branch.

## Handoff for human verification

An implementation is not complete when the code is committed. After the implementation, validation, and `/code-review` have finished:

1. Move the Linear issue to `Review` (or the closest available non-terminal review state). Never move it to `Done` or `Completed` from this skill.
2. Add the `ready-for-human` label. If the issue has an incompatible triage label, replace it only when necessary to leave the issue clearly awaiting human review.
3. Tell the developer to manually verify the implemented functionality, including the relevant user flow and any checks that cannot be automated.
4. Instruct the developer to mark the issue as `Done`/`Completed` manually only after that verification passes. If verification fails, leave the issue in review and record the failure or follow-up needed.

The final report must state the review state, the `ready-for-human` label, the validations run, and the exact manual verification requested.
