#!/usr/bin/env pwsh
# Copyright (c) Microsoft Corporation.
# SPDX-License-Identifier: MIT

#Requires -Version 7.0

<#
.SYNOPSIS
    Validates that GitHub Actions workflow files include a top-level permissions block.

.DESCRIPTION
    Scans GitHub Actions workflow YAML files for the presence of a top-level
    permissions block. Workflows without explicit permissions rely on the
    repository's default token permissions, which can cause OpenSSF Scorecard
    Token-Permissions failures.

    The script uses a regex-based approach (^permissions:) to detect the
    top-level permissions declaration at column 0, ensuring zero dependencies
    and zero false positives.

.PARAMETER Path
    Directory containing workflow YAML files. Defaults to '.github/workflows'.

.PARAMETER Format
    Output format: 'json', 'sarif', or 'console'. Defaults to 'json'.

.PARAMETER OutputPath
    Path for result output file. Defaults to 'logs/workflow-permissions-results.json'.

.PARAMETER FailOnViolation
    When set, exits with non-zero code if any workflow is missing permissions.

.PARAMETER ExcludePaths
    Comma-separated list of workflow filenames to exclude from scanning.
    Defaults to 'copilot-setup-steps.yml'.

.EXAMPLE
    ./scripts/security/Test-WorkflowPermissions.ps1

.EXAMPLE
    ./scripts/security/Test-WorkflowPermissions.ps1 -FailOnViolation -Format sarif

.NOTES
    Part of the HVE Core security validation suite.

.LINK
    https://github.com/microsoft/hve-core
#>

using module ./Modules/SecurityClasses.psm1

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Path = '.github/workflows',

    [Parameter(Mandatory = $false)]
    [ValidateSet('json', 'sarif', 'console')]
    [string]$Format = 'json',

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = 'logs/workflow-permissions-results.json',

    [Parameter(Mandatory = $false)]
    [switch]$FailOnViolation,

    [Parameter(Mandatory = $false)]
    [string]$ExcludePaths = 'copilot-setup-steps.yml'
)

$ErrorActionPreference = 'Stop'

Import-Module (Join-Path $PSScriptRoot '../lib/Modules/CIHelpers.psm1') -Force

# region Helper Functions

function Write-PermissionsLog {
    <#
    .SYNOPSIS
        Writes a timestamped log message with optional CI annotation.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warning', 'Error', 'Success')]
        [string]$Level = 'Info'
    )

    $timestamp = Get-Date -Format 'HH:mm:ss'
    $color = switch ($Level) {
        'Info' { 'Cyan' }
        'Warning' { 'Yellow' }
        'Error' { 'Red' }
        'Success' { 'Green' }
    }

    Write-Host "[$timestamp] " -NoNewline -ForegroundColor DarkGray
    Write-Host $Message -ForegroundColor $color

    if ($Level -eq 'Warning') {
        Write-CIAnnotation -Message $Message -Level 'Warning'
    }
    elseif ($Level -eq 'Error') {
        Write-CIAnnotation -Message $Message -Level 'Error'
    }
}

function Test-WorkflowPermissions {
    <#
    .SYNOPSIS
        Tests a single workflow file for a top-level permissions block.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath
    )

    $content = Get-Content -Path $FilePath -Raw
    if ($content -match '(?m)^permissions:') {
        return $null
    }

    $fileName = [System.IO.Path]::GetFileName($FilePath)
    $relativePath = $FilePath

    $violation = [DependencyViolation]::new()
    $violation.File = $relativePath
    $violation.Line = 0
    $violation.Type = 'workflow-permissions'
    $violation.Name = $fileName
    $violation.ViolationType = 'MissingPermissions'
    $violation.Severity = 'High'
    $violation.Description = "Workflow '$fileName' is missing a top-level permissions block"
    $violation.Remediation = "Add a top-level 'permissions:' block to restrict default token scope and satisfy OpenSSF Scorecard Token-Permissions"
    $violation.Metadata = @{ FullPath = $FilePath }

    return $violation
}

function ConvertTo-PermissionsSarif {
    <#
    .SYNOPSIS
        Converts violations to SARIF 2.1.0 format.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [DependencyViolation[]]$Violations
    )

    $rules = @(
        @{
            id               = 'missing-permissions'
            name             = 'MissingWorkflowPermissions'
            shortDescription = @{ text = 'Workflow missing top-level permissions block' }
            fullDescription  = @{ text = 'GitHub Actions workflows should declare a top-level permissions block to restrict the default GITHUB_TOKEN scope.' }
            helpUri          = 'https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token'
            defaultConfiguration = @{ level = 'error' }
        }
    )

    $results = @()
    foreach ($v in $Violations) {
        $results += @{
            ruleId  = 'missing-permissions'
            level   = 'error'
            message = @{ text = $v.Description }
            locations = @(
                @{
                    physicalLocation = @{
                        artifactLocation = @{ uri = $v.File }
                        region           = @{ startLine = 1 }
                    }
                }
            )
        }
    }

    $sarif = @{
        version  = '2.1.0'
        '$schema' = 'https://json.schemastore.org/sarif-2.1.0.json'
        runs     = @(
            @{
                tool    = @{
                    driver = @{
                        name            = 'Test-WorkflowPermissions'
                        version         = '1.0.0'
                        informationUri  = 'https://github.com/microsoft/hve-core'
                        rules           = $rules
                    }
                }
                results = $results
            }
        )
    }

    return $sarif
}

