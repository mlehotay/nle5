# nle5-situation-geometry.md

## Constraint Geometry, Situation Organization, and Continuation-Centered Learning in NLE5

---

# Status

This document is exploratory and architectural.

It is not:

* a formal specification
* a finalized learning design
* a commitment to a particular implementation
* a claim that IER is required for NLE5

Its purpose is to clarify the emerging conceptual direction behind:

* situation-centered learning
* affordance organization
* event segmentation
* variable recruitment
* salience dynamics
* continuation geometry

within NetHack-like environments.

This document assumes familiarity with:

* `nle5-strategy.md`
* `IER-situations.md`
* `IER-affordances.md`
* `IER-variables.md`
* `IER-event-segmentation.md`
* `IER-salience.md`
* related IER structural documents

---

# 1. Core Reframing

Traditional reinforcement learning is typically organized around:

```text
state
→ policy
→ action
→ reward
```

NLE5 increasingly suggests a different framing:

```text
continuous situation geometry
→ participation organization
→ variable recruitment
→ affordance organization
→ salience gradients
→ binding transitions
→ collapse/action
→ propagation
→ deformed situation geometry
```

The important object is not merely:

```text
environment state
```

but:

```text
continuation geometry under constraint
```

The environment continuously generates:

* admissible continuations
* viability gradients
* uncertainty structures
* commitment boundaries
* affordance reorganizations
* participation shifts
* salience gradients
* irreversible contractions

The agent is not merely selecting actions from states.

It is regulating continuation under shifting constraint organization.

---

# 2. Situation Geometry

A situation is not:

* a world state
* a semantic context
* a symbolic scene label
* a latent environment vector

A situation is:

> the locally stabilized organization of constrained continuation through which action becomes possible.

Situation geometry includes:

* recruited variables
* affordance organization
* salience distribution
* participation allocation
* unresolved deviations
* viability organization
* continuation topology
* action readiness

A situation is therefore not a static object.

It is:

```text
continuous local organization
within evolving continuation geometry
```

---

# 3. Continuous Constraint Organization

The most important clarification is:

```text
constraint organization is continuous
```

The system does not experience discrete snapshots.

It experiences:

```text
continuous deformation
across articulated collapse structure
```

The following evolve continuously:

* participation allocation
* salience gradients
* affordance geometry
* viability structure
* tactical organization
* uncertainty pressure
* continuation topology

Situations persist continuously while deforming dynamically.

They are not destroyed and recreated every turn.

---

# 4. Discrete Collapse Structure

What *is* discrete:

* collapse
* admissibility contraction
* variable transitions
* event articulation
* irreversible commitments

Under the IER framing:

```text
collapse
=
irreversible contraction of admissible futures
```

In NetHack-like environments, collapses frequently correspond to:

* actions
* commitment transitions
* tactical irreversibilities
* resource expenditure
* topology changes
* state-boundary transitions

Examples include:

* opening a dangerous door
* descending stairs
* reading unidentified scrolls
* consuming limited resources
* aggroing monsters
* losing retreat topology
* becoming trapped

These collapses deform ongoing situation geometry continuously through propagation.

---

# 5. Variables as Recruited Dimensions

Variables are not static environment features with globally fixed importance.

Instead:

> variables become operationally real when recruited into continuation organization.

Examples:

| Variable         | Often latent         | Suddenly dominant        |
| ---------------- | -------------------- | ------------------------ |
| nutrition        | safe exploration     | starvation               |
| retreat topology | routine movement     | pursuit                  |
| line-of-sight    | traversal            | ranged threat            |
| uncertainty      | stable conditions    | unidentified consumables |
| inventory weight | normal travel        | escape latency           |
| staircase access | background structure | retreat collapse         |

Thus:

```text
situations recruit variables
```

The same environment state may instantiate radically different operational realities depending on which variables currently organize continuation.

---

# 6. Affordances as Locally Admissible Continuations

Affordances are not object properties.

A door is not intrinsically:

```text
openable terrain
```

Depending on situation geometry, the same door may become:

* a chokepoint stabilizer
* a visibility barrier
* an escape mechanism
* a commitment trigger
* a monster desynchronizer
* a risk amplifier

Affordances therefore emerge from:

```text
object
×
situation geometry
×
constraint organization
×
continuation topology
```

Affordances are:

```text
locally generated actionable continuations
```

not static gameplay primitives.

---

# 7. Participation Allocation

Attention is best understood as:

```text
participation allocation
```

Meaning:

```text
which structures currently participate
in globally consequential continuation organization
```

Participation varies continuously.

Some structures:

* dominate continuation
* weakly participate
* remain peripheral
* attenuate under competition
* recruit intermittently

Examples of weak but behaviorally consequential participation:

* vague hunger concern
* ambient escape awareness
* low-level uncertainty pressure
* soft tracking of monster density
* latent staircase awareness

This implies that intelligent agents may require:

```text
graded participation organization
```

rather than binary salience systems.

