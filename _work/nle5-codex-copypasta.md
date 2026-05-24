# NLE 5 Codex Copypasta

I want to create an NLE-style Python environment for NetHack 5.0.0.

The goal is not to make old NLE agents ascend, preserve benchmark scores, or fully reproduce the original NLE task suite.

This project is parallel to Nexus. Nexus owns the NetHack 5 tiny-world engine/content fork. NLE5 owns the Python control/observation bridge. NLE5 may point at a Nexus checkout later, but Nexus should not depend on NLE5.

The goal is only to get a minimal control/observation bridge working:

- Python can reset the environment
- Python can send actions
- NetHack advances one step
- observations include glyphs/screen data, messages, status/blstats, and terminal/render output if available
- a random or scripted policy can run for a short rollout

Please inspect the repository and produce an engineering roadmap for the smallest working proof of concept. Prioritize:

1. how upstream NLE builds or vendors NetHack
2. where the C/C++/Cython/Python bridge lives
3. what assumptions are tied to NetHack 3.6.x
4. what must change for NetHack 5.0.0
5. what can be deferred
6. how to keep Nexus integration optional until both projects are independently viable
7. the first command that should compile or run

Do not start with RL training.
Do not start with ascension.
Do not broaden into gameplay design.
Do not make Nexus design or topology changes from this repository.
