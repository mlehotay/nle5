# NLE5 Window Port Plan Assessment

Date: 2026-05-26

Source assessed: `../nle5/_work/nle5-window-port.md`

## Summary

The NLE5 window-port plan has the right high-level architecture: use a NetHack
5.0.0 window port as the observation and control boundary rather than trying to
parse a terminal subprocess. NetHack already routes map rendering, messages,
status, prompts, menus, and key input through `struct window_procs`, so a custom
port is the natural place to build a Gymnasium-facing interface.

The plan is still a sketch, not an implementation design. It correctly names
the key callbacks, but it understates the hard parts: NetHack startup and role
selection, prompts and menus, synchronization, save/runtime data paths,
threading, lifecycle, and the difference between a terminal stream and a
structured learning environment.

Recommendation: continue with a custom NetHack 5.0.0 window port, but split the
work into a small C-only proof of concept before adding Python, pybind11, or a
full Gymnasium wrapper.

## What Looks Sound

The strongest part of the plan is the boundary choice.

Useful NetHack 5.0.0 hooks:

- `win_print_glyph`: best primary source for visible map glyphs;
- `win_status_update`: best primary source for bottom-line/status values;
- `win_putstr` and message history callbacks: likely sources for messages;
- `win_nhgetch` and `win_nh_poskey`: natural action injection points;
- `win_yn_function`, `win_getlin`, `win_select_menu`, and `win_get_ext_cmd`:
  necessary for prompts and non-movement interactions;
- `win_create_nhwindow`, `win_display_nhwindow`, and window ids: needed to
  distinguish map, message, menu, inventory, and text windows.

The plan is also right that a subprocess terminal parser should be a fallback,
not the main design. A parser has to reverse-engineer terminal behavior, escape
sequences, redraws, clipping, status formatting, and prompts. A window port
sees structured callbacks before those details are flattened into terminal
output.

## Main Gaps

The current plan compresses several separate problems into one bridge.

Startup is not specified. A Gym environment needs to initialize NetHack,
select or configure role/race/alignment/gender/name, load runtime data, and
reach a stable first observation without depending on fragile interactive
prompts.

Turn boundaries are underspecified. `nhgetch` is an important blocking point,
but NetHack can ask for input in several forms. A robust bridge needs a clear
state machine: observation ready, waiting for action, processing action,
terminal/death/new-game state, and prompt/menu state.

Observation shape is incomplete. A map and `blstats` are useful, but an agent
also needs at least messages, prompt state, available menu choices or command
mode, inventory/menu windows when active, and terminal state such as game over
or quit confirmation.

Threading is unresolved. The busy-wait example is explicitly not production
quality. The design needs either a single-threaded embedding model with clear
re-entry points, or a worker thread plus mutex/condition-variable handoff. That
decision affects every API surface.

Build and data loading are not specified. NetHack expects generated headers,
data files, `sysconf`, `record`, save paths, locks, and runtime directories.
A Python extension build has to either reuse the normal NetHack build products
or carefully reproduce them.

The pybind11 sketch is premature. Exposing a C array as a NumPy view is a good
eventual optimization, but the first proof should establish the C window port,
game lifecycle, and observation/action contract before committing to Python ABI
and packaging details.

## Assessment of the Stdio Alternative

The stdio-oriented alternative is useful as a debugging or smoke-test idea, but
it is weak as the main NLE5 architecture.

Advantages:

- easier first build target;
- can be tested with ptys and subprocesses;
- useful for observing startup and prompt flow;
- overlaps with the historical `towel` window-port idea.

Limitations:

- loses structured glyph and status information;
- requires parsing text, redraws, and escape sequences;
- makes menus and prompts ambiguous;
- is slower and more brittle than direct callback capture;
- does not match the usual NLE observation model.

Recommendation: use stdio only as a stepping stone or diagnostic mode. The
real NLE5 bridge should be structured, callback-driven, and buffer-backed.

## Relationship to Towel

The `towel` branch is relevant background but not a base for NLE5.

Towel shows that a tiny NetHack window port can be registered and built, and it
has useful ideas around `stdio` and safe startup procedures. But it targets an
older NetHack branch, contains committed conflict markers, and is oriented
toward terminal I/O rather than structured observation/action buffers.

Best use of towel:

