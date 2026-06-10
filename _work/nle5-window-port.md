# NLE Window Port

Converted from `_work/nle-window-port.pdf`.

Source note: the PDF appears to be a Firefox printout of a Google result or AI
overview, created on 2026-05-26. Several lines in the PDF are visually clipped,
especially headings and right-side annotations. This Markdown preserves the
recoverable technical content and removes browser headers, URLs, dates, and page
numbers.

## Original Query Context

The embedded Google search URL contains this query:

```text
you don't have the project context and all of that but I don't think you need it
you can probably figure it out I have a project I'm working on now that net hack
5 has come out I want to modify the net hack learning environment to work with
nethack 5 and I was thinking why don't we make our own window port for it please
discuss
```

## Core Idea

Use a custom NetHack 5 window port as the control and observation bridge.

Important NetHack window-port hooks:

- `window_procs`
- `putstr()`
- `print_glyph()`
- `curs()`
- action input through `nhgetch()`
- possible Python-facing bridge through `ctypes`, a C extension, or `pybind11`

High-level architecture:

```text
[NetHack 5.0 Core Engine]
          |
          v  (passes state via window_procs)
[Custom Window Port in C]
          |
          v  (C extension / pybind11)
[Python Gym / Gymnasium Wrapper] ---> [RL Agent]
```

Another view:

```text
[Python / Gymnasium]
          |
          v  (calls methods)
[Pybind11 Bridge]
          |
          v  (reads/writes memory pointers)
[NetHack Custom Window]
          |
          v  (in-memory execution)
[NetHack 5.0.0 Core]
```

The custom window port would sit in a NetHack source path such as:

```text
win/nle/winnle.c
```

or another port-specific source directory. Existing ports such as `win/tty/`
and `wintty.c` are useful references.

## Window Proc Table

The bridge depends on registering a NetHack window port through
`struct window_procs`.

```c
struct window_procs nle_procs = {
    "win_nle_init",
    nle_init_nhwindows,
    nle_player_selection,
    nle_askname,
    nle_get_nh_event,
    nle_exit_nhwindows,
    nle_suspend_nhwindows,
    nle_resume_nhwindows,
    nle_create_nhwindow,
    nle_clear_nhwindow,
    nle_display_nhwindow,
    nle_destroy_nhwindow,
    nle_curs,
    nle_putstr,
    nle_putmixed,
    nle_display_file,
    nle_start_menu,
    nle_add_menu,
    nle_end_menu,
    nle_select_menu,
    nle_message_menu,
    nle_mark_synch,
    nle_wait_synch,
    nle_cliparound,
    nle_print_glyph, /* CRITICAL: intercept map changes here */
    nle_raw_print,
    nle_raw_print_bold,
    nle_nhgetch,     /* CRITICAL: inject agent decisions here */
    nle_nh_poskey,
    nle_bell,
    nle_doprev_message,
    nle_yn_function,
    nle_getlin,
    nle_get_ext_cmd,
    nle_number_pad,
    nle_delay_output,
    /* ... remaining callbacks ... */
};
```

Two critical callbacks:

- `nle_print_glyph`: intercept map updates and copy glyphs into a 2D array.
- `nle_nhgetch`: block the NetHack loop until Python provides the next action.

## Map Observation Buffer

The map can be represented as a global C array owned by the custom window port.

```c
/* A global 2D array in C tracking the map glyphs. */
int nle_map_matrix[ROWNO][COLNO];

void nle_print_glyph(winid window, xchar x, xchar y, int glyph, int bkglyph) {
    /* Instead of drawing to a screen, save it directly to memory. */
    nle_map_matrix[y][x] = glyph;
}
```

The PDF also sketches a fixed NLE-like buffer shape:

```c
int gym_map[21][80];
int gym_blstats[26]; /* Bottom line statistics: HP, gold, level, etc. */

void nle_print_glyph(winid window, xchar x, xchar y, int glyph, int bkglyph) {
    if (window == WIN_MAP) {
        gym_map[y][x] = glyph; /* Save raw glyph ID for Gym. */
    }
}
```

## Status Observation Buffer

NetHack 5 status updates can be copied into a Gym observation tensor.

```c
void nle_status_update(int idx, long val, const char *text) {
    /* NetHack 5.0 explicitly passes status changes through index IDs. */
    gym_blstats[idx] = (int) val;
}
```

The intended Python observation space is a `gym.spaces.Dict`, likely containing
at least:

- `map`
- `blstats`
- later: message text and other UI state

## Pybind11 Bridge Sketch

