# Upstream snapshots (not loaded by Chrome)

The four folders below are **unmodified copies** of [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3) (`upstream/master`). Do not edit them. Load unpacked uses `../extension/` only.

This fork’s notes live in `../AGENTS.md`. History is `git log`.

**Snapshot tip:** `350ed76` (2026-10-18 refresh — PR #13/#16/#17/#18/#19: mouse-over zones + zone helper, copy-selected-URLs, self-installing native, telemetry removed, gesture HUD).

## Original AutoControl docs (live site)

Alex’s GitHub Pages mirror of the old autocontrol.app manuals:

**https://alex-302.github.io/AutoControl_mv3/**

Do not use `www.autocontrol.app` — that domain was re-registered. The same site is snapshotted in `Docs/autocontrol.app-site/`.

## Upstream changelog

**https://github.com/Alex-302/AutoControl_mv3/blob/master/CHANGELOG.md**

## What’s in here

| Path | Upstream path | What |
| --- | --- | --- |
| `ext-mv2/` | `ext-mv2/` | Original Manifest V2 extension |
| `Docs/` | `Docs/` | Alex’s port notes and site snapshot |
| `AutoControl_native/` | `AutoControl_native/` | Native host: `original/` + patched engine v19 + zone helper |
| `Toolbar-buttons/` | `Toolbar-buttons/` | Separate toolbar-button builds |

### `AutoControl_native/` layout (after upstream 2026-09)

| Path | What |
| --- | --- |
| `original/AutoControlZero.exe` | Decrypted Zero (MD5 `FF33A86E…`) |
| `original/AutoCtrl_2025.4.22.0.exe` | Stock engine (MD5 `D9BE9A10…`) |
| `patched/AutoCtrl_2025.4.22.0.v19.exe` | Zone-table patched engine (Chrome 148+ hover regions) |
| `ac_zone_helper.exe` | Second native host — cursor zone classifier (no LL hooks) |
| `com.autocontrol.zonehelper.json` | Zone-helper host manifest template |
| `patches/` | Reproducible patch builder + notes |

Manual copy for a broken install still uses **`original/`**. This fork’s `extension/` ships v19 via `file76.dat` and the helper via `ac_zone_helper.dat` (SW syncs both into `%LocalAppData%\AutoControl\`).
