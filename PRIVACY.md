# Privacy policy — AutoControl MV3 (unofficial port)

This repository is an unofficial Manifest V3 port of the original AutoControl Chrome extension. It is not affiliated with the original AutoControl authors. The original site is dead; a documentation mirror lives at [alex-302.github.io/AutoControl_mv3](https://alex-302.github.io/AutoControl_mv3/).

This build is intended to be loaded unpacked from `mv3-build/`. It has not been submitted to the Chrome Web Store.

## What the extension does

AutoControl lets you bind keyboard shortcuts, mouse gestures, and other triggers to browser actions (open a URL, switch tabs, run a user script, and so on). Most of that input handling runs in a **local Windows native component** that Chrome starts via native messaging (`hrich.autocontrol`). The native binaries are the original AutoControl executables, embedded in the extension and installed to `%UserProfile%\AppData\Local\AutoControl\`.

## Data stored on your computer

- **Settings** (triggers, actions, scripts, options) live in Chrome `storage.local` and, if you turn on local file sync, in a settings file on disk.
- **Native host files** live under `%UserProfile%\AppData\Local\AutoControl\`.
- Nothing in this port creates an account or syncs settings to a cloud service we operate.

## What leaves your computer

- **By default, nothing.** Anonymous usage telemetry inherited from the original extension is **off** unless you enable **Options → Advanced Options → Send anonymous usage data**. When enabled, the original analytics endpoint may receive event counts (the same MV2 behavior).
- Optional **Run Script** / **ACtl** actions you write yourself may fetch URLs, write files, or send data — that is your script, not automatic telemetry.
- Opening a URL, saving a page, or talking to another extension (for example Tampermonkey) happens only when a trigger you configured runs that action.

## Permissions (why they exist)

| Permission / host | Why |
| --- | --- |
| Native messaging | Talk to the local AutoControl engine (hotkeys, gestures, SendInput, files). |
| Tabs / windows / scripting / userScripts | Read tab URLs so conditions and actions can target the right page; inject the script engine when you enable **Allow user scripts**. |
| `<all_urls>` | Triggers and scripts can run on sites you visit, including some `chrome://` pages for Open URL. |
| Optional: bookmarks, sessions, notifications, downloads | Requested only when an imported or created action needs them (reopen closed tab, save URL, and similar). |

Chrome also offers **Allow access to file URLs**. Leave it off unless you use local `file://` paths.

## What we do not do

- No login, advertising ID, or sale of browsing history.
- No remote update of your settings from this fork.
- The original AutoControl website is not used as a documentation or download source (it has been re-registered). Prefer the GitHub repo and the documentation mirror above.

## Contact

Issues and questions: [github.com/jotenbai/AutoControl_mv3](https://github.com/jotenbai/AutoControl_mv3). Community group (original project): [groups.google.com/g/autocontrol_app](https://groups.google.com/g/autocontrol_app).
