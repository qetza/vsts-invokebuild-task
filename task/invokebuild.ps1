[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try {
    # get inputs
    [string] $buildFile = Get-VstsInput -Name BuildFile
    [string] $tasks = Get-VstsInput -Name Tasks
    [string] $parameters = Get-VstsInput -Name Parameters
    [bool] $summary = Get-VstsInput -Name Summary -AsBool

    Write-Verbose "buildFile = ${buildFile}"
    Write-Verbose "tasks = ${tasks}"
    Write-Verbose "parameters = ${parameters}"
    Write-Verbose "summary = ${summary}"

    # validate inputs
    if ($buildFile -and !(Test-Path $buildFile))
    {
        Write-Error "Build script '${buildFile}' not found."
    }

    # prepare script command
    $arguments += " -File '${buildFile}'"

    if ($tasks)
    {
        $arguments += " -Task ${tasks}"
    }

    if ($summary)
    {
        $arguments += ' -Summary'
    }

    if ($parameters)
    {
        $arguments += " ${parameters}"
    }

    $command = "& Invoke-Build ${arguments}"

    Import-Module -Name $PSScriptRoot\ps_modules\InvokeBuild\InvokeBuild.psd1

    # invoke command
    Write-Verbose "command: ${command}"

    Invoke-Expression -Command $command
}
finally
{
    Trace-VstsLeavingInvocation $MyInvocation
}