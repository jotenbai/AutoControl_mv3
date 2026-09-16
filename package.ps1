# Packs extension/ as a Chrome Web Store ZIP (strips the original `key`).
# Run from the repo root: .\package.ps1
# The zip does NOT include the original AutoControl public `key` — CWS assigns
# a new item ID. Unpacked Load still uses extension/manifest.json as-is (key
# kept so this machine keeps the original native-host ID until you paste the
# store public key back).
# Output: AutoControl_mv3-v<version>.zip at the repo root (gitignored).

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$src = Join-Path $root 'extension'
$manifestPath = Join-Path $src 'manifest.json'
if (-not (Test-Path $manifestPath)) {
    throw "extension/manifest.json not found. Run this from the repo root."
}

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
Write-Host "Store zip has no original key (new CWS ID). Load unpacked still uses extension/ with key."
