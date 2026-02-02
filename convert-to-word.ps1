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

# Function to reset formatting to default
function Reset-Formatting {
    param($sel)
    $sel.Style = "Normal"
    $sel.Font.Name = "Calibri"
    $sel.Font.Size = 11
    $sel.Font.Bold = $false
    $sel.Font.Italic = $false
    $sel.Font.Color = 0  # Black
    $sel.ParagraphFormat.LeftIndent = 0
    $sel.ParagraphFormat.RightIndent = 0
    $sel.ParagraphFormat.SpaceBefore = 0
    $sel.ParagraphFormat.SpaceAfter = 0
    $sel.ParagraphFormat.Shading.BackgroundPatternColor = 16777215  # White
}

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

    # Move to end and reset
    $sel.Collapse(0)
    Reset-Formatting -sel $sel
    $sel.TypeParagraph()
}

# Function to handle inline formatting (bold, italic, code)
function Add-FormattedText {
    param($text, $sel)

    $currentText = $text
    $position = 0

    while ($position -lt $currentText.Length) {
        # Check for inline code (backticks)
        if ($currentText[$position] -eq '`') {
            $endPos = $currentText.IndexOf('`', $position + 1)
            if ($endPos -gt $position) {
                # Type the code text
                $codeText = $currentText.Substring($position + 1, $endPos - $position - 1)
                $sel.Font.Name = "Consolas"
                $sel.Font.Size = 10
                $sel.Font.Color = 8388608  # Dark red
                $sel.TypeText($codeText)
                $sel.Font.Name = "Calibri"
                $sel.Font.Size = 11
                $sel.Font.Color = 0
                $position = $endPos + 1
                continue
            }
        }

        # Check for bold text (**)
        if ($position -lt $currentText.Length - 1 -and $currentText.Substring($position, 2) -eq '**') {
            $endPos = $currentText.IndexOf('**', $position + 2)
            if ($endPos -gt $position) {
                # Type the bold text
                $boldText = $currentText.Substring($position + 2, $endPos - $position - 2)
                $sel.Font.Bold = $true
                $sel.TypeText($boldText)
                $sel.Font.Bold = $false
                $position = $endPos + 2
                continue
            }
        }

        # Check for italic text (*)
        if ($currentText[$position] -eq '*' -and ($position -eq 0 -or $currentText[$position - 1] -ne '*')) {
            $endPos = $currentText.IndexOf('*', $position + 1)
            if ($endPos -gt $position -and ($endPos -eq $currentText.Length - 1 -or $currentText[$endPos + 1] -ne '*')) {
                # Type the italic text
                $italicText = $currentText.Substring($position + 1, $endPos - $position - 1)
                $sel.Font.Italic = $true
                $sel.TypeText($italicText)
                $sel.Font.Italic = $false
                $position = $endPos + 1
                continue
            }
        }

        # Regular character
        $sel.TypeText($currentText[$position])
        $position++
    }
}

# Parse and format the markdown
$lines = $content -split "`r?`n"
$inCodeBlock = $false
$inTable = $false
$tableData = @()
$codeLines = @()

