# PowerShell script to improve diagrams in Word document
# Part of the generate-spec skill
# Converts ASCII diagrams to professional flowcharts and grids

param(
    [Parameter(Mandatory=$true)]
    [string]$WordPath
)

Write-Host "Improving diagrams in Word document..." -ForegroundColor Cyan
Write-Host "Document: $WordPath" -ForegroundColor Gray

if (-not (Test-Path $WordPath)) {
    Write-Host "ERROR: Word document not found!" -ForegroundColor Red
    exit 1
}

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$doc = $word.Documents.Open($WordPath)

Write-Host "Document opened successfully" -ForegroundColor Gray

# Function to replace ASCII diagram with professional flowchart
function Replace-WithFlowchart {
    param($doc, $word, $searchText, $components)

    $range = $doc.Content
    $range.Find.ClearFormatting()
    $range.Find.Text = $searchText

    if ($range.Find.Execute()) {
        Write-Host "  Found section: $searchText" -ForegroundColor Gray

        $word.Selection.SetRange($range.End, $range.End)
        $word.Selection.MoveDown(5, 2)

        # Delete old diagram (next 20 lines)
        $word.Selection.MoveDown(5, 20, 1)
        $word.Selection.Delete()

        # Create new flowchart table
        $numRows = ($components.Count * 2) - 1  # Components + arrows
        $table = $doc.Tables.Add($word.Selection.Range, $numRows, 1)
        $table.Borders.Enable = $false
        $table.AutoFitBehavior(1)
        $table.PreferredWidthType = 2
        $table.PreferredWidth = 55

        $row = 1
        foreach ($comp in $components) {
            $cell = $table.Cell($row, 1)
            $cellRange = $cell.Range
            $cellRange.Text = "$($comp.Name)`n$($comp.Desc)"
            $cellRange.Font.Name = "Calibri"
            $cellRange.Font.Size = 10
            $cellRange.ParagraphFormat.Alignment = 1
            $cell.Shading.BackgroundPatternColor = 15132390
            $cell.Borders.Enable = $true
            $cell.Borders.OutsideColor = 49407
            $cell.Borders.OutsideLineWidth = 4
            $cell.VerticalAlignment = 1
            $cell.SetHeight(42, 0)

            $firstPara = $cellRange.Paragraphs.Item(1).Range
            $firstPara.Font.Bold = $true
            $firstPara.Font.Size = 11

            $row++

            # Add arrow
            if ($row -le $numRows) {
                $arrowCell = $table.Cell($row, 1)
                $arrowCell.Range.Text = [char]0x2193
                $arrowCell.Range.Font.Size = 16
                $arrowCell.Range.Font.Color = 49407
                $arrowCell.Range.ParagraphFormat.Alignment = 1
                $arrowCell.Borders.Enable = $false
                $arrowCell.Shading.BackgroundPatternColor = 16777215
                $arrowCell.SetHeight(15, 0)
                $row++
            }
        }

        Write-Host "  ✓ Created flowchart diagram" -ForegroundColor Green
        return $true
    }

    return $false
}