A C++ bridge can expose the C buffers and game controls to Python.

```
#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>

extern "C" {
    /* Tell C++ to look at the global variables in your C window port. */
    extern int nle_map_matrix[21][80];
    extern void nethack_init_game();
    extern void nethack_send_action(char action);
}

namespace py = pybind11;

PYBIND11_MODULE(nle_c_api, m) {
    m.doc() = "NetHack 5.0.0 low-level C bridge for NLE";

    /* Expose the game loop step. */
    m.def("send_action", &nethack_send_action, "Send a keypress to Nethack");

    /* Expose the map directly as a zero-copy NumPy array to Python. */
    m.def("get_map", []() {
        return py::array_t<int>(
            {21, 80},                         /* shape */
            {80 * sizeof(int), sizeof(int)},  /* strides */
            &nle_map_matrix[0][0]             /* raw C memory */
        );
    });
}
```

## Build Sketch

The PDF suggests using `setuptools` with `pybind11`.

```python
from setuptools import setup
from pybind11.setup_helpers import Pybind11Extension, build_ext

ext_modules = [
    Pybind11Extension(
        "nle.nle_c_api",
        ["win/nle/winnle.c", "win/nle/bridge.cpp"],
        include_dirs=["include", "src"],
    ),
]

setup(
    name="nle_nh5",
    ext_modules=ext_modules,
    cmdclass={"build_ext": build_ext},
)
```

Possible outputs mentioned:

- `.so`
- `.dylib`
- `.dll`

NetHack shared data may still need to be found through locations such as
`sys/share` or the NetHack runtime directory layout.

## Gymnasium Environment Sketch

```python
import gymnasium as gym
import nle_c_api


class NetHackv5Env(gym.Env):
    def __init__(self):
        super().__init__()
        self.action_space = gym.spaces.Discrete(4)
        self.observation_space = gym.spaces.Box(
            low=0,
            high=MAX_GLYPH,
            shape=(21, 80),
        )

    def step(self, action):
        # Convert index to NetHack movement keys: k, j, h, l.
        key_map = {0: b"k", 1: b"j", 2: b"h", 3: b"l"}

        # Pass action down across the bridge into the C engine.
        nle_c_api.send_action(key_map[action])

        # Read the updated map memory space as a NumPy array.
        obs = nle_c_api.get_map()

        reward = self._calculate_reward()
        terminated = self._check_if_dead()

        return obs, reward, terminated, False, {}
```

## Turn Synchronization

The control flow is:

```text
[NetHack C Engine]      [Custom Window Port C]        [Gym Environment]
        |                         |                          |
        |-- changes map --------->|                          |
        |                         |-- copies map to array -->|
        |-- asks for key -------->|                          |
        |                         |-- blocks C loop -------->|
        |                         |                          |
        |                         |<-- Python passes key ----|
        |<-- returns key code ----|                          |
```

The PDF sketches a simple busy-wait version:

```c
volatile int python_has_provided_action = 0;
volatile char agent_chosen_action = 0;

int nle_nhgetch(void) {
    /* Tell Python the current turn's observation data is complete. */
    python_has_provided_action = 0;

    /* Block the C engine thread until Python calls env.step(). */
    while (!python_has_provided_action) {
        /*
         * In production, use standard thread condition variables/mutexes
         * to prevent high CPU utilization during this idle wait loop.
         */
    }

    /* Hand the chosen keypress back to NetHack. */
    return agent_chosen_action;
}
```

Python side:

```python
def step(self, action_idx):
    # Translate a discrete Gym action into a NetHack key.
    nethack_key = self.action_to_key_map[action_idx]

    # Push the key across the bridge and unblock C.
    my_compiled_c_bridge.set_agent_action(nethack_key)

    # Read the newly updated memory buffers as the Gym observation.
    obs = {
        "map": my_compiled_c_bridge.get_gym_map_pointer(),
        "blstats": my_compiled_c_bridge.get_gym_blstats_pointer(),
    }

    reward = self.calculate_reward(obs)
    done = self.check_if_dead(obs)

    return obs, reward, done, False, {}
```

Implementation note: the busy-wait version is only a sketch. A real bridge
should use a mutex/condition variable or another clear blocking primitive.

## Stdio-Oriented Alternative

The PDF also sketches a more text-stream-oriented path based on `stdio` rather
than a full glyph/status window port.

Concepts mentioned:

- `stdio`
- `nhgetch()`
- escape sequences such as `\033[H`
- `curses`
- `putstr`
- `raw_print`
- `printf`
- `putchar`
- `subprocess`
- `stdout.read()`
- `stdin.write()`

