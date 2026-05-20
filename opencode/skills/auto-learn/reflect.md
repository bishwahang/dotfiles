# Reflection prompt

Apply this prompt against the conversation you just completed. Produce a raw candidate list before classification.

## Questions to scan for

For each, look back over the conversation and answer concretely. If no answer, skip.

1. **What surprised me?**
   Anything that didn't behave as expected -- API quirks, framework defaults, test flakiness, hidden coupling.

2. **What would I want to know next time?**
   If I were dropped into this exact problem 3 months from now with no memory, what one fact would save me an hour?

3. **What did we try that didn't work?**
   Failed approaches, dead ends, libraries we ruled out, configurations that broke things. Candidates for `decisions.md`.

4. **What rule did we apply that wasn't already written down?**
   Conventions implicitly followed but not yet captured.

5. **What pattern recurred?**
   Did we write similar code 2+ times? Did we follow the same debugging sequence? Candidate for Pattern or new skill.

6. **What anti-pattern did we have to undo?**
   Did we have to fix code that was structurally wrong? What's the rule that prevents it next time?

7. **Was there a multi-step workflow I'd want to automate?**
   Sequence of >= 3 steps that could become a skill.

8. **Did the user correct me on style/voice/preference?**
   Capture as Universal Convention if it crosses projects, otherwise per-project.

## Output shape

Produce a flat list of candidates, each tagged with a tentative type:

```
- [CONVENTION] <one-line rule>
- [GOTCHA] <one-line trap + when it bites>
- [DECISION] <title> | tried: <x>, chose: <y>, because: <z>
- [PATTERN] <one-line "do this" + brief example>
- [ANTI-PATTERN] <one-line "don't do this" + reason>
- [UNIVERSAL] <one-line cross-project rule>
- [SKILL?] <name> | steps: <n> | expected future uses: <n>
```

Then hand off to the classification + novelty + safety pipeline in `SKILL.md`.

## Heuristics

- Prefer ONE strong candidate over THREE weak ones.
- If unsure between Convention and Pattern: Convention if it's a rule, Pattern if it has a code example.
- If unsure between Gotcha and Decision: Gotcha if it's a fact about the system, Decision if it's a choice we made.
- If a candidate is just "we used X library" with no rationale, drop it.
- If a candidate could be inferred by reading the code: drop it (low value).
- If a candidate would have saved >= 15 minutes of work: keep it (high value).