function Invoke-WorkflowPermissionsCheck {
    <#
    .SYNOPSIS
        Orchestrates the workflow permissions validation scan.
    #>
    [OutputType([int])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Path = '.github/workflows',

        [Parameter(Mandatory = $false)]
        [ValidateSet('json', 'sarif', 'console')]
        [string]$Format = 'json',

        [Parameter(Mandatory = $false)]
        [string]$OutputPath = 'logs/workflow-permissions-results.json',

        [Parameter(Mandatory = $false)]
        [switch]$FailOnViolation,

        [Parameter(Mandatory = $false)]
        [string]$ExcludePaths = 'copilot-setup-steps.yml'
    )

    Write-PermissionsLog "Starting workflow permissions validation" -Level Info
    Write-PermissionsLog "Scanning: $Path" -Level Info

    # Resolve scan path
    $resolvedPath = Resolve-Path -Path $Path -ErrorAction Stop
    Write-PermissionsLog "Resolved path: $resolvedPath" -Level Info

    # Parse exclusions
    $exclusions = @()
    if ($ExcludePaths) {
        $exclusions = $ExcludePaths -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
    }
    if ($exclusions.Count -gt 0) {
        Write-PermissionsLog "Excluding: $($exclusions -join ', ')" -Level Info
    }

    # Discover workflow files
    $workflowFiles = Get-ChildItem -Path $resolvedPath -Filter '*.yml' -File
    $totalFiles = $workflowFiles.Count
    Write-PermissionsLog "Found $totalFiles workflow file(s)" -Level Info

    # Apply exclusions
    if ($exclusions.Count -gt 0) {
        $workflowFiles = $workflowFiles | Where-Object { $exclusions -notcontains $_.Name }
    }
    $scannedFiles = $workflowFiles.Count
    Write-PermissionsLog "Scanning $scannedFiles file(s) after exclusions" -Level Info

    # Scan each workflow
    $report = [ComplianceReport]::new($Path)
    $report.TotalFiles = $totalFiles
    $report.ScannedFiles = $scannedFiles
    $report.TotalDependencies = $scannedFiles
    $filesWithPermissions = 0

    foreach ($file in $workflowFiles) {
        $violation = Test-WorkflowPermissions -FilePath $file.FullName
        if ($null -eq $violation) {
            $filesWithPermissions++
            Write-PermissionsLog "  PASS: $($file.Name)" -Level Success
        }
        else {
            # Normalize to workspace-relative path
            $violation.File = Join-Path $Path $file.Name
            $report.AddViolation($violation)
            Write-PermissionsLog "  FAIL: $($file.Name) - missing permissions block" -Level Error
            Write-CIAnnotation -Message $violation.Description -Level 'Error' -File $violation.File -Line 1
        }
    }

    $report.PinnedDependencies = $filesWithPermissions
    $report.CalculateScore()

    Write-PermissionsLog "Score: $($report.ComplianceScore)% ($filesWithPermissions/$scannedFiles with permissions)" -Level Info

    # Format output
    $output = switch ($Format) {
        'console' {
            if ($report.Violations.Count -eq 0) {
                "All $scannedFiles workflow(s) have a top-level permissions block."
            }
            else {
                $lines = @("Workflow permissions violations found:`n")
                foreach ($v in $report.Violations) {
                    $lines += "  - $($v.File): $($v.Description)"
                }
                $lines += "`nRemediation: $($report.Violations[0].Remediation)"
                $lines -join "`n"
            }
        }
        'sarif' {
            (ConvertTo-PermissionsSarif -Violations $report.Violations) | ConvertTo-Json -Depth 10
        }
        'json' {
            $report.ToHashtable() | ConvertTo-Json -Depth 10
        }
    }

    # Write output file
    $outputDir = [System.IO.Path]::GetDirectoryName($OutputPath)
    if ($outputDir -and -not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    $output | Out-File -FilePath $OutputPath -Encoding utf8 -Force
    Write-PermissionsLog "Results written to: $OutputPath" -Level Info

    # Generate step summary
    $summaryLines = @(
        "## Workflow Permissions Validation"
        ""
        "| Metric | Value |"
        "|--------|-------|"
        "| Total Workflows | $totalFiles |"
        "| Scanned | $scannedFiles |"
        "| With Permissions | $filesWithPermissions |"
        "| Missing Permissions | $($report.Violations.Count) |"
        "| Compliance Score | $($report.ComplianceScore)% |"
    )

    if ($report.Violations.Count -gt 0) {
        $summaryLines += @(
            ""
            "### Violations"
            ""
            "| Workflow | Issue |"
            "|----------|-------|"
        )
        foreach ($v in $report.Violations) {
            $summaryLines += "| ``$($v.File)`` | $($v.Description) |"
        }
    }

    $summary = $summaryLines -join "`n"
    Write-CIStepSummary -Content $summary

    # Display to console
    $output | Out-Host

    # Determine exit code
    $exitCode = 0
    if ($report.Violations.Count -gt 0) {
        if ($FailOnViolation) {
            Write-PermissionsLog "$($report.Violations.Count) violation(s) found - failing" -Level Error
            $exitCode = 1
        }
        else {
            Write-PermissionsLog "$($report.Violations.Count) violation(s) found - soft fail mode" -Level Warning
        }
    }
    else {
        Write-PermissionsLog "All workflows have permissions blocks" -Level Success
    }

    return $exitCode
}

# endregion

# Dot-source guard
if ($MyInvocation.InvocationName -ne '.') {
    try {
        $exitCode = Invoke-WorkflowPermissionsCheck @PSBoundParameters
        exit $exitCode
    }
    catch {
        Write-PermissionsLog "Fatal error: $_" -Level Error
        Write-PermissionsLog $_.ScriptStackTrace -Level Error
        exit 1
    }
}
