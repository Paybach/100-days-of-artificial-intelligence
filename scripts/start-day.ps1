param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 100)]
    [int]$Day,

    [Parameter(Mandatory = $true)]
    [string]$Title
)

$dayNumber = $Day.ToString("000")
$slug = $Title.ToLowerInvariant() -replace "[^a-z0-9]+", "-"
$slug = $slug.Trim("-")
$repoRoot = Split-Path -Parent $PSScriptRoot
$targetDirectory = Join-Path $repoRoot "days/day-$dayNumber-$slug"
$targetFile = Join-Path $targetDirectory "README.md"
$templateFile = Join-Path $repoRoot "templates/DAY_TEMPLATE.md"

if (Test-Path $targetDirectory) {
    throw "Day folder already exists: $targetDirectory"
}

New-Item -ItemType Directory -Path $targetDirectory | Out-Null

$content = Get-Content -Raw $templateFile
$content = $content.Replace("{{DAY}}", $dayNumber)
$content = $content.Replace("{{TITLE}}", $Title)
Set-Content -Path $targetFile -Value $content

Write-Host "Created $targetFile"
