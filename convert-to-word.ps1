# PowerShell script to convert Markdown to professionally formatted Word document
# Part of the generate-spec skill

param(
    [Parameter(Mandatory=$true)]
    [string]$MarkdownPath,

    [Parameter(Mandatory=$true)]
    [string]$WordPath,

    [Parameter(Mandatory=$false)]
    [int]$HeadingColor = 49407,  # Microsoft Blue (RGB 0,192,255)

    [Parameter(Mandatory=$false)]
    [int]$CodeBlockBgColor = 15790320,  # Light Gray (RGB 240,240,240)

    [Parameter(Mandatory=$false)]
    [int]$TableHeaderBgColor = 14083324,  # Light Blue (RGB 214,236,252)

    [Parameter(Mandatory=$false)]
    [int]$DiagramBorderColor = 49407,  # Microsoft Blue

    [Parameter(Mandatory=$false)]
    [string]$TableStyle = "Grid Table 4 - Accent 1",

    [Parameter(Mandatory=$false)]
    [switch]$VerboseOutput,

    [Parameter(Mandatory=$false)]
    [switch]$Quiet
)

if (-not $Quiet) {
    Write-Host "Converting markdown to Word document..." -ForegroundColor Cyan
    if ($VerboseOutput) {
        Write-Host "Input:  $MarkdownPath" -ForegroundColor Gray
        Write-Host "Output: $WordPath" -ForegroundColor Gray
    }
}

if (-not (Test-Path $MarkdownPath)) {
    Write-Host "ERROR: Markdown file not found!" -ForegroundColor Red
    exit 1
}

# Read the markdown file
$content = Get-Content -Path $MarkdownPath -Raw -Encoding UTF8

# Create Word application
try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
} catch {
    Write-Host "ERROR: Failed to create Word application: $_" -ForegroundColor Red
    exit 1
}

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
    param($lines, $sel, $document, $bgColor, $borderColor)

    $sel.Style = "Normal"
    $sel.Font.Name = "Consolas"
    $sel.Font.Size = 9
    $sel.ParagraphFormat.LeftIndent = 36
    $sel.ParagraphFormat.RightIndent = 36
    $sel.ParagraphFormat.SpaceBefore = 6
    $sel.ParagraphFormat.SpaceAfter = 6
    $sel.ParagraphFormat.Shading.BackgroundPatternColor = $bgColor

    foreach ($line in $lines) {
        $sel.TypeText($line)
        $sel.TypeParagraph()
    }

    # Add border
    $sel.MoveUp(5, $lines.Count)
    $sel.MoveDown(5, $lines.Count, 1)
    $sel.Borders.Enable = $true
    $sel.Borders.OutsideColor = $borderColor
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

