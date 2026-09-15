# AutoControl MV3 (unofficial port)

[English](#english) · [简体中文](#简体中文)

Unofficial Manifest V3 port of **AutoControl: Keyboard shortcuts, Mouse gestures**. The original extension ([Chrome Web Store ID `lkaihdpfpifdlgoapbfocpmekbokmcfd`](https://chromewebstore.google.com/detail/autocontrol-keyboard-shor/lkaihdpfpifdlgoapbfocpmekbokmcfd/)) was taken down; the original team stopped after Manifest V3. Docs mirror: [alex-302.github.io/AutoControl_mv3](https://alex-302.github.io/AutoControl_mv3/). Do not use the old website as a source — the domain was re-registered.

This fork ([jotenbai/AutoControl_mv3](https://github.com/jotenbai/AutoControl_mv3)) continues from [Alex-302/AutoControl_mv3](https://github.com/Alex-302/AutoControl_mv3). It is **not** the original product and is **not** on the Chrome Web Store.

---

## English

### Why use this

Chrome still cannot bind global hotkeys and mouse gestures the way AutoControl did. This port keeps that model: a small extension plus the **original Windows native engine**.

A practical difference versus other shortcut extensions: **Open URL works for `chrome://` pages** (History, Bookmarks, Extensions, …). Many extensions cannot open those URLs at all.

Keep the `mv3-build/` folder. Chrome loads **that directory**, not the repo root.

### Install (unpacked)

1. Clone or download this repository. Do not flatten `mv3-build/` into the repo root.
2. Open `chrome://extensions` → enable **Developer mode** → **Load unpacked** → select `mv3-build/`.
3. Open the extension. When the native-component pane appears, click **Install** and run the installer. The engine is unpacked from files already inside the extension (nothing is downloaded).
4. Details page (`chrome://extensions` → AutoControl → **Details**):
   - **Allow user scripts** — required for Run Script / ACtl.
   - **Allow access to file URLs** — only if you use local `file://` paths.
   - **Allowed in Incognito** — optional.

After a successful in-app Install you can delete `AutoControl_native/*.exe` from a zip download if you want disk space back. The extension does **not** read that folder; it deploys from `mv3-build/file69.dat` and `file76.dat`. Leave `mv3-build/` intact.

### Restore settings (Replace, not Add)

Toolbar icon → settings → restore **from file**.

That path **replaces** the current configuration. It does **not** merge/add. If you only want to add shared snippets from the old site, use Import / View on a settings page, not Restore.

Sample backup in this repo: [`My-AutoControl-Settings.acs`](My-AutoControl-Settings.acs) (middle-button gestures, 4 directions, plus a few chrome:// Open URL + switch-tab chains). The shipping defaults in the obfuscated UI remain **right-button / 8 directions** — this file is an example, not a new default.

### Native component

Hotkeys, gestures, SendInput, and most file I/O need the Windows host `hrich.autocontrol`:

- `AutoControlZero.exe` (proxy / installer) + `AutoCtrl_2025.4.22.0.exe` (engine)
- Installed under `%UserProfile%\AppData\Local\AutoControl\`
- Registry: `HKCU\SOFTWARE\Google\Chrome\NativeMessagingHosts\hrich.autocontrol`

If the pane never finishes: reload the extension; confirm both exes and `AutoControl.manifest` are in that folder; as a last resort copy `AutoControl_native\AutoCtrl_2025.4.22.0.exe` there and reload. Do **not** `taskkill /F` the engine to “fix” it — that can leave keyboard/mouse hooks stuck for ~40 seconds. Use **Emergency repair** on the toolbar context menu instead.

`AutoControl_native/` in the repo is the decrypted originals for antivirus review and manual copy. MD5 (decrypted): Zero `FF33A86EC873836A51CEC8F77B8C0B49`, engine `D9BE9A1099D70FAFCEB59EF22DA5B44A`.

### What this is (and is not)

- Most `file*.js` files are the original obfuscated MV2 logic (patched where the port requires it).
- New work lives in the service worker (`sw.js`), shims, offscreen document, and tests.
- Hover-region conditions are broken on Chrome 148+ (native accessibility hit-test; same in MV2). Do not rely on them.
- Contributors: `AGENTS.md`, `CHANGELOG.md`, `Docs/`. Developer zip of `mv3-build/` only: `.\package.ps1` (not an end-user install step). Privacy: [`PRIVACY.md`](PRIVACY.md).

---

## 简体中文

### 为什么用这个

Chrome 自己绑不了 AutoControl 那种全局快捷键和鼠标手势。本移植沿用原模型：扩展 + **原版 Windows 原生引擎**。

和多数快捷键扩展相比，这里有一个实际差别：**可以打开 `chrome://` 页面**（历史记录、书签、扩展程序等）。很多扩展根本打不开这些地址。

请保留 `mv3-build/` 目录。Chrome 加载的是**这个文件夹**，不是仓库根目录。

### 安装（加载已解压的扩展程序）

1. 克隆或下载本仓库。不要把 `mv3-build/` 里的文件摊到仓库根目录。
2. 打开 `chrome://extensions` → 打开**开发者模式** → **加载已解压的扩展程序** → 选中 `mv3-build/`。
3. 打开扩展。出现原生组件安装页时点 **Install** 并运行安装程序。引擎从扩展自带的文件解出，不会另外下载。
4. 详情页（`chrome://extensions` → AutoControl → **详细信息**）：
   - **允许用户脚本** — Run Script / ACtl 必需。
   - **允许访问文件网址** — 只用到本地 `file://` 时才开。
   - **在无痕模式下允许** — 可选。

应用内 Install 成功后，若你是从 zip 下的整仓库，可以删掉 `AutoControl_native/` 里的 exe 省空间。扩展**不会**读那个目录，部署来源是 `mv3-build/file69.dat` 和 `file76.dat`。`mv3-build/` 本身不要动。

### 还原设置（是替换，不是追加）

工具栏图标 → 设置 → **从文件还原**。

这条路径会**整份替换**当前配置，不会合并追加。只想加旧站点上的片段时，用设置页上的 Import / View，不要用还原。

仓库里的示例备份：[`My-AutoControl-Settings.acs`](My-AutoControl-Settings.acs)（中键手势、4 方向，以及若干 chrome:// 打开网址再切到右侧标签）。原版界面里的出厂默认仍是**右键 / 8 方向** — 该文件只是例子，不是新默认。

### 原生组件

快捷键、手势、SendInput、多数文件读写都依赖 Windows 宿主 `hrich.autocontrol`：

- `AutoControlZero.exe`（代理 / 安装器）+ `AutoCtrl_2025.4.22.0.exe`（引擎）
- 安装位置：`%UserProfile%\AppData\Local\AutoControl\`
- 注册表：`HKCU\SOFTWARE\Google\Chrome\NativeMessagingHosts\hrich.autocontrol`

安装页一直完不成：先重载扩展；确认该目录里两个 exe 和 `AutoControl.manifest` 都在；实在不行把 `AutoControl_native\AutoCtrl_2025.4.22.0.exe` 拷进去再重载。不要用 `taskkill /F` 杀引擎「修复」——全局钩子可能卡住键盘鼠标大约 40 秒。请用工具栏右键里的 **Emergency repair**。

仓库里的 `AutoControl_native/` 是解密后的原版文件，供杀毒对照和手动拷贝。解密 MD5：Zero `FF33A86EC873836A51CEC8F77B8C0B49`，引擎 `D9BE9A1099D70FAFCEB59EF22DA5B44A`。

### 这是什么（以及不是什么）

- 大部分 `file*.js` 仍是原版 MV2 混淆逻辑（移植需要处打了补丁）。
- 新代码在 Service Worker（`sw.js`）、shim、offscreen 和测试里。
- Chrome 148+ 的悬停区域条件失效（原生无障碍命中测试问题，MV2 一样）。不要依赖。
- 给协作者：`AGENTS.md`、`CHANGELOG.md`、`Docs/`。只打包 `mv3-build/` 的开发者 zip：`.\package.ps1`（不是给普通用户的安装步骤）。隐私：[`PRIVACY.md`](PRIVACY.md)。
