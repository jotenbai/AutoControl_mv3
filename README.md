# AutoControl_mv3 (unofficial port)

[English](#english) · [简体中文](#简体中文)

Unofficial Manifest V3 port of the old **AutoControl** extension (original store ID [`lkaihdpfpifdlgoapbfocpmekbokmcfd`](https://chromewebstore.google.com/detail/autocontrol-keyboard-shor/lkaihdpfpifdlgoapbfocpmekbokmcfd/)). This fork is named **AutoControl_mv3** so it is not an update of that listing. Docs mirror: [alex-302.github.io/AutoControl_mv3](https://alex-302.github.io/AutoControl_mv3/). Do not use the old website — the domain was re-registered.

Repo: [jotenbai/AutoControl_mv3](https://github.com/jotenbai/AutoControl_mv3). Chrome Web Store draft ID: [`ifjogpfnljedincfpelmhaljnllegckm`](https://chromewebstore.google.com/detail/ifjogpfnljedincfpelmhaljnllegckm) (link works after the listing is public). Privacy: [`webstore/privacy.md`](webstore/privacy.md).

---

## English

### Why use this

**AutoControl is to Chrome what [PowerToys Keyboard Manager](https://learn.microsoft.com/windows/powertoys/keyboard-manager) is to Windows:** Chrome itself cannot remap its own global shortcuts or add mouse gestures the way AutoControl did. This port keeps that model — a small extension plus the **original Windows native engine**.

A practical difference versus other shortcut extensions: **Open URL works for `chrome://` pages** (History, Bookmarks, Extensions, …).

The Chrome Web Store listing is only so people can install it in one click. This fork is not a product, not a brand, and is not listed for fame or profit.

### Install (Chrome Web Store — preferred)

1. Install **AutoControl_mv3** from the Chrome Web Store _(public link after review: `https://chromewebstore.google.com/detail/ifjogpfnljedincfpelmhaljnllegckm`)_.
2. Open the extension → **Install** the native component → run the installer.
3. If hotkeys do nothing and Chrome says the native host is **forbidden**, save and run `Allow-AutoControl_mv3-native.bat` (the extension offers it), then **reload** the extension.
4. `chrome://extensions` → AutoControl_mv3 → **Details**:
   - **Allow user scripts** — required for Run Script / ACtl.
   - **Allow access to file URLs** — only for local `file://` paths.

### Install (unpacked — fallback)

Keep the `extension/` folder. Chrome loads **that directory**, not the repo root.

1. Clone or download this repository.
2. `chrome://extensions` → **Developer mode** → **Load unpacked** → `extension/`.
3. Native **Install** as above. Unpacked still ships the original `key`, so this machine keeps the old native-host ID until you switch to the store public key.

After in-app Install you can delete `reference/AutoControl_native/*.exe` from a git checkout. The extension deploys from `extension/file69.dat` and `file76.dat`.

Developers packaging a store ZIP: `.\package.ps1` (strips the original `key`, includes `_locales`). Not an end-user install step.

### Built-in shortcuts (first install)

These are **only the defaults**. Change or delete any of them in **Extension options**. They use the **middle mouse button** and **4 directions** (the original AutoControl default was right button / 8).

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

If the pane never finishes: reload the extension; confirm both exes and `AutoControl.manifest` are in that folder; as a last resort copy `reference/AutoControl_native\AutoCtrl_2025.4.22.0.exe` there and reload. Do **not** `taskkill /F` the engine to “fix” it — that can leave keyboard/mouse hooks stuck for ~40 seconds. Use **Emergency repair** on the toolbar context menu instead.

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

**AutoControl 之于 Chrome，就像 [PowerToys 键盘管理器](https://learn.microsoft.com/zh-cn/windows/powertoys/keyboard-manager) 之于 Windows：** Chrome 自己绑不了原版那种全局快捷键和鼠标手势。本移植沿用：扩展 + **原版 Windows 原生引擎**。

和多数快捷键扩展相比，这里可以**打开 `chrome://` 页面**（历史记录、书签、扩展程序等）。

放到网上应用店，只是图个安装方便，不是卖东西，也不是为了出名赚钱。

### 安装（Chrome 网上应用店 — 推荐）

1. 从网上应用店安装 **AutoControl_mv3**（公开后：`https://chromewebstore.google.com/detail/ifjogpfnljedincfpelmhaljnllegckm`）。
2. 打开扩展 → **Install** 原生组件 → 运行安装程序。
3. 若快捷键没反应，且提示 native host **forbidden**，保存并运行 `Allow-AutoControl_mv3-native.bat`，然后**重载**扩展。
4. `chrome://extensions` → AutoControl_mv3 → **详细信息**：
   - **允许用户脚本** — Run Script / ACtl 必需。
   - **允许访问文件网址** — 只用到本地 `file://` 时才开。

### 安装（加载已解压 — 备用）

请保留 `extension/`。Chrome 加载的是**这个文件夹**，不是仓库根目录。

1. 克隆或下载本仓库。
2. `chrome://extensions` → **开发者模式** → **加载已解压的扩展程序** → `extension/`。
3. 同样在扩展里 Install 原生组件。解压版仍带原版 `key`，本机 ID 暂时还是原版那个，直到你换成商店公钥。

应用内 Install 成功后，git 检出里的 `reference/AutoControl_native/*.exe` 可以删。扩展从 `extension/file69.dat` 和 `file76.dat` 部署。

开发者打商店 ZIP：`.\package.ps1`（会去掉原版 `key`，打进 `_locales`）。不是给普通用户的安装步骤。

### 预装快捷键（首次安装）

这些**只是默认设置**，可在 **扩展程序选项** 里随意改或删。手势是**中键**、**4 方向**（原版默认是右键 / 8 方向）。

有几条和 Chrome 自带快捷键是同一件事；其余功能相同，但**新标签出现的位置**不同。

**鼠标手势**（按住中键拖、松开）：·

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

安装页一直完不成：先重载扩展；确认该目录里两个 exe 和 `AutoControl.manifest` 都在；实在不行把 `reference/AutoControl_native\AutoCtrl_2025.4.22.0.exe` 拷进去再重载。不要用 `taskkill /F` 杀引擎「修复」——全局钩子可能卡住键盘鼠标大约 40 秒。请用工具栏右键里的 **Emergency repair**。

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

- 大部分 `file*.js` 仍是原版 MV2 混淆逻辑（移植需要处打了补丁）。
- 新代码在 Service Worker（`sw.js`）、shim、offscreen 和测试里。
- Chrome 148+ 的悬停区域条件失效（原生无障碍命中测试问题，MV2 一样）。不要依赖。

### 致谢

- 原版 **AutoControl** 作者，当时以 [autocontrol.app](https://www.autocontrol.app/) 署名（该站已不能当文档源）。产品**并未开源**，也找不到公开的 GitHub 账号。原生宿主名：`hrich.autocontrol`。社区：[autocontrol_app](https://groups.google.com/g/autocontrol_app)。
- **[Alex-302](https://github.com/Alex-302)** 做了非官方 MV3 移植，本 fork 基于 [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3)。