- reference for the minimum window-port skeleton;
- reminder to keep early startup callbacks safe;
- possible separate project to finish a simple NetHack 5.0.0 stdio port.

Avoid using towel as:

- the NLE5 implementation base;
- a direct patch source;
- the place to solve Python/Gymnasium embedding;
- a reason to make NLE5 terminal-parser based.

## Relationship to Nexus

NLE5 should remain separate from Nexus for now.

Nexus is about replacing NetHack world assumptions while preserving the engine.
NLE5 is about exposing NetHack through an automation and learning interface.
Those goals can help each other later, but mixing them now would combine
world/topology work with window-port, Python packaging, synchronization, and
automation concerns.

Possible future Nexus uses:

- deterministic smoke tests for booting a Nexus level;
- scripted traversal checks;
- map/status observation during verification;
- a non-player-facing automation window type.

Current recommendation:

- keep NLE5 implementation outside Nexus;
- keep Nexus notes in `_work/` only as cross-project assessment;
- do not add `win/nle` or Python bridge files to Nexus unless there is a
  concrete Nexus verification milestone that requires them.

## Recommended Milestones

1. C-only window-port skeleton.

   Add `win/nle/winnle.c` and a matching header against NetHack 5.0.0. Register
   `nle_procs` in `src/windows.c`. Stub most callbacks or delegate to generic
   helpers. Build a binary that accepts `windowtype:nle` and reaches startup
   without Python.

2. Minimal observation buffers.

   Capture visible map glyphs from `win_print_glyph`, status updates from
   `win_status_update`, and message text from `win_putstr`. Expose a simple C
   debug dump or internal assertion path before adding NumPy.

3. Action boundary.

   Implement `win_nhgetch` as a controlled input queue. Start with a fixed
   scripted action source or a test harness, not Python. Verify one movement
   command changes the observation.

4. Prompt and menu state.

   Record when NetHack is asking for yes/no input, line input, extended
   commands, or menu selection. A learning environment cannot treat all input
   as movement.

5. Lifecycle and reset.

   Define how a new episode starts, how death/quit/endgame is detected, how
   saves are disabled or isolated, and how RNG/runtime paths are controlled for
   repeatable tests.

6. Python bridge.

   Only after the C-side lifecycle works, choose between `ctypes`, CPython C
   API, CFFI, or pybind11. Pybind11 is reasonable if C++ is acceptable in the
   build, but it should not drive the C architecture.

7. Gymnasium wrapper.

   Wrap the stable bridge with `reset()`, `step()`, observation spaces, action
   spaces, termination/truncation semantics, and test fixtures.

## Suggested First Proof

A narrow first proof should avoid RL and focus on controllability:

```text
Build NetHack 5.0.0 with windowtype:nle
Start a new game non-interactively or with scripted startup answers
Capture a map glyph buffer and status buffer
Feed one movement key through the NLE input queue
Observe an updated buffer at the next input boundary
Exit cleanly
```

This proof is enough to validate the architecture without committing to the
final Python packaging or observation schema.

## Design Decisions to Make Early

- Is NetHack embedded in-process as a Python extension, or run as a controlled
  child process with shared memory or IPC?
- Is the game loop single-threaded with explicit callbacks, or does NetHack run
  on a worker thread blocked at `nhgetch`?
- Are observations raw NetHack glyph ids, rendered tty chars, semantic object
  ids, or multiple planes?
- Are save files, bones, scores, locks, and sysconf enabled, disabled, or
  redirected per environment instance?
- How are role selection and startup prompts controlled?
- What is the minimum action space for the first milestone?
- Does the first version support menus and inventory, or explicitly reject
  states that require them?

## Risk Register

- Thread deadlocks around `nhgetch` and prompt callbacks.
- Python extension build fighting NetHack's existing generated-file and data
  build process.
- Misleading observations if only `print_glyph` is captured and messages,
  menus, or prompts are ignored.
- Runtime data path failures when launched from Python rather than the normal
  installed NetHack layout.
- Save/lock/record file collisions across parallel environment instances.
- Overfitting the design to movement-only demos, then discovering menus and
  prompts require a different API.

## Bottom Line

The plan's core insight is correct: build a NetHack 5.0.0 window port for NLE5.
The next step should be a small C-side proof with structured buffers and a
controlled action queue. Python, Gymnasium, and zero-copy NumPy should come
after the window-port lifecycle and turn synchronization are proven.
