# Build extension/file69.dat from stock Zero with the CWS origin companion
# slot patched (baikhop… → ifjogpfn…). Install downloads this blob, decrypts
# it to Native-Component.exe / AutoControlZero.exe, then installNativeHost
# writes allowed_origins including BOTH lkaihd… (Load unpacked) and ifjogpfn…
# (Chrome Web Store). Codec = _7g reverse (DECODE.md).
#
# Usage (repo root):
#   .\tools\build-file69-cws.ps1
# package.ps1 calls this automatically before zipping.

[CmdletBinding()]
param(
  [string] $OutDat = ""
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$plainIn = Join-Path $repo "reference\AutoControl_native\original\AutoControlZero.exe"
$patchPs1 = Join-Path $PSScriptRoot "patch-zero-cws-origin.ps1"
$patchedExe = Join-Path $repo "tools\patched\AutoControlZero.exe"
if (-not $OutDat) { $OutDat = Join-Path $repo "extension\file69.dat" }

if (-not (Test-Path $plainIn)) { throw "Missing $plainIn" }
if (-not (Test-Path $patchPs1)) { throw "Missing $patchPs1" }

& $patchPs1 -In $plainIn -Out $patchedExe | Out-Host
$exe = [IO.File]::ReadAllBytes($patchedExe)

$KEY = @(94, 14, 77, 49, 13)
$n = $exe.Length
$dat = New-Object byte[] $n
for ($i = 0; $i -lt $n; $i++) {
  $dat[$n - 1 - $i] = [byte](($exe[$i] + $KEY[$i % 5] + $i) % 256)
}

# Round-trip check
for ($i = 0; $i -lt $n; $i++) {
  $g = ([int]$dat[$n - 1 - $i] - $KEY[$i % 5] - $i) % 256
  if ($g -lt 0) { $g += 256 }
  if ($g -ne $exe[$i]) { throw "encode/decode mismatch at $i" }
}

$ascii = [Text.Encoding]::ASCII.GetString($exe)
if (-not $ascii.Contains("ifjogpfnljedincfpelmhaljnllegckm")) {
  throw "patched Zero missing store id"
}
if (-not $ascii.Contains("lkaihdpfpifdlgoapbfocpmekbokmcfd")) {
  throw "patched Zero missing original id"
}

[IO.File]::WriteAllBytes($OutDat, $dat)
$md5 = (Get-FileHash -LiteralPath $OutDat -Algorithm MD5).Hash
Write-Host "Wrote $OutDat ($n bytes) MD5=$md5"