$totalLines = $lines.Count
$currentLine = 0
$previousWasEmpty = $false

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].TrimEnd()
    $currentLine++

    if ($currentLine % 50 -eq 0) {
        $percent = [math]::Round(($currentLine / $totalLines) * 100)
        Write-Progress -Activity "Converting to Word" -Status "$percent% Complete" -PercentComplete $percent
    }

    # Handle code blocks
    if ($line -match '^```') {
        if ($inCodeBlock) {
            if ($codeLines.Count -gt 0 -and (Test-IsDiagram ($codeLines -join "`n"))) {
                Add-DiagramBox -lines $codeLines -sel $selection -document $doc
            } else {
                Reset-Formatting -sel $selection
                $selection.Font.Name = "Consolas"
                $selection.Font.Size = 9
                $selection.ParagraphFormat.LeftIndent = 36
                $selection.ParagraphFormat.Shading.BackgroundPatternColor = 15790320
                foreach ($codeLine in $codeLines) {
                    $selection.TypeText($codeLine)
                    $selection.TypeParagraph()
                }
                Reset-Formatting -sel $selection
                $selection.TypeParagraph()
            }
            $inCodeBlock = $false
            $codeLines = @()
            $previousWasEmpty = $false
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

    # Handle horizontal rules
    if ($line -match '^[-*_]{3,}$') {
        $selection.Borders.Enable = $true
        $selection.Borders.DistanceFromBottom = 0
        $selection.TypeParagraph()
        $selection.Borders.Enable = $false
        $previousWasEmpty = $false
        continue
    }

    # Handle headings
    if ($line -match '^# (.+)$') {
        Reset-Formatting -sel $selection
        $selection.Style = "Title"
        $selection.Font.Size = 26
        $selection.Font.Bold = $true
        $selection.Font.Color = 49407  # Microsoft blue
        $selection.ParagraphFormat.SpaceAfter = 12
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    elseif ($line -match '^## (.+)$') {
        Reset-Formatting -sel $selection
        $selection.Style = "Heading 1"
        $selection.Font.Size = 16
        $selection.Font.Bold = $true
        $selection.Font.Color = 49407
        $selection.ParagraphFormat.SpaceBefore = 12
        $selection.ParagraphFormat.SpaceAfter = 6
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    elseif ($line -match '^### (.+)$') {
        Reset-Formatting -sel $selection
        $selection.Style = "Heading 2"
        $selection.Font.Size = 13
        $selection.Font.Bold = $true
        $selection.ParagraphFormat.SpaceBefore = 10
        $selection.ParagraphFormat.SpaceAfter = 4
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    elseif ($line -match '^#### (.+)$') {
        Reset-Formatting -sel $selection
        $selection.Style = "Heading 3"
        $selection.Font.Size = 11
        $selection.Font.Bold = $true
        $selection.ParagraphFormat.SpaceBefore = 8
        $selection.ParagraphFormat.SpaceAfter = 4
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    # Handle tables
    elseif ($line -match '^\|') {
        if (-not $inTable) {
            $inTable = $true
            $tableData = @()
        }
        $tableData += $line
        $previousWasEmpty = $false
        continue
    }
    elseif ($inTable -and $line -notmatch '^\|') {
        $inTable = $false

        # Filter out separator rows
        $rows = $tableData | Where-Object { $_ -notmatch '^\|[-\s|:]+\|$' }
        if ($rows.Count -gt 0) {
            $firstRow = $rows[0] -split '\|' | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }
            $numCols = $firstRow.Count
            $numRows = $rows.Count

            $range = $selection.Range
            $table = $doc.Tables.Add($range, $numRows, $numCols)
            $table.Borders.Enable = $true
            $table.Style = "Grid Table 4 - Accent 1"
            $table.AutoFitBehavior(2)  # AutoFit to contents

            for ($r = 0; $r -lt $rows.Count; $r++) {
                $cells = $rows[$r] -split '\|' | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }
                for ($c = 0; $c -lt [Math]::Min($cells.Count, $numCols); $c++) {
                    # Remove markdown formatting from cell text
                    $cellText = $cells[$c] -replace '\*\*(.+?)\*\*', '$1' -replace '`(.+?)`', '$1' -replace '\*(.+?)\*', '$1'
                    $table.Cell($r + 1, $c + 1).Range.Text = $cellText
                    $table.Cell($r + 1, $c + 1).Range.Font.Size = 10

                    # Format header row
                    if ($r -eq 0) {
                        $table.Cell($r + 1, $c + 1).Range.Font.Bold = $true
                        $table.Cell($r + 1, $c + 1).Shading.BackgroundPatternColor = 14083324
                    }
                }
            }

            $selection.EndKey(6)  # Move to end of document
            $selection.TypeParagraph()
        }
        $tableData = @()

        # Re-process current line if it's not empty
        if ($line.Trim() -ne '') {
            $i--
        }
        $previousWasEmpty = $false
        continue
    }
    # Handle bullet lists
    elseif ($line -match '^[\s]*- (.+)$') {
        Reset-Formatting -sel $selection
        $selection.Range.ListFormat.ApplyBulletDefault()
        Add-FormattedText -text $matches[1] -sel $selection
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    # Handle numbered lists
    elseif ($line -match '^[\s]*\d+\. (.+)$') {
        Reset-Formatting -sel $selection
        $selection.Range.ListFormat.ApplyNumberDefault()
        Add-FormattedText -text $matches[1] -sel $selection
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    # Handle links
    elseif ($line -match '\[.+?\]\(.+?\)') {
        Reset-Formatting -sel $selection
        $currentText = $line

        while ($currentText -match '\[(.+?)\]\((.+?)\)') {
            $beforeLink = $currentText.Substring(0, $matches.Index)
            if ($beforeLink) {
                Add-FormattedText -text $beforeLink -sel $selection
            }

            $linkText = $matches[1]
            $linkUrl = $matches[2]

            $doc.Hyperlinks.Add($selection.Range, $linkUrl, $null, $null, $linkText) | Out-Null
            $selection.Collapse(0)  # Move to end

            $currentText = $currentText.Substring($matches.Index + $matches[0].Length)
        }

        if ($currentText) {
            Add-FormattedText -text $currentText -sel $selection
        }
        $selection.TypeParagraph()
        $previousWasEmpty = $false
        continue
    }
    # Handle blockquotes
    elseif ($line -match '^> (.+)$') {
        Reset-Formatting -sel $selection
        $selection.ParagraphFormat.LeftIndent = 36
        $selection.ParagraphFormat.Shading.BackgroundPatternColor = 15790320  # Light gray
        $selection.Font.Italic = $true
        Add-FormattedText -text $matches[1] -sel $selection
        $selection.TypeParagraph()
        Reset-Formatting -sel $selection
        $previousWasEmpty = $false
        continue
    }
    # Handle empty lines (add proper spacing)
    elseif ($line.Trim() -eq '') {
        if (-not $previousWasEmpty) {
            Reset-Formatting -sel $selection
            $selection.TypeParagraph()
            $previousWasEmpty = $true
        }
        continue
    }
    # Normal text with inline formatting
    else {
        Reset-Formatting -sel $selection
        Add-FormattedText -text $line -sel $selection
        $selection.TypeParagraph()
        $previousWasEmpty = $false
    }
}

Write-Progress -Activity "Converting to Word" -Completed

# Save and close
try {
    if (Test-Path $WordPath) {
        Remove-Item $WordPath -Force
    }

    $doc.SaveAs([ref]$WordPath, [ref]16)
    Write-Host "✓ Word document created successfully!" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to save document: $_" -ForegroundColor Red
    exit 1
} finally {
    $doc.Close()
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}

Write-Host "Conversion complete!" -ForegroundColor Green
