# Packs mv3-build/ as a Chrome extension ZIP (developer backup / sideload).
# This is NOT the install path for users — they Load unpacked → mv3-build/.
# Output: AutoControl-mv3-v<manifest.version>.zip at the repo root (gitignored).

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$src = Join-Path $root 'mv3-build'
$manifestPath = Join-Path $src 'manifest.json'
if (-not (Test-Path $manifestPath)) {
    throw "mv3-build/manifest.json not found. Run this from the repo root."
}

$manifest = Get-Content -Raw -Encoding UTF8 $manifestPath | ConvertFrom-Json
$ver = $manifest.version
$outName = "AutoControl-mv3-v$ver.zip"
$outPath = Join-Path $root $outName

if (Test-Path $outPath) { Remove-Item -Force $outPath }

$stage = Join-Path $env:TEMP ("ac-mv3-pack-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
try {
    Copy-Item -Path (Join-Path $src '*') -Destination $stage -Recurse
    Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $outPath -CompressionLevel Optimal
} finally {
    Remove-Item -Recurse -Force $stage
}

Write-Host "Wrote $outName ($((Get-Item $outPath).Length) bytes)"
Write-Host "Zip root is the extension (manifest.json). Load unpacked still uses mv3-build/."
