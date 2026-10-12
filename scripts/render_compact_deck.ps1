param([string]$ProjectRoot = 'C:\Users\yasha\Documents\probability_lab')
$ErrorActionPreference = 'Stop'
$pitchPowerPoint = $null
$pitchDeck = $null
$pitchStartedEmpty = $false
try {
    $pitchPowerPoint = New-Object -ComObject PowerPoint.Application
    $pitchStartedEmpty = $pitchPowerPoint.Presentations.Count -eq 0
    $pitchDeck = $pitchPowerPoint.Presentations.Open((Join-Path $ProjectRoot 'submission\Diabetes_Statistics_Presentation.pptx'), -1, 0, 0)
    if ($pitchDeck.Slides.Count -ne 13) { throw 'Expected one intro and twelve content slides.' }
    $pitchDeck.SaveAs((Join-Path $ProjectRoot 'submission\Diabetes_Statistics_Slides.pdf'), 32)
    $pitchPreviewPath = Join-Path $ProjectRoot '.build\compact_powerpoint_previews'
    New-Item -ItemType Directory -Force -Path $pitchPreviewPath | Out-Null
    for ($pitchIndex = 1; $pitchIndex -le 13; $pitchIndex++) {
        $pitchDeck.Slides.Item($pitchIndex).Export((Join-Path $pitchPreviewPath ('slide-{0:D2}.png' -f $pitchIndex)), 'PNG', 1600, 900)
    }
    Write-Output 'Rendered one intro and twelve content slides in PowerPoint.'
} finally {
    if ($null -ne $pitchDeck) { $pitchDeck.Close() }
    if ($null -ne $pitchPowerPoint -and $pitchStartedEmpty -and $pitchPowerPoint.Presentations.Count -eq 0) { $pitchPowerPoint.Quit() }
}
