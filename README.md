# AutoControl_mv3 (unofficial port)

[English](#english) · [简体中文](#简体中文)

Unofficial Manifest V3 port of the old **AutoControl** extension (original store ID [`lkaihdpfpifdlgoapbfocpmekbokmcfd`](https://chromewebstore.google.com/detail/autocontrol-keyboard-shor/lkaihdpfpifdlgoapbfocpmekbokmcfd/)). This fork is named **AutoControl_mv3** so it is not an update of that listing. Docs mirror: [alex-302.github.io/AutoControl_mv3](https://alex-302.github.io/AutoControl_mv3/). If that site is gone, use [`reference/Docs/autocontrol.app-site/`](reference/Docs/autocontrol.app-site/). Do not use the old website — the domain was re-registered.

Repo: [jotenbai/AutoControl_mv3](https://github.com/jotenbai/AutoControl_mv3). Chrome Web Store draft ID: [`ifjogpfnljedincfpelmhaljnllegckm`](https://chromewebstore.google.com/detail/ifjogpfnljedincfpelmhaljnllegckm) (link works after the listing is public). Privacy: [`webstore/privacy.md`](webstore/privacy.md).

---

## English

### Why use this

Chrome cannot remap its own global shortcuts or add mouse gestures. AutoControl does both, plus Run Script, using a small extension and the **original Windows native engine** (Windows only). **AutoControl is to Chrome what [AutoHotkey](https://www.autohotkey.com/) is to Windows.**

The bigger difference versus other shortcut extensions: your shortcuts and gestures still **work on Chrome’s own pages** (`chrome://` — History, Bookmarks, Extensions, …). Ordinary extensions run inside the page, and Chrome blocks them on those URLs. AutoControl sees keys and mouse in a **Windows native engine** outside Chrome, then tells the extension what to do — so `chrome://` never has to host the extension.

Run Script is different: Chrome still forbids running scripts **inside** `chrome://` and the Web Store (same as Tampermonkey). A background script can still call ACtl while you are on those pages, but it cannot read or change the page itself. The options UI already has samples such as **Example 1: Download all images** — try them on a normal `https` page with **Allow user scripts** on.

The Chrome Web Store listing is only so people can install it easily. If it infringes the original AutoControl authors’ rights, it will be taken down.

### Install (Chrome Web Store — preferred)

1. Install **AutoControl_mv3** from the Chrome Web Store _(public link after review: `https://chromewebstore.google.com/detail/ifjogpfnljedincfpelmhaljnllegckm`)_.
2. Open the extension → **Install** the native component → run the installer.
3. If hotkeys do nothing and Chrome says the native host is **forbidden**, save and run `Allow-AutoControl_mv3-native.bat` (the extension offers it), then **reload** the extension.
4. `chrome://extensions` → AutoControl_mv3 → **Details**:
   - **Allow user scripts** — required for Run Script / ACtl.
   - **Allow access to file URLs** — only for local `file://` paths.
   - **Allow in Incognito** — only if you want it in incognito windows.

Usage data and logs are **off** by default. Turn them on in **Extension options → Advanced Options** (`Send anonymous usage data`, `Log service worker`) if you need them.

### Install (unpacked — fallback)

Keep the `extension/` folder. Chrome loads **that directory**, not the repo root.

1. Clone or download this repository.
2. `chrome://extensions` → **Developer mode** → **Load unpacked** → `extension/`.
3. Native **Install** as above. Unpacked still ships the original `key`, so this machine keeps the old native-host ID until you switch to the store public key.

After in-app Install you can delete `reference/AutoControl_native/*.exe` from a git checkout. The extension deploys from `extension/file69.dat` and `file76.dat`.

Developers packaging a store ZIP: `.\package.ps1` (strips the original `key`, includes `_locales`). Not an end-user install step.

### Built-in shortcuts (first install)

These are **only the defaults**. Change or delete any of them in **Extension options**. They use the **middle mouse button** and **4 directions** (the original AutoControl default was right button / 8).

The native engine **blocks** that button while a gesture can start. Chrome’s middle-click autoscroll and canvas-pan in apps like Figma then stop working. If you use those often, change **Mouse gestures → Perform with**. Right button is the usual alternative; a context menu may flash and then close after the command. Side buttons are often Back/Forward, and some mice have none. Ctrl needs the other hand.

Several of these match Chrome’s own shortcuts; the rest keep the same job but change **where** the new tab appears.

**Mouse gestures** (hold middle button, drag, release):

| Gesture | Same idea as                     | Difference                                                  |
| ------- | -------------------------------- | ----------------------------------------------------------- |
| ↑       | Ctrl+Shift+T (reopen closed tab) | None                                                        |
| ↓       | F11 (fullscreen)                 | None                                                        |
| ←       | Ctrl+H (History)                 | Opens **to the right of the current tab** (Chrome does not) |
| →       | Ctrl+Shift+O (Bookmarks)         | Opens **to the right of the current tab** (Chrome does not) |

**Keyboard:**

| Shortcut | Same idea as      | Difference                                                                                                       |
| -------- | ----------------- | ---------------------------------------------------------------------------------------------------------------- |
| Ctrl+Tab | Chrome’s Ctrl+Tab | Switches to the **previously used** tab, not the next one on the strip                                           |
| Ctrl+T   | Chrome’s Ctrl+T   | New tab to the **right** of the current tab, not at the far end                                                  |
| Alt+E    | —                 | Opens `chrome://extensions` to the **right** of the current tab                                                  |
| Alt+T    | —                 | Opens the Tampermonkey dashboard to the **right** of the current tab (change the URL if you use another manager) |

**Extension options** → Options → Restore from file still **replaces** the whole configuration if you have a `.acs` backup. Import / View on a settings page **adds** snippets. Existing profiles are not overwritten when the extension updates.

### Native component

Hotkeys, gestures, SendInput, and most file I/O need the Windows host `hrich.autocontrol`:

- `AutoControlZero.exe` (proxy / installer) + `AutoCtrl_2025.4.22.0.exe` (engine)
- Installed under `%UserProfile%\AppData\Local\AutoControl\`
- Registry: `HKCU\SOFTWARE\Google\Chrome\NativeMessagingHosts\hrich.autocontrol`

If the pane never finishes: reload the extension; confirm both exes and `AutoControl.manifest` are in that folder; as a last resort copy `reference/AutoControl_native\AutoCtrl_2025.4.22.0.exe` there and reload. Do **not** `taskkill /F` the engine to “fix” it — that can leave keyboard/mouse hooks stuck for ~40 seconds. Use **Emergency repair** on the toolbar context menu instead. The badge goes **Wait → OK** or **Error**. If a popup lists stuck keys, those were held at repair time.

`reference/AutoControl_native/` in the repo is the decrypted originals for antivirus review and manual copy. MD5 (decrypted): Zero `FF33A86EC873836A51CEC8F77B8C0B49`, engine `D9BE9A1099D70FAFCEB59EF22DA5B44A`.

### What’s in this repo

| Path                          | What                                                                                                         |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `extension/`                  | Load this as unpacked. Also the source `package.ps1` zips.                                                   |
| `webstore/`                   | Store listing copy (description, privacy, permission text). Not in the ZIP.                                  |
| `reference/`                  | Unmodified snapshot of [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3). Do not edit. |
| `Test/`                       | In-browser API test and CDP helpers.                                                                         |
| `AGENTS.md`                   | Working notes for people changing the port.                                                                  |
| `extension/defaults.acs`      | First-install sample actions (packed with the extension).                                                    |

### What this is (and is not)

- Unofficial port of the features people use every day. It is **not** a promise that every original AutoControl feature works; Manifest V3 cannot copy the old extension 1:1.
- Most `file*.js` files are the original obfuscated MV2 logic (patched where the port requires it).
- New work lives in the service worker (`sw.js`), shims, offscreen document, and tests.
- Hover-region conditions are broken on Chrome 148+ (native accessibility hit-test; same in MV2). Do not rely on them.

### Acknowledgements

- The original **AutoControl** authors, who published as [autocontrol.app](https://www.autocontrol.app/) (the site is no longer a documentation source). The product was **not open source**; I could not find a public GitHub account. Native host name: `hrich.autocontrol`. Community: [autocontrol_app](https://groups.google.com/g/autocontrol_app).
- **[Alex-302](https://github.com/Alex-302)** for the unofficial MV3 port this fork is based on: [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3).

---

## 简体中文

[English](#english)

### 为什么用这个

Chrome 自己改不了全局快捷键，也加不了鼠标手势。AutoControl 用扩展加上**原版 Windows 原生引擎**来做这些，还可以 Run Script。只支持 Windows。**Chrome 上的 AutoControl，可以类比 Windows 上的 [AutoHotkey](https://www.autohotkey.com/)。**

更关键的是：快捷键和手势在 Chrome 自带页面（`chrome://`，例如历史记录、书签、扩展程序）上也能生效。普通扩展跑在网页里面，Chrome 在这些地址上不允许它们运行。AutoControl 用 **Windows 原生引擎**在 Chrome 外面看键盘和鼠标，再通知扩展做事，所以不需要 `chrome://` 页面里装着扩展。

Run Script 不是一回事：Chrome **禁止**在 `chrome://` 和网上应用店里跑脚本（和 Tampermonkey 一样）。后台脚本在这些页面上仍能调用 ACtl，但不能读、改页面本身。扩展程序选项里已有示例，例如 **Example 1: Download all images**——打开 **允许用户脚本**，在普通 `https` 页上试。

放到网上应用店只是为了方便大家安装。如果对 AutoControl 原开发团队构成侵权，会下架。

### 安装（Chrome 网上应用店 — 推荐）

1. 从网上应用店安装 **AutoControl_mv3**（公开后：`https://chromewebstore.google.com/detail/ifjogpfnljedincfpelmhaljnllegckm`）。
2. 打开扩展 → **Install** 原生组件 → 运行安装程序。
3. 若快捷键没反应，且提示 native host **forbidden**，保存并运行 `Allow-AutoControl_mv3-native.bat`，然后**重载**扩展。
4. `chrome://extensions` → AutoControl_mv3 → **详细信息**：
   - **允许用户脚本** — Run Script / ACtl 必需。
   - **允许访问文件网址** — 只用到本地 `file://` 时才开。
   - **在隐身模式下启用** — 只在隐身窗口也要用时才开。

用量统计和日志**默认关闭**。需要时在 **扩展程序选项 → Advanced Options** 打开 `Send anonymous usage data`、`Log service worker`。

### 安装（加载已解压 — 备用）

请保留 `extension/`。Chrome 加载的是**这个文件夹**，不是仓库根目录。

1. 克隆或下载本仓库。
2. `chrome://extensions` → **开发者模式** → **加载已解压的扩展程序** → `extension/`。
3. 同样在扩展里 Install 原生组件。解压版仍带原版 `key`，本机 ID 暂时还是原版那个，直到你换成商店公钥。

应用内 Install 成功后，git 检出里的 `reference/AutoControl_native/*.exe` 可以删。扩展从 `extension/file69.dat` 和 `file76.dat` 部署。

开发者打商店 ZIP：`.\package.ps1`（会去掉原版 `key`，打进 `_locales`）。不是给普通用户的安装步骤。

### 预装快捷键（首次安装）

这些**只是默认设置**，可在 **扩展程序选项** 里随意改或删。手势是**中键**、**4 方向**（原版默认是右键 / 8 方向）。

手势待命时，原生引擎会**拦住**这颗键。Chrome 的中键自动滚动，以及 Figma 一类画布里用中键拖着平移，都会失效。如果经常用这些，到 **Mouse gestures → Perform with** 改触发键。右键是最常见的替代，命令触发后右键菜单可能会闪一下再关掉。侧键本身多半是前进/后退，而且有的鼠标没有。Ctrl 还要另一只手按键盘。

有几条和 Chrome 自带快捷键是同一件事；其余功能相同，但**新标签出现的位置**不同。

**鼠标手势**（按住中键拖、松开）：

| 手势 | 相当于                               | 差异                                          |
| ---- | ------------------------------------ | --------------------------------------------- |
| ↑    | Ctrl+Shift+T（重新打开刚关闭的标签） | 无                                            |
| ↓    | F11（全屏）                          | 无                                            |
| ←    | Ctrl+H（History）                    | 在当前标签**右侧**打开（Chrome 不会开在右侧） |
| →    | Ctrl+Shift+O（Bookmarks）            | 在当前标签**右侧**打开（Chrome 不会开在右侧） |

**键盘：**

| 快捷键   | 相当于             | 差异                                                                     |
| -------- | ------------------ | ------------------------------------------------------------------------ |
| Ctrl+Tab | Chrome 的 Ctrl+Tab | 切到**上次用的**标签，不是标签条上的下一个                               |
| Ctrl+T   | Chrome 的 Ctrl+T   | 在当前标签**右侧**新建，不是甩到最右边                                   |
| Alt+E    | —                  | 在当前标签**右侧**打开 `chrome://extensions`                             |
| Alt+T    | —                  | 在当前标签**右侧**打开 Tampermonkey 面板（用别的脚本管理器就改这个网址） |

**扩展程序选项** → Options → Restore from file 仍会**整份替换**配置，只在你有 `.acs` 备份时用。设置页上的 Import / View 是**追加**片段。扩展更新不会覆盖你已经有的动作。

### 原生组件

快捷键、手势、SendInput、多数文件读写都依赖 Windows 宿主 `hrich.autocontrol`：

- `AutoControlZero.exe`（代理 / 安装器）+ `AutoCtrl_2025.4.22.0.exe`（引擎）
- 安装位置：`%UserProfile%\AppData\Local\AutoControl\`
- 注册表：`HKCU\SOFTWARE\Google\Chrome\NativeMessagingHosts\hrich.autocontrol`

安装页一直完不成：先重载扩展；确认该目录里两个 exe 和 `AutoControl.manifest` 都在；实在不行把 `reference/AutoControl_native\AutoCtrl_2025.4.22.0.exe` 拷进去再重载。不要用 `taskkill /F` 杀引擎「修复」——全局钩子可能卡住键盘鼠标大约 40 秒。请用工具栏右键里的 **Emergency repair**。图标徽章会 **Wait → OK** 或 **Error**。若弹出卡住的键，那是修理当时按着的键。

仓库里的 `reference/AutoControl_native/` 是解密后的原版文件，供杀毒对照和手动拷贝。解密 MD5：Zero `FF33A86EC873836A51CEC8F77B8C0B49`，引擎 `D9BE9A1099D70FAFCEB59EF22DA5B44A`。

### 仓库里有什么

| 路径                          | 用途                                                                                       |
| ----------------------------- | ------------------------------------------------------------------------------------------ |
| `extension/`                  | 加载已解压时选这里；`package.ps1` 也只打这个目录                                           |
| `webstore/`                   | 商店文案（说明、隐私、权限理由），不打进 ZIP                                               |
| `reference/`                  | [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3) 的未改快照，不要改 |
| `Test/`                       | 页内 API 自测和 CDP 脚本                                                                   |
| `AGENTS.md`                   | 给改移植代码的人看的工作笔记                                                               |
| `extension/defaults.acs`      | 首次安装写入的示例动作（打进扩展包）                                                       |

### 这是什么（以及不是什么）

- 非官方移植，瞄准日常常用功能。**不保证**原版 AutoControl 的每一项都能用；Manifest V3 也无法 1:1 复刻旧扩展。
- 大部分 `file*.js` 仍是原版 MV2 混淆逻辑（移植需要处打了补丁）。
- 新代码在 Service Worker（`sw.js`）、shim、offscreen 和测试里。
- Chrome 148+ 的悬停区域条件失效（原生无障碍命中测试问题，MV2 一样）。不要依赖。

### 致谢

- 原版 **AutoControl** 作者，当时以 [autocontrol.app](https://www.autocontrol.app/) 署名（该站已不能当文档源）。产品**并未开源**，也找不到公开的 GitHub 账号。原生宿主名：`hrich.autocontrol`。社区：[autocontrol_app](https://groups.google.com/g/autocontrol_app)。
- **[Alex-302](https://github.com/Alex-302)** 做了非官方 MV3 移植，本 fork 基于 [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3)。
