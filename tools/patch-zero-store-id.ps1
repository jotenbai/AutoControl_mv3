# Patch installed AutoControlZero.exe so the CWS store ID is in the
# embedded 14-origin list (same length swap). Reinstall/Repair overwrites
# Zero — run this again afterwards, then reload the store extension.
#
# Usage:
#   .\tools\patch-zero-store-id.ps1
#   .\tools\patch-zero-store-id.ps1 -StoreId ifjogpfnljedincfpelmhaljnllegckm
#   .\tools\patch-zero-store-id.ps1 -SlotId baikhopphokjmcllncdeocblfpeaklnj

param(
  [string]$StoreId = 'ifjogpfnljedincfpelmhaljnllegckm',
  # Last stock companion slot (not AutoControl itself). Change if already used.
  [string]$SlotId = 'baikhopphokjmcllncdeocblfpeaklnj',
  [string]$InstallDir = "$env:LOCALAPPDATA\AutoControl"
)

$ErrorActionPreference = 'Stop'
if ($StoreId.Length -ne 32 -or $SlotId.Length -ne 32) {
  throw "StoreId and SlotId must be exactly 32 chars (got $($StoreId.Length)/$($SlotId.Length))"
}
if ($StoreId -eq 'lkaihdpfpifdlgoapbfocpmekbokmcfd') {
  throw 'Refusing to patch — that is the original AutoControl ID'
}

Get-Process | Where-Object { $_.ProcessName -match 'AutoC' } |
  Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 500

$zero = Join-Path $InstallDir 'AutoControlZero.exe'
$man  = Join-Path $InstallDir 'AutoControl.manifest'
if (-not (Test-Path $zero)) { throw "Missing $zero — install Native Component first" }
if (-not (Test-Path $man))  { throw "Missing $man" }

$bakDir = Join-Path $InstallDir '_backup_before_store_id_patch'
New-Item -ItemType Directory -Force -Path $bakDir | Out-Null
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
Copy-Item $zero (Join-Path $bakDir "AutoControlZero.$stamp.exe") -Force
Copy-Item $man  (Join-Path $bakDir "AutoControl.manifest.$stamp") -Force

$bytes = [IO.File]::ReadAllBytes($zero)
$txt = [Text.Encoding]::ASCII.GetString($bytes)
if ($txt.Contains($StoreId)) {
  Write-Host "Zero already contains store id $StoreId — syncing manifest only"
} else {
  if (-not $txt.Contains($SlotId)) {
    throw "Slot id $SlotId not found in Zero (already patched with a different slot?)"
  }
  $from = [Text.Encoding]::ASCII.GetBytes($SlotId)
  $to   = [Text.Encoding]::ASCII.GetBytes($StoreId)
  $hits = 0
  for ($i = 0; $i -le $bytes.Length - 32; $i++) {
    $ok = $true
    for ($k = 0; $k -lt 32; $k++) {
      if ($bytes[$i + $k] -ne $from[$k]) { $ok = $false; break }
    }
    if ($ok) {
      for ($k = 0; $k -lt 32; $k++) { $bytes[$i + $k] = $to[$k] }
      $hits++
    }
  }
  if ($hits -lt 1) { throw "Replace failed" }
  [IO.File]::WriteAllBytes($zero, $bytes)
  Write-Host "Patched Zero: $SlotId -> $StoreId ($hits hit(s))"
  Write-Host "MD5:" (Get-FileHash $zero -Algorithm MD5).Hash
}

$bytes = [IO.File]::ReadAllBytes($zero)
$txt = [Text.Encoding]::ASCII.GetString($bytes)
$ids = [regex]::Matches($txt, 'chrome-extension://([a-p]{32})/') |
  ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique
if ($ids -notcontains $StoreId) { throw 'Store id missing from Zero after patch' }

$j = Get-Content -Raw -Encoding UTF8 $man | ConvertFrom-Json
$j.allowed_origins = @($ids | ForEach-Object { "chrome-extension://$_/" })
[IO.File]::WriteAllText($man, ($j | ConvertTo-Json -Compress),
  (New-Object Text.UTF8Encoding $false))
Write-Host "Manifest allowed_origins synced ($($ids.Count) origins)."
Write-Host "Reload the STORE extension only (disable unpacked). Reinstall requires re-run."