# Function to create dependency map grid
function Replace-WithDependencyGrid {
    param($doc, $word, $searchText, $titleText, $gridComponents)

    $range = $doc.Content
    $range.Find.ClearFormatting()
    $range.Find.Text = $searchText

    if ($range.Find.Execute()) {
        Write-Host "  Found section: $searchText" -ForegroundColor Gray

        $word.Selection.SetRange($range.End, $range.End)
        $word.Selection.MoveDown(5, 2)

        # Delete old diagram
        $word.Selection.MoveDown(5, 30, 1)
        $word.Selection.Delete()

        # Create title box
        $titleTable = $doc.Tables.Add($word.Selection.Range, 1, 1)
        $titleTable.Borders.Enable = $true
        $titleTable.Borders.OutsideColor = 49407
        $titleTable.Borders.OutsideLineWidth = 6
        $titleTable.AutoFitBehavior(1)
        $titleTable.PreferredWidthType = 2
        $titleTable.PreferredWidth = 65

        $titleCell = $titleTable.Cell(1, 1)
        $titleCell.Range.Text = $titleText
        $titleCell.Range.Font.Name = "Calibri"
        $titleCell.Range.Font.Size = 12
        $titleCell.Range.Font.Bold = $true
        $titleCell.Range.ParagraphFormat.Alignment = 1
        $titleCell.Shading.BackgroundPatternColor = 14083324
        $titleCell.VerticalAlignment = 1
        $titleCell.SetHeight(38, 0)

        $word.Selection.EndKey(6)
        $word.Selection.TypeParagraph()

        # Create grid
        $gridTable = $doc.Tables.Add($word.Selection.Range, 3, 2)
        $gridTable.Borders.Enable = $false
        $gridTable.AutoFitBehavior(1)
        $gridTable.PreferredWidthType = 2
        $gridTable.PreferredWidth = 65

        # Fill grid components
        foreach ($comp in $gridComponents) {
            $cell = $gridTable.Cell($comp.Row, $comp.Col)
            $cell.Range.Text = $comp.Text
            $cell.Range.Font.Name = "Calibri"
            $cell.Range.Font.Size = 9
            $cell.Shading.BackgroundPatternColor = $comp.Color
            $cell.Borders.Enable = $true
            $cell.Borders.OutsideColor = 49407
            $cell.Borders.OutsideLineWidth = 3
            $cell.VerticalAlignment = 0
            $cell.SetHeight($comp.Height, 0)
            $cell.Range.Paragraphs.Item(1).Range.Font.Bold = $true
            $cell.Range.Paragraphs.Item(1).Range.Font.Size = 10
        }

        # Add arrows
        $gridTable.Cell(2, 1).Range.Text = [char]0x2193
        $gridTable.Cell(2, 1).Range.Font.Size = 18
        $gridTable.Cell(2, 1).Range.Font.Color = 49407
        $gridTable.Cell(2, 1).Range.ParagraphFormat.Alignment = 1
        $gridTable.Cell(2, 1).Borders.Enable = $false
        $gridTable.Cell(2, 1).Shading.BackgroundPatternColor = 16777215
        $gridTable.Cell(2, 1).SetHeight(25, 0)

        $gridTable.Cell(2, 2).Range.Text = [char]0x2193
        $gridTable.Cell(2, 2).Range.Font.Size = 18
        $gridTable.Cell(2, 2).Range.Font.Color = 49407
        $gridTable.Cell(2, 2).Range.ParagraphFormat.Alignment = 1
        $gridTable.Cell(2, 2).Borders.Enable = $false
        $gridTable.Cell(2, 2).Shading.BackgroundPatternColor = 16777215
        $gridTable.Cell(2, 2).SetHeight(25, 0)

        Write-Host "  ✓ Created dependency grid diagram" -ForegroundColor Green
        return $true
    }

    return $false
}

# Look for common diagram patterns and improve them

Write-Host "`nSearching for diagrams to improve..." -ForegroundColor Cyan

# Pattern 1: Signal Architecture / Data Flow diagrams
$signalComponents = @(
    @{Name="User Actions"; Desc="Visit folder, read email, reply, forward"},
    @{Name="SIGS Ingestion"; Desc="Instrument ViewMessage, enrich with ParentFolderId"},
    @{Name="Moments Records"; Desc="Store EmailRecord + folder metadata"},
    @{Name="Affinity Scorer"; Desc="Compute folder affinity scores"},
    @{Name="Moments API"; Desc="Expose folder affinity for consumption"},
    @{Name="Email Ranker / 3S Email Fetch"; Desc="Consume signal for ranking and scoping"}
)

$improved1 = Replace-WithFlowchart -doc $doc -word $word -searchText "Signal Architecture" -components $signalComponents

# Pattern 2: Dependency Map
$depComponents = @(
    @{Row=1; Col=1; Text="Moments Platform (Provider)`n`n- EmailRecord schema`n- Affinity scoring`n- API endpoints`n`nDRI: Bryan Butteling"; Color=15132390; Height=95},
    @{Row=1; Col=2; Text="Email Ranker (Consumer)`n`n- API integration`n- Ranking logic`n- 3S scope filtering`n- Fuzzy matching`n`nDRI: Ashish Jain"; Color=15132390; Height=95},
    @{Row=3; Col=1; Text="SIGS Ingestion`n`n- ViewMessage enrich`n- ParentFolderId stamp`n`nDRI: Sandhya Sunderrajan"; Color=16445670; Height=85},
    @{Row=3; Col=2; Text="Language Understanding (LU)`n`n- Folder slot tuning`n- Over-trigger fix`n`nDRI: TBD"; Color=16445670; Height=85}
)

$improved2 = Replace-WithDependencyGrid -doc $doc -word $word -searchText "Appendix D: Dependency Map" -titleText "Email Folder Affinity (Feature 5745909)" -gridComponents $depComponents

# Save if any improvements were made
if ($improved1 -or $improved2) {
    Write-Host "`nSaving improvements..." -ForegroundColor Cyan
    try {
        $doc.Save()
        Write-Host "✓ Diagrams improved successfully!" -ForegroundColor Green

        if ($improved1) { Write-Host "  - Signal Architecture diagram" -ForegroundColor Gray }
        if ($improved2) { Write-Host "  - Dependency Map diagram" -ForegroundColor Gray }
    } catch {
        Write-Host "ERROR: Failed to save document: $_" -ForegroundColor Red
    }
} else {
    Write-Host "No diagrams found to improve" -ForegroundColor Yellow
}

$doc.Close()
$word.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null

Write-Host "`nDiagram improvement complete!" -ForegroundColor Green
