param([string]$ProjectRoot = 'C:\Users\yasha\Documents\probability_lab')
$ErrorActionPreference = 'Stop'
$reportWord = $null
$reportDoc = $null
try {
    $reportWord = New-Object -ComObject Word.Application
    $reportWord.Visible = $false
    $reportWord.DisplayAlerts = 0
    $reportDoc = $reportWord.Documents.Open((Join-Path $ProjectRoot 'submission\Diabetes_Statistics_Report.docx'), $false, $true)
    $reportDoc.Repaginate()
    $reportDoc.ExportAsFixedFormat((Join-Path $ProjectRoot 'submission\Diabetes_Statistics_Report.pdf'), 17)
    Write-Output "Word report pages: $($reportDoc.ComputeStatistics(2))"
} finally {
    if ($null -ne $reportDoc) { $reportDoc.Close(0) }
    if ($null -ne $reportWord) { $reportWord.Quit() }
}
$reviewPowerPoint = $null
$reviewDeck = $null
try {
    $reviewPowerPoint = New-Object -ComObject PowerPoint.Application
    $reviewDeck = $reviewPowerPoint.Presentations.Open((Join-Path $ProjectRoot 'submission\Diabetes_Statistics_Presentation.pptx'), -1, 0, 0)
    $reviewDeck.SaveAs((Join-Path $ProjectRoot 'submission\Diabetes_Statistics_Slides.pdf'), 32)
    $previewPath = Join-Path $ProjectRoot '.build\powerpoint-previews'
    New-Item -ItemType Directory -Force -Path $previewPath | Out-Null
    for ($slideIndex = 1; $slideIndex -le $reviewDeck.Slides.Count; $slideIndex++) {
        $reviewDeck.Slides.Item($slideIndex).Export((Join-Path $previewPath ('slide-{0:D2}.png' -f $slideIndex)), 'PNG', 1600, 900)
    }
    Write-Output "PowerPoint slides rendered: $($reviewDeck.Slides.Count)"
} finally {
    if ($null -ne $reviewDeck) { $reviewDeck.Close() }
    if ($null -ne $reviewPowerPoint) { $reviewPowerPoint.Quit() }
}
