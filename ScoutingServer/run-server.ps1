# Runs the GearScout backend. The build requires JDK 25, so we
# locate a JDK 25 installation and run Gradle with it, without requiring
# JAVA_HOME to be set globally.

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

function Test-Jdk25 {
    param([string]$Home)
    if (-not $Home) { return $false }
    $java = Join-Path $Home 'bin\java.exe'
    if (-not (Test-Path $java)) { return $false }
    $ver = & $java -version 2>&1 | Out-String
    return $ver -match 'version "25\.'
}

$candidates = New-Object System.Collections.Generic.List[string]

if ($env:JAVA_HOME) { $candidates.Add($env:JAVA_HOME) }

# java on PATH may already be a JDK 25
$javaCmd = Get-Command java -ErrorAction SilentlyContinue
if ($javaCmd) {
    $candidates.Add((Split-Path (Split-Path $javaCmd.Source -Parent) -Parent))
}

# Common JDK install roots on Windows
$roots = @(
    'C:\Program Files\Eclipse Adoptium',
    'C:\Program Files\Java',
    'C:\Program Files\Microsoft',
    'C:\Program Files\Amazon Corretto',
    'C:\Program Files\Zulu',
    'C:\Program Files\BellSoft',
    'C:\Program Files\Common Files\Oracle\Java',
    "$env:LOCALAPPDATA\Programs\Eclipse Adoptium",
    "$env:LOCALAPPDATA\Programs\Microsoft"
)
foreach ($root in $roots) {
    if (Test-Path $root) {
        Get-ChildItem $root -Directory -ErrorAction SilentlyContinue |
            Where-Object { $_.Name -match '(^|[^0-9])25([.\-_ ]|$)' } |
            ForEach-Object { $candidates.Add($_.FullName) }
    }
}

$jdk25 = $candidates | Where-Object { Test-Jdk25 $_ } | Select-Object -First 1

if (-not $jdk25) {
    Write-Error "JDK 25 not found. Install it, e.g.: winget install EclipseAdoptium.Temurin.25.JDK"
    exit 1
}

$env:JAVA_HOME = $jdk25
Write-Host "Using JAVA_HOME=$jdk25"
& .\gradlew.bat bootRun
exit $LASTEXITCODE
