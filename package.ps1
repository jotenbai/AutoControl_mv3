# Packs extension/ as a Chrome Web Store ZIP (strips the original `key`).
# Run from the repo root: .\package.ps1
# Before zipping: rebuilds extension/file69.dat so Native Install embeds both
# the original ID (lkaihd…) and the CWS ID (ifjogpfn…) in allowed_origins.
# The zip does NOT include the original AutoControl public `key` — CWS assigns
# a new item ID. Unpacked Load still uses extension/manifest.json as-is (key
# kept so this machine keeps the original native-host ID).
# Output: AutoControl_mv3-v<version>.zip at the repo root (gitignored).

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$src = Join-Path $root 'extension'
$manifestPath = Join-Path $src 'manifest.json'
if (-not (Test-Path $manifestPath)) {
    throw "extension/manifest.json not found. Run this from the repo root."
}

# Ensure file69.dat carries the CWS origin (Install-emit). Idempotent.
& (Join-Path $root 'tools\build-file69-cws.ps1') | Out-Host

$manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
$ver = $manifest.version
$outName = "AutoControl_mv3-v$ver.zip"
$outPath = Join-Path $root $outName

if (Test-Path $outPath) { Remove-Item -Force $outPath }

$locales = Join-Path $src '_locales'
if (-not (Test-Path (Join-Path $locales 'en\messages.json'))) {
    throw "extension/_locales/en/messages.json missing — CWS multilingual listing needs it."
}

$stage = Join-Path $env:TEMP ("ac-mv3-pack-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
try {
    Copy-Item -Path (Join-Path $src '*') -Destination $stage -Recurse
    $stagedManifestPath = Join-Path $stage 'manifest.json'
    $raw = Get-Content -Raw -Encoding UTF8 $stagedManifestPath
    $stripped = [regex]::Replace($raw, ',\s*"key"\s*:\s*"[A-Za-z0-9+/=]+"', '')
    if ($stripped -eq $raw) {
        throw "Store zip must not ship the original AutoControl key; strip failed."
    }
    Set-Content -Encoding UTF8 -NoNewline -Path $stagedManifestPath -Value $stripped
    Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $outPath -CompressionLevel Optimal
} finally {
    Remove-Item -Recurse -Force $stage
}

Write-Host "Wrote $outName ($((Get-Item $outPath).Length) bytes)"
Write-Host "Store zip has no original key (CWS ID). file69.dat includes ifjogpfn… + lkaihd… origins."
Write-Host "Load unpacked still uses extension/ with key (lkaihd…)."