This approach would append printed text to a buffer, expose that buffer to
Python, and reset it when `nhgetch()` asks for the next command.

```c
#define BUFFER_SIZE 8192

char gym_stream_buffer[BUFFER_SIZE];
int buffer_index = 0;

void stdio_putstr(winid window, int attr, const char *str) {
    /* Keep original stdio logic if useful for terminal debugging. */
    /* printf("%s\n", str); */

    /* Append text into the Gym stream buffer. */
    int len = strlen(str);
    if (buffer_index + len + 1 < BUFFER_SIZE) {
        strcpy(&gym_stream_buffer[buffer_index], str);
        buffer_index += len;
        gym_stream_buffer[buffer_index++] = '\n';
        gym_stream_buffer[buffer_index] = '\0';
    }
}
```

At the next `nhgetch()` boundary:

```c
buffer_index = 0;
```

A text-only Gymnasium wrapper could expose `gym.spaces.Text`.

```python
import gymnasium as gym


class NetHackStdioEnv(gym.Env):
    def __init__(self):
        super().__init__()
        self.observation_space = gym.spaces.Text(max_length=8192)
        self.action_space = gym.spaces.Discrete(4)

    def step(self, action):
        # Map action to stdin key strings: k, j, etc.
        nethack_key = self.action_map[action]

        # Push across the bridge to unblock nhgetch().
        my_bridge.send_stdin_key(nethack_key)

        # Read accumulated stdio text buffer directly from memory.
        raw_text_obs = my_bridge.get_stream_buffer()

        return raw_text_obs, self._get_reward(), self._is_done(), False, {}
```

## Floating Eye `towel` Branch Reference

The local Floating Eye reference was found in `../nethack`, whose current
checkout is `floatingeye`; the requested branch is named `towel`. There was no
separate `../floatingeye` checkout under `/home/mlehotay/projects`.

After excluding the upstream NetHack 3.7 merge, `towel` is a narrow historical
window-port experiment. Its relevant changes are concentrated in:

- `win/stdio/winstdio.c`
- `win/stdio/winstdio.h`
- `win/share/safeproc.c`
- `include/config.h`
- `include/winprocs.h`
- `src/windows.c`
- `src/cmd.c`
- `sys/unix/Makefile.src`
- `sys/unix/unixmain.c`
- `win/chain/wc_chain*.c`

Useful ideas from `towel`:

- It demonstrates a small `stdio` window port registered through
  `struct window_procs`.
- It wires a new `STDIO_GRAPHICS` option into the window selection table.
- It uses `safeproc.c` as an early-startup fallback window-proc table so
  startup paths have non-null window callbacks.
- It confirms that a minimal port can delegate many callbacks to generic or
  safe implementations while implementing only the needed I/O boundary.
- It reinforces the same control points identified above: `print_glyph`,
  `status_update`, and `nhgetch`.

Do not use `towel` as an implementation base for NLE5:

- The branch contains committed merge-conflict markers in `include/winprocs.h`,
  `sys/unix/Makefile.src`, and `win/chain/wc_trace.c`.
- It targets older NetHack 3.7-era code, while NLE5 is about NetHack 5.0.0.
- Its `win/stdio` port is a terminal/stdin/stdout proof-of-concept, not an
  observation/action bridge for Gymnasium.
- It prints tty characters and reads from `stdin`; it does not maintain
  structured map, status, message, or synchronization buffers.
- The Makefile changes include unrelated or stale conflict context and should
  not be copied forward.

Recommendation: treat `towel` as background reading only. For NLE5, start from
the current NetHack 5 `window_procs` structure and build a fresh, deliberately
small NLE window port or chain processor. Reuse the concept of a minimal port
and safe startup callbacks, but not the `towel` code itself.

## Practical Takeaways for NLE5

- The most direct NLE-style route is a NetHack 5 custom window port, not a
  subprocess terminal parser.
- `print_glyph` is the natural interception point for map glyphs.
- status update callbacks are the natural interception point for `blstats`.
- `nhgetch` is the natural action-injection boundary.
- Python should receive observations from C-owned buffers, ideally as NumPy
  arrays without copying.
- For a first milestone, only a small action set and a minimal observation dict
  are needed.
- The synchronization mechanism must be made explicit before this can be robust.
- The `towel` branch is useful as historical evidence that a tiny window port is
  feasible, but it should not be imported or used as the base for the NetHack 5
  NLE bridge.
