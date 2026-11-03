# Patch AutoControlZero.exe so installNativeHost() writes the Chrome Web Store
# origin into AutoControl.manifest allowed_origins.
#
# RE (2026-11-01): the 14 chrome-extension:// strings exist ONLY to build that
# manifest. There is no runtime origin strcmp in the messaging loop. Replacing
# ONE companion slot (never the original lkaihd… ID) makes Install emit the
# store ID. Keep Load-unpacked (lkaihd…) working.
#
# Usage:
#   .\tools\patch-zero-cws-origin.ps1
#   .\tools\patch-zero-cws-origin.ps1 -ApplyInstalled
#   .\tools\patch-zero-cws-origin.ps1 -In "C:\path\AutoControlZero.exe" -Out "C:\path\out.exe"
#
# After -ApplyInstalled: reload the STORE extension only (no Load-unpacked in
# the same profile), open Options → re-run Native Install / Repair so Zero
# rewrites AutoControl.manifest, then check allowed_origins contains ifjogpfn…

[CmdletBinding()]
param(
  [string] $In = "",
  [string] $Out = "",
  [switch] $ApplyInstalled
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

$defaultIn = Join-Path $repo "reference\AutoControl_native\original\AutoControlZero.exe"
$defaultOutDir = Join-Path $repo "tools\patched"
$defaultOut = Join-Path $defaultOutDir "AutoControlZero.exe"
$installed = Join-Path $env:LOCALAPPDATA "AutoControl\AutoControlZero.exe"

# Companion slot (last in installNativeHost's list). Do NOT touch lkaihd….
$fromId = "baikhopphokjmcllncdeocblfpeaklnj"
$toId   = "ifjogpfnljedincfpelmhaljnllegckm"   # CWS draft/store ID
$from = "chrome-extension://$fromId/"
$to   = "chrome-extension://$toId/"

if ($from.Length -ne $to.Length) {
  throw "Origin length mismatch: from=$($from.Length) to=$($to.Length) (must be equal for in-place patch)"
}

if (-not $In) { $In = $defaultIn }
if (-not (Test-Path -LiteralPath $In)) { throw "Input not found: $In" }

if ($ApplyInstalled) {
  if (-not (Test-Path -LiteralPath $installed)) {
    throw "Installed Zero not found: $installed (run Native Install once first)"
  }
  $In = $installed
  $Out = $installed
}

if (-not $Out) { $Out = $defaultOut }

$bytes = [IO.File]::ReadAllBytes((Resolve-Path -LiteralPath $In))
$ascii = [Text.Encoding]::ASCII.GetString($bytes)

if ($ascii.Contains($toId)) {
  Write-Host "Already contains store id $toId — nothing to do."
  if ($Out -ne $In) {
    $outDir = Split-Path $Out -Parent
    if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
    [IO.File]::WriteAllBytes($Out, $bytes)
    Write-Host "Copied unchanged to $Out"
  }
  exit 0
}
if (-not $ascii.Contains($from)) {
  throw "Companion origin not found in binary: $from"
}
if (-not $ascii.Contains("lkaihdpfpifdlgoapbfocpmekbokmcfd")) {
  throw "Refusing to patch: original id lkaihd… missing (wrong file?)"
}

$fromBytes = [Text.Encoding]::ASCII.GetBytes($from)
$toBytes = [Text.Encoding]::ASCII.GetBytes($to)
$hit = 0
for ($i = 0; $i -le $bytes.Length - $fromBytes.Length; $i++) {
  $ok = $true
  for ($j = 0; $j -lt $fromBytes.Length; $j++) {
    if ($bytes[$i + $j] -ne $fromBytes[$j]) { $ok = $false; break }
  }
  if ($ok) {
    [Array]::Copy($toBytes, 0, $bytes, $i, $toBytes.Length)
    $hit++
    $i += $fromBytes.Length - 1
  }
}
if ($hit -ne 1) { throw "Expected exactly 1 replacement, got $hit" }

$outDir = Split-Path $Out -Parent
if ($outDir -and -not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# Backup when patching in place
if ((Resolve-Path -LiteralPath $In -ErrorAction SilentlyContinue) -and ($Out -eq $In -or (Test-Path $Out) -and ((Resolve-Path $Out).Path -eq (Resolve-Path $In).Path))) {
  $bak = "$In.bak-pre-cws"
  if (-not (Test-Path $bak)) {
    Copy-Item -LiteralPath $In -Destination $bak
    Write-Host "Backup: $bak"
  }
}

[IO.File]::WriteAllBytes($Out, $bytes)
$md5 = (Get-FileHash -LiteralPath $Out -Algorithm MD5).Hash
$check = [Text.Encoding]::ASCII.GetString([IO.File]::ReadAllBytes($Out))
$origins = [regex]::Matches($check, 'chrome-extension://[a-p]{32}') | ForEach-Object { $_.Value } | Sort-Object -Unique

Write-Host "Patched OK → $Out"
Write-Host "MD5 $md5"
Write-Host "Replaced $fromId → $toId ($hit hit)"
Write-Host "Origins now ($($origins.Count)):"
$origins | ForEach-Object { Write-Host "  $_" }

if ($ApplyInstalled) {
  Write-Host ""
  Write-Host "Next: use ONLY the store-ID extension in this Chrome profile."
  Write-Host "Options → Native Install/Repair (rewrites AutoControl.manifest from this Zero)."
  Write-Host "Then: Get-Content `$env:LOCALAPPDATA\AutoControl\AutoControl.manifest"
}