---

# 8. Salience as Recruitment Gradient

Salience is not:

* importance
* reward value
* informational novelty
* executive focus

Salience is:

```text
recruitment pressure prior to binding
```

Salience gradients determine:

* what repeatedly recruits participation
* what resists dismissal
* what creates stabilization pressure
* what dominates traversal

Importantly:

```text
salience persistence
≠
informational incompleteness
```

A structure may continue generating recruitment pressure even after informational novelty disappears.

This matters for:

* tactical instability
* uncertainty
* curiosity loops
* attraction structures
* unresolved danger
* incomplete affordances
* repeated tactical motifs

The important feature is not missing information.

It is:

```text
continued recruitability within the current geometry
```

---

# 9. Deviation Binding

Most deviations remain non-binding.

A deviation becomes binding when:

```text
dropping it would alter admissible futures
```

Examples:

* collapsing retreat routes
* unresolved pursuit
* broken chokepoints
* monster displacement
* starvation thresholds
* dangerous uncertainty
* tactical asymmetry

Once deviation binds:

* participation concentrates
* salience intensifies
* affordance organization reorganizes
* restoration pressure emerges

This corresponds closely to:

```text
tactical tension
```

in gameplay.

---

# 10. Event Segmentation

The environment deforms continuously.

Not every deformation constitutes an event.

Event boundaries occur when:

```text
continuous deformation
produces consequential reorganization
of continuation geometry
```

Thus events are not:

* frames
* turns
* ticks
* observations

Events are:

```text
articulated reorganizations
within continuous situation geometry
```

Examples:

* opening a door into danger
* losing staircase access
* identifying a critical resource
* entering starvation conditions
* breaking corridor control
* becoming surrounded
* crossing commitment thresholds

These reorganize:

* admissible futures
* affordances
* variable recruitment
* participation allocation
* viability geometry

---

# 11. Continuous vs Discrete Structure

The resulting ontology is:

| Continuous             | Discrete                  |
| ---------------------- | ------------------------- |
| participation          | collapse                  |
| salience gradients     | event articulation        |
| affordance geometry    | variable transitions      |
| viability organization | admissibility contraction |
| situation geometry     | irreversible commitments  |

This distinction is critical.

The system does not move through discrete static states.

Instead:

```text
continuous situation geometry
undergoes propagated deformation
through discrete collapse boundaries
```

---

# 12. Action

Action is not merely output selection.

Action is:

```text
irreversible continuation contraction
```

Actions matter because they:

* remove futures
* propagate consequences
* reorganize viability
* alter future affordances
* sediment tactical history

Examples include:

* committing to combat
* entering dangerous regions
* consuming limited consumables
* descending stairs
* reading unknown scrolls
* sacrificing escape topology

The importance of action comes from:

```text
future-space contraction
```

not merely motor execution.

---

# 13. Propagation Depth

Situations are not best understood as temporary vs permanent.

Instead, collapses differ in:

```text
propagation depth
```

Some deformations dissipate quickly:

* local monster movement
* transient tactical asymmetry
* brief uncertainty spikes

Others reorganize future geometry deeply:

* item identification
* permanent hostility
* resource depletion
* staircase transitions
* inventory transformation
* long-term strategic commitments

Thus:

```text
some collapses weakly deform future geometry;
others propagate deeply through continuation structure
```

---

# 14. Situation Clustering

This suggests a different target for representation learning.

Instead of clustering:

* observations
* reward statistics
* state vectors
* visual similarity

the system may cluster:

```text
continuation geometries
```

Examples:

* retreat-collapse situations
* uncertainty-escalation situations
* exploration-expansion situations
* inventory panic situations
* chokepoint stabilization situations
* affordance-collapse situations
* optionality-restoration situations

This may permit transfer across superficially unrelated environments.

---

# 15. Why NetHack Matters

NetHack continuously reorganizes:

* admissible futures
* uncertainty structures
* tactical viability
* action-space geometry
* continuation topology

through:

* stochasticity
* partial observability
* delayed consequence
* inventory-mediated affordances
* irreversible commitments
* dynamic tactical topology
* survival bottlenecks

This makes NetHack unusually suitable for studying:

```text
continuation organization under shifting constraint
```

rather than merely benchmark optimization.

---

# 16. Long-Term Direction

The long-term direction suggested by this framework is not merely:

```text
larger policies
```

or:

```text
better benchmark optimization
```

but agents capable of:

* situation segmentation
* dynamic variable recruitment
* graded participation allocation
* affordance-field organization
* salience management
* tactical geometry recognition
* continuation-structure clustering
* adaptive admissibility regulation

The goal is not merely action prediction.

The goal is:

```text
adaptive regulation of continuation geometry
within dynamic worlds
```

---

# 17. Scope Reminder

Despite the conceptual direction, the immediate engineering objective remains intentionally modest:

```text
reset
step
observe
debug
repeat
```

The bridge comes first.

The continuation geometry comes later.
