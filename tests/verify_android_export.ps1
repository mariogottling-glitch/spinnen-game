param(
    [string]$ApkPath = "build/web-weaver-android.apk"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ApkPath)) {
    throw "APK nicht gefunden: $ApkPath"
}

$entries = tar -tf $ApkPath
if ($LASTEXITCODE -ne 0) {
    throw "APK-Inhalt konnte nicht gelesen werden."
}

$source = (Get-Content -Raw "scripts/main.gd") + (Get-Content -Raw "scripts/fadenschnitt_theme.gd")
$preloadPaths = [regex]::Matches($source, 'preload\("res://([^\"]+)"\)') |
    ForEach-Object { $_.Groups[1].Value } |
    Sort-Object -Unique

$missing = @()
foreach ($path in $preloadPaths) {
    $baseName = [IO.Path]::GetFileNameWithoutExtension($path)
    if (-not ($entries | Select-String -SimpleMatch $baseName -Quiet)) {
        $missing += $path
    }
}

foreach ($script in @("main", "upgrade_database", "fadenschnitt_theme")) {
    if (-not ($entries | Select-String -SimpleMatch "assets/scripts/$script.gdc" -Quiet)) {
        $missing += "scripts/$script.gd"
    }
}

if ($missing.Count -gt 0) {
    throw "Android-Export ist unvollständig:`n$($missing -join "`n")"
}

Write-Output "ANDROID_EXPORT_OK ($($preloadPaths.Count) Preloads geprüft)"
