param(
    [string]$Doxyfile = "Doxyfile"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $Doxyfile)) {
    throw "Doxygen configuration not found: $Doxyfile"
}

$generatedRoot = Join-Path "docs" "generated"
if (Test-Path -LiteralPath $generatedRoot) {
    Remove-Item -LiteralPath $generatedRoot -Recurse -Force
}

doxygen $Doxyfile

$indexPath = Join-Path $generatedRoot "html/index.html"
if (-not (Test-Path -LiteralPath $indexPath)) {
    throw "Doxygen completed without producing $indexPath"
}

$warningLog = Join-Path $generatedRoot "doxygen-warnings.log"
if (Test-Path -LiteralPath $warningLog) {
    $warnings = Get-Content -LiteralPath $warningLog
    if ($warnings.Count -gt 0) {
        Write-Host "::group::Doxygen warnings"
        $warnings | ForEach-Object { Write-Host $_ }
        Write-Host "::endgroup::"
    }
}

Write-Host "Doxygen HTML generated at $indexPath"
