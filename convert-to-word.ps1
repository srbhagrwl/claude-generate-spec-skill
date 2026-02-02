# PowerShell script to convert Markdown to professionally formatted Word document
# Part of the generate-spec skill

param(
    [Parameter(Mandatory=$true)]
    [string]$MarkdownPath,

    [Parameter(Mandatory=$true)]
    [string]$WordPath
)

Write-Host "Converting markdown to Word document..." -ForegroundColor Cyan
Write-Host "Input:  $MarkdownPath" -ForegroundColor Gray
Write-Host "Output: $WordPath" -ForegroundColor Gray

if (-not (Test-Path $MarkdownPath)) {
    Write-Host "ERROR: Markdown file not found!" -ForegroundColor Red
    exit 1
}

# Read the markdown file
$content = Get-Content -Path $MarkdownPath -Raw -Encoding UTF8

# Create Word application
$word = New-Object -ComObject Word.Application
$word.Visible = $false

# Create new document
$doc = $word.Documents.Add()
$selection = $word.Selection

# Configure page setup
$doc.PageSetup.TopMargin = 72
$doc.PageSetup.BottomMargin = 72
$doc.PageSetup.LeftMargin = 72
$doc.PageSetup.RightMargin = 72

# Function to check if text contains diagram characters
function Test-IsDiagram {
    param($text)
    return $text -match '[\u2500-\u257F]' # Box drawing Unicode range
}

# Function to create a formatted diagram box
function Add-DiagramBox {
    param($lines, $sel, $document)

    $sel.Style = "Normal"
    $sel.Font.Name = "Consolas"
    $sel.Font.Size = 9
    $sel.ParagraphFormat.LeftIndent = 36
    $sel.ParagraphFormat.RightIndent = 36
    $sel.ParagraphFormat.SpaceBefore = 6
    $sel.ParagraphFormat.SpaceAfter = 6
    $sel.ParagraphFormat.Shading.BackgroundPatternColor = 15790320  # Light gray

    foreach ($line in $lines) {
        $sel.TypeText($line)
        $sel.TypeParagraph()
    }

    # Add border
    $sel.MoveUp(5, $lines.Count)
    $sel.MoveDown(5, $lines.Count, 1)
    $sel.Borders.Enable = $true
    $sel.Borders.OutsideColor = 49407  # Microsoft blue
    $sel.Borders.OutsideLineWidth = 2

    # Move to end
    $sel.Collapse(0)
    $sel.TypeParagraph()

    # Reset formatting
    $sel.Font.Name = "Calibri"
    $sel.Font.Size = 11
    $sel.ParagraphFormat.LeftIndent = 0
    $sel.ParagraphFormat.RightIndent = 0
    $sel.ParagraphFormat.Shading.BackgroundPatternColor = 16777215
}

# Parse and format the markdown
$lines = $content -split "`r?`n"
$inCodeBlock = $false
$inTable = $false
$tableData = @()
$codeLines = @()

