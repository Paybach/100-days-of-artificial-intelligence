param(
    [switch]$Overwrite
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$roadmapFile = Join-Path $repoRoot "ROADMAP.md"
$daysDirectory = Join-Path $repoRoot "days"
$indexFile = Join-Path $daysDirectory "README.md"

$resourceGroups = @(
    @{
        Start = 1
        End = 20
        Links = @(
            "[Python tutorial](https://docs.python.org/3/tutorial/)",
            "[NumPy learn](https://numpy.org/learn/)",
            "[pandas getting started](https://pandas.pydata.org/docs/getting_started/index.html)"
        )
        Practice = "[Data story project](../../projects/project-01-data-story/README.md)"
    },
    @{
        Start = 21
        End = 40
        Links = @(
            "[scikit-learn user guide](https://scikit-learn.org/stable/user_guide.html)"
        )
        Practice = "[Tabular prediction project](../../projects/project-02-tabular-prediction/README.md)"
    },
    @{
        Start = 41
        End = 60
        Links = @(
            "[PyTorch tutorials](https://docs.pytorch.org/tutorials/)",
            "[Hugging Face task guides](https://huggingface.co/docs/transformers/tasks/sequence_classification)"
        )
        Practice = "[Semantic search project](../../projects/project-03-semantic-search/README.md)"
    },
    @{
        Start = 61
        End = 80
        Links = @(
            "[Hugging Face LLM course](https://huggingface.co/learn/llm-course/chapter1/1)",
            "[FastAPI tutorial](https://fastapi.tiangolo.com/tutorial/)",
            "[MLflow getting started](https://mlflow.org/docs/latest/ml/getting-started/)"
        )
        Practice = "[Model API project](../../projects/project-04-model-api/README.md)"
    },
    @{
        Start = 81
        End = 100
        Links = @(
            "[NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)",
            "[NIST AI RMF playbook](https://airc.nist.gov/airmf-resources/playbook/)"
        )
        Practice = "[Responsible AI capstone](../../projects/project-05-responsible-ai-capstone/README.md)"
    }
)

$notebookGroups = @(
    @{ Start = 3; End = 4; Link = "[Python and NumPy practice](../../notebooks/01-python-and-numpy-practice.ipynb)" },
    @{ Start = 5; End = 10; Link = "[pandas data story](../../notebooks/02-pandas-data-story.ipynb)" },
    @{ Start = 21; End = 30; Link = "[First classification model](../../notebooks/03-first-classification-model.ipynb)" },
    @{ Start = 31; End = 40; Link = "[Clustering and PCA](../../notebooks/04-clustering-and-pca.ipynb)" },
    @{ Start = 51; End = 60; Link = "[Semantic search concepts](../../notebooks/05-semantic-search-concepts.ipynb)" }
)

$rows = Get-Content $roadmapFile | ForEach-Object {
    if ($_ -match '^\| ([0-9]{3}) \| ([^|]+) \| ([^|]+) \| ([^|]+) \|$') {
        [PSCustomObject]@{
            Day = [int]$Matches[1]
            Number = $Matches[1]
            Topic = $Matches[2].Trim()
            Task = $Matches[3].Trim()
            Artifact = $Matches[4].Trim()
        }
    }
}

if ($rows.Count -ne 100) {
    throw "Expected 100 roadmap rows but found $($rows.Count)."
}

function ConvertTo-Slug {
    param([string]$Text)

    $slug = $Text.ToLowerInvariant() -replace '[^a-z0-9]+', '-'
    return $slug.Trim('-')
}

function Get-ResourceGroup {
    param([int]$Day)

    return $resourceGroups | Where-Object { $Day -ge $_.Start -and $Day -le $_.End } | Select-Object -First 1
}

function Get-NotebookGroup {
    param([int]$Day)

    return $notebookGroups | Where-Object { $Day -ge $_.Start -and $Day -le $_.End } | Select-Object -First 1
}

$indexLines = @(
    "# Daily Artificial Intelligence Worksheets",
    "",
    "Open the worksheet for the current day, follow the research prompts, complete the hands-on task, and commit your evidence.",
    "",
    "| Day | Topic | Worksheet |",
    "| --- | --- | --- |"
)

foreach ($row in $rows) {
    $slug = ConvertTo-Slug $row.Topic
    $folderName = "day-$($row.Number)-$slug"
    $targetDirectory = Join-Path $daysDirectory $folderName
    $targetFile = Join-Path $targetDirectory "README.md"
    $resourceGroup = Get-ResourceGroup $row.Day
    $notebookGroup = Get-NotebookGroup $row.Day
    $resourceLines = $resourceGroup.Links | ForEach-Object { "- $_" }
    $practiceLine = "- Related milestone: $($resourceGroup.Practice)"
    $nextRow = $rows | Where-Object { $_.Day -eq ($row.Day + 1) } | Select-Object -First 1

    if ($nextRow) {
        $nextSlug = ConvertTo-Slug $nextRow.Topic
        $nextStep = "Continue with [Day $($nextRow.Number): $($nextRow.Topic)](../day-$($nextRow.Number)-$nextSlug/README.md)."
    } else {
        $nextStep = "Review your 100-day portfolio and prepare your final presentation."
    }

    $indexLines += "| $($row.Number) | $($row.Topic) | [Open worksheet]($folderName/README.md) |"

    if ((Test-Path $targetFile) -and -not $Overwrite) {
        continue
    }

    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

    $content = @(
        "# Day $($row.Number): $($row.Topic)",
        "",
        "## Goal",
        "",
        "Understand **$($row.Topic)** and complete this practical task: **$($row.Task)**",
        "",
        "Your evidence for today is: **$($row.Artifact)**",
        "",
        "## Research Questions",
        "",
        "- What problem does $($row.Topic) solve?",
        "- Where does it fit in an AI or machine-learning workflow?",
        "- Which concepts, code, or metrics should you be able to explain after today's work?",
        "- What is one limitation, source of error, or responsible-use question to consider?",
        "",
        "## Starting Points",
        ""
    )

    $content += $resourceLines
    $content += $practiceLine

    if ($notebookGroup) {
        $content += "- Suggested notebook: $($notebookGroup.Link)"
    }

    $content += @(
        "- Browse the broader [resource guide](../../RESOURCES.md) when you need another explanation.",
        "",
        "## Hands-on Work",
        "",
        "1. Read enough to answer the research questions in your own words.",
        "2. Complete today's task: **$($row.Task)**",
        "3. Add your **$($row.Artifact)** to this folder, or link to it under Artifact / Evidence.",
        "4. Record code, outputs, charts, or model results under Notes.",
        "",
        "## Completion Checklist",
        "",
        "- [ ] I answered the research questions in my own words.",
        "- [ ] I completed the hands-on task.",
        "- [ ] I added or linked my artifact.",
        "- [ ] I wrote a short reflection.",
        "- [ ] I marked Day $($row.Number) complete in [PROGRESS.md](../../PROGRESS.md).",
        "- [ ] I committed and pushed my work to GitHub.",
        "",
        "## Artifact / Evidence",
        "",
        "Add files, screenshots, links, charts, metrics, or a short output sample here.",
        "",
        "## Notes",
        "",
        "- Add research notes here.",
        "- Add code, output, or experiment notes here.",
        "",
        "## What I Learned",
        "",
        "- Add reflections here.",
        "",
        "## Next Step",
        "",
        $nextStep
    )

    Set-Content -Path $targetFile -Value $content
}

Set-Content -Path $indexFile -Value $indexLines
Write-Host "Generated AI worksheet index and missing daily worksheets."