# Function to process text with mixed formatting (bold, code, links)
function Add-FormattedText {
    param($text, $sel, $document)

    # Process the text character by character, handling nested formatting
    $i = 0
    while ($i -lt $text.Length) {
        # Check for markdown link [text](url)
        if ($text[$i] -eq '[' -and $text.Substring($i) -match '^\[(.+?)\]\((.+?)\)') {
            $linkText = $matches[1]
            $linkUrl = $matches[2]

            # Strip markdown from link text (bold, code, etc.)
            $cleanLinkText = $linkText -replace '\*\*(.+?)\*\*', '$1' -replace '`(.+?)`', '$1'

            # Create hyperlink
            $range = $sel.Range
            $range.Collapse(0)  # Collapse to end
            $document.Hyperlinks.Add($range, $linkUrl, $null, $null, $cleanLinkText) | Out-Null
            $sel.Collapse(0)  # Move selection after hyperlink

            $i += $matches[0].Length
        }
        # Check for bold **text**
        elseif ($text.Substring($i) -match '^\*\*(.+?)\*\*') {
            $sel.Font.Bold = $true
            $sel.TypeText($matches[1])
            $sel.Font.Bold = $false
            $i += $matches[0].Length
        }
        # Check for inline code `text`
        elseif ($text[$i] -eq '`' -and $text.Substring($i) -match '^`(.+?)`') {
            $sel.Font.Name = "Consolas"
            $sel.Font.Size = 10
            $sel.TypeText($matches[1])
            $sel.Font.Name = "Calibri"
            $sel.Font.Size = 11
            $i += $matches[0].Length
        }
        # Regular character
        else {
            $sel.TypeText($text[$i])
            $i++
        }
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

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i].TrimEnd()
    $currentLine++

    if ($currentLine % 100 -eq 0) {
        $percent = [math]::Round(($currentLine / $totalLines) * 100)
        Write-Progress -Activity "Converting to Word" -Status "$percent% Complete ($currentLine/$totalLines lines)" -PercentComplete $percent
        if ($VerboseOutput) {
            Write-Host "Processing line $currentLine of $totalLines ($percent%)" -ForegroundColor Gray
        }
    }

    # Handle code blocks
    if ($line -match '^```') {
        if ($inCodeBlock) {
            if ($codeLines.Count -gt 0 -and (Test-IsDiagram ($codeLines -join "`n"))) {
                Add-DiagramBox -lines $codeLines -sel $selection -document $doc -bgColor $CodeBlockBgColor -borderColor $DiagramBorderColor
            } else {
                $selection.Font.Name = "Consolas"
                $selection.Font.Size = 9
                $selection.ParagraphFormat.LeftIndent = 36
                $selection.ParagraphFormat.Shading.BackgroundPatternColor = $CodeBlockBgColor
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

    # Handle horizontal rules
    if ($line -match '^(---|___|[*][*][*])$') {
        $selection.Style = "Normal"
        $selection.TypeParagraph()
        $shape = $selection.InlineShapes.AddHorizontalLineStandard()
        $selection.TypeParagraph()
    }
    # Handle images
    elseif ($line -match '^\!\[(.+?)\]\((.+?)\)$') {
        $altText = $matches[1]
        $imagePath = $matches[2]

        # Resolve relative paths
        $baseDir = Split-Path $MarkdownPath -Parent
        if (-not [System.IO.Path]::IsPathRooted($imagePath)) {
            $imagePath = Join-Path $baseDir $imagePath
        }

        if (Test-Path $imagePath) {
            try {
                $shape = $selection.InlineShapes.AddPicture($imagePath)
                $shape.LockAspectRatio = $true
                if ($shape.Width -gt 400) {
                    $shape.Width = 400  # Max width
                }
                $selection.TypeParagraph()
            } catch {
                # Fallback: insert alt text if image fails
                $selection.TypeText("[$altText]")
                $selection.TypeParagraph()
            }
        } else {
            # Image not found: insert alt text
            $selection.TypeText("[$altText - Image not found: $imagePath]")
            $selection.TypeParagraph()
        }
    }
    # Handle blockquotes
    elseif ($line -match '^> (.+)$') {
        $selection.Style = "Normal"
        $selection.Font.Italic = $true
        $selection.ParagraphFormat.LeftIndent = 36
        $selection.ParagraphFormat.Shading.BackgroundPatternColor = $CodeBlockBgColor
        Add-FormattedText -text $matches[1] -sel $selection -document $doc
        $selection.TypeParagraph()
        $selection.Font.Italic = $false
        $selection.ParagraphFormat.LeftIndent = 0
        $selection.ParagraphFormat.Shading.BackgroundPatternColor = 16777215
    }
    # Handle headings
    elseif ($line -match '^# (.+)$') {
        $selection.Style = "Title"
        $selection.Font.Size = 26
        $selection.Font.Bold = $true
        $selection.Font.Color = $HeadingColor
        $selection.TypeText($matches[1])
        $selection.TypeParagraph()
        $selection.TypeParagraph()
    }
    elseif ($line -match '^## (.+)$') {
        $selection.Style = "Heading 1"
        $selection.Font.Size = 16
        $selection.Font.Color = $HeadingColor
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
            try {
                $firstRow = $rows[0] -split '\|' | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }
                $numCols = $firstRow.Count
                $numRows = $rows.Count

                $range = $selection.Range
                $table = $doc.Tables.Add($range, $numRows, $numCols)
                $table.Borders.Enable = $true
                $table.Style = $TableStyle
                $table.AutoFitBehavior(2)

                for ($r = 0; $r -lt $rows.Count; $r++) {
                    $cells = $rows[$r] -split '\|' | Where-Object { $_.Trim() -ne '' } | ForEach-Object { $_.Trim() }
                    for ($c = 0; $c -lt [Math]::Min($cells.Count, $numCols); $c++) {
                        $cellText = $cells[$c]
                        $cellRange = $table.Cell($r + 1, $c + 1).Range

                        # Clear cell first
                        $cellRange.Text = ""

                        # Position selection at cell start
                        $cellRange.Collapse(1)  # Collapse to start
                        $selection.SetRange($cellRange.Start, $cellRange.Start)

                        # Add formatted text (handles links, bold, code)
                        Add-FormattedText -text $cellText -sel $selection -document $doc

                        # Apply header formatting
                        if ($r -eq 0) {
                            $table.Cell($r + 1, $c + 1).Range.Font.Bold = $true
                            $table.Cell($r + 1, $c + 1).Shading.BackgroundPatternColor = $TableHeaderBgColor
                        }
                    }
                }

                $selection.EndKey(6)
                $selection.TypeParagraph()
            } catch {
                if ($VerboseOutput) {
                    Write-Host "WARNING: Failed to process table: $_" -ForegroundColor Yellow
                }
                # Continue processing rest of document
            }
        }
        $tableData = @()

        if ($line.Trim() -ne '') {
            $i--
        }
    }
    # Handle bullet lists
    elseif ($line -match '^- (.+)$') {
        $selection.Style = "List Bullet"
        Add-FormattedText -text $matches[1] -sel $selection -document $doc
        $selection.TypeParagraph()
    }
    # Handle numbered lists
    elseif ($line -match '^\d+\. (.+)$') {
        $selection.Style = "List Number"
        Add-FormattedText -text $matches[1] -sel $selection -document $doc
        $selection.TypeParagraph()
    }
    # Handle text with formatting (links, bold, code, or mixed)
    elseif ($line -match '(\[.+?\]\(.+?\)|\*\*.+?\*\*|`.+?`)') {
        $selection.Style = "Normal"
        Add-FormattedText -text $line -sel $selection -document $doc
        $selection.TypeParagraph()
    }
    # Handle empty lines
    elseif ($line.Trim() -eq '') {
        if ($selection.Style -ne "Normal") {
            $selection.Style = "Normal"
        }
    }
    # Normal text (may contain formatting that wasn't caught by previous checks)
    else {
        $selection.Style = "Normal"
        if ($line -match '(\[.+?\]\(.+?\)|\*\*.+?\*\*|`.+?`)') {
            Add-FormattedText -text $line -sel $selection -document $doc
        } else {
            $selection.TypeText($line)
        }
        $selection.TypeParagraph()
    }
}

Write-Progress -Activity "Converting to Word" -Completed

# Save and close
try {
    # Convert to absolute path
    $absPath = (Resolve-Path -Path (Split-Path $WordPath -Parent)).Path + "\" + (Split-Path $WordPath -Leaf)

    if (Test-Path $absPath) {
        Remove-Item $absPath -Force
    }

    $doc.SaveAs([ref]$absPath, [ref]16)
    if (-not $Quiet) {
        Write-Host "[OK] Word document created successfully!" -ForegroundColor Green
        if ($VerboseOutput) {
            Write-Host "Saved to: $absPath" -ForegroundColor Gray
        }
    }
} catch {
    Write-Host "ERROR: Failed to save document: $_" -ForegroundColor Red
    exit 1
} finally {
    $doc.Close()
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
}

if (-not $Quiet) {
    Write-Host "Conversion complete!" -ForegroundColor Green
}