$totalLines = $lines.Count
$currentLine = 0

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].TrimEnd()
    $currentLine++

    if ($currentLine % 100 -eq 0) {
        $percent = [math]::Round(($currentLine / $totalLines) * 100)
        Write-Progress -Activity "Converting to Word" -Status "$percent% Complete" -PercentComplete $percent
    }

    # Handle code blocks
    if ($line -match '^```') {
        if ($inCodeBlock) {
            if ($codeLines.Count -gt 0 -and (Test-IsDiagram ($codeLines -join "`n"))) {
                Add-DiagramBox -lines $codeLines -sel $selection -document $doc
            } else {
                $selection.Font.Name = "Consolas"
                $selection.Font.Size = 9
                $selection.ParagraphFormat.LeftIndent = 36
                $selection.ParagraphFormat.Shading.BackgroundPatternColor = 15790320
                foreach ($codeLine in $codeLines) {
                    $selection.TypeText($codeLine)
                    $selection.TypeParagraph()
                }
                $selection.Font.Name = "Calibri"
                $selection.Font.Size = 11
                $selection.ParagraphFormat.LeftIndent = 0
                $selection.ParagraphFormat.Shading.BackgroundPatternColor = 16777215
            }
            $inCodeBlock = $false
            $codeLines = @()
        } else {
            $inCodeBlock = $true
            $codeLines = @()
        }
        continue
    }

    if ($inCodeBlock) {
        $codeLines += $line
        continue
    }

    # Handle headings
    if ($line -match '^# (.+)$') {
        $selection.Style = "Title"
        $selection.Font.Size = 26
        $selection.Font.Bold = $true
        $selection.Font.Color = 49407
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
        $selection.TypeParagraph()
    }
    elseif ($line -match '^## (.+)$') {
        $selection.Style = "Heading 1"
        $selection.Font.Size = 16
        $selection.Font.Color = 49407
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
    }
    elseif ($line -match '^### (.+)$') {
        $selection.Style = "Heading 2"
        $selection.Font.Size = 13
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
    }
    elseif ($line -match '^#### (.+)$') {
        $selection.Style = "Heading 3"
        $selection.Font.Size = 11
        $selection.Font.Bold = $true
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
    }
    # Handle tables
    elseif ($line -match '^\|') {
        if (-not $inTable) {
            $inTable = $true
            $tableData = @()
        }
        $tableData += $line
    }
    elseif ($inTable -and $line -notmatch '^\|') {
        $inTable = $false

        $rows = $tableData | Where-Object { $_ -notmatch '^\|[-\s|:]+\|$' }
        if ($rows.Count -gt 0) {
            $firstRow = $rows[0] -split '\|' | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }
            $numCols = $firstRow.Count
            $numRows = $rows.Count

            $range = $selection.Range
            $table = $doc.Tables.Add($range, $numRows, $numCols)
            $table.Borders.Enable = $true
            $table.Style = "Grid Table 4 - Accent 1"
            $table.AutoFitBehavior(2)

            for ($r = 0; $r -lt $rows.Count; $r++) {
                $cells = $rows[$r] -split '\|' | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }
                for ($c = 0; $c -lt [Math]::Min($cells.Count, $numCols); $c++) {
                    $cellText = $cells[$c] -replace '\*\*(.+?)\*\*', '$1' -replace '`(.+?)`', '$1'
                    $table.Cell($r + 1, $c + 1).Range.Text = $cellText

                    if ($r -eq 0) {
                        $table.Cell($r + 1, $c + 1).Range.Font.Bold = $true
                        $table.Cell($r + 1, $c + 1).Shading.BackgroundPatternColor = 14083324
                    }
                }
            }

            $selection.EndKey(6)
            $selection.TypeParagraph()
        }
        $tableData = @()

        if ($line.Trim() -ne '') {
            $i--
        }
    }
    # Handle bullet lists
    elseif ($line -match '^- (.+)$') {
        $selection.Style = "List Bullet"
        $text = $matches[1] -replace '\*\*(.+?)\*\*', '$1' -replace '`(.+?)`', '$1'
        $selection.TypeText($text)
        $selection.TypeParagraph()
    }
    # Handle numbered lists
    elseif ($line -match '^\d+\. (.+)$') {
        $selection.Style = "List Number"
        $text = $matches[1] -replace '\*\*(.+?)\*\*', '$1' -replace '`(.+?)`', '$1'
        $selection.TypeText($text)
        $selection.TypeParagraph()
    }
    # Handle links
    elseif ($line -match '\[.+?\]\(.+?\)') {
        $selection.Style = "Normal"
        $currentLine = $line

        while ($currentLine -match '\[(.+?)\]\((.+?)\)') {
            $beforeLink = $currentLine.Substring(0, $currentLine.IndexOf('['))
            if ($beforeLink) { $selection.TypeText($beforeLink) }

            $linkText = $matches[1]
            $linkUrl = $matches[2]

            $hyperlink = $doc.Hyperlinks.Add($selection.Range, $linkUrl, $null, $null, $linkText)

            $currentLine = $currentLine.Substring($currentLine.IndexOf(')') + 1)
        }

        if ($currentLine) { $selection.TypeText($currentLine) }
        $selection.TypeParagraph()
    }
    # Handle bold text
    elseif ($line -match '\*\*') {
        $selection.Style = "Normal"
        $parts = $line -split '\*\*'
        for ($p = 0; $p -lt $parts.Count; $p++) {
            if ($p % 2 -eq 1) {
                $selection.Font.Bold = $true
                $selection.TypeText($parts[$p])
                $selection.Font.Bold = $false
            } else {
                $selection.TypeText($parts[$p])
            }
        }
        $selection.TypeParagraph()
    }
    # Handle inline code
    elseif ($line -match '`') {
        $selection.Style = "Normal"
        $parts = $line -split '`'
        for ($p = 0; $p -lt $parts.Count; $p++) {
            if ($p % 2 -eq 1) {
                $selection.Font.Name = "Consolas"
                $selection.Font.Size = 10
                $selection.TypeText($parts[$p])
                $selection.Font.Name = "Calibri"
                $selection.Font.Size = 11
            } else {
                $selection.TypeText($parts[$p])
            }
        }
        $selection.TypeParagraph()
    }
    # Handle empty lines
    elseif ($line.Trim() -eq '') {
        if ($selection.Style -ne "Normal") {
            $selection.Style = "Normal"
        }
    }
    # Normal text
    else {
        $selection.Style = "Normal"
        $selection.TypeText($line)
        $selection.TypeParagraph()
    }
}

Write-Progress -Activity "Converting to Word" -Completed

# Save and close
try {
    if (Test-Path $WordPath) {
        Remove-Item $WordPath -Force
    }

    $doc.SaveAs([ref]$WordPath, [ref]16)
    Write-Host "[OK] Word document created successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to save document: $_" -ForegroundColor Red
    exit 1
} finally {
    $doc.Close()
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}

Write-Host "Conversion complete!" -ForegroundColor Green
