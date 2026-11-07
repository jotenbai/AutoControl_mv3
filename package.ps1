# Packs extension/ as a ZIP (strips the original `key` if present).
# Run from the repo root: .\package.ps1
# This fork’s supported install is Load unpacked from GitHub (keep the original
# key in extension/manifest.json). Store upload is abandoned — native hooks
# conflict with a second extension ID. package.ps1 remains for archival zips.
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
    throw "extension/_locales/en/messages.json missing."
}

$stage = Join-Path $env:TEMP ("ac-mv3-pack-" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
try {
    Copy-Item -Path (Join-Path $src '*') -Destination $stage -Recurse
    $stagedManifestPath = Join-Path $stage 'manifest.json'
    $raw = Get-Content -Raw -Encoding UTF8 $stagedManifestPath
    $stripped = [regex]::Replace($raw, ',\s*"key"\s*:\s*"[A-Za-z0-9+/=]+"', '')
    if ($stripped -ne $raw) {
        Set-Content -Encoding UTF8 -NoNewline -Path $stagedManifestPath -Value $stripped
        Write-Host "Staged zip: original key stripped."
    } else {
        Write-Host "Staged zip: no key field to strip."
    }
    Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $outPath -CompressionLevel Optimal
} finally {
    Remove-Item -Recurse -Force $stage
}

Write-Host "Wrote $outName ($((Get-Item $outPath).Length) bytes)"
Write-Host "Supported install: Load unpacked → extension/ (keep key / original ID)."
