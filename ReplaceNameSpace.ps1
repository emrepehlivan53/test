[CmdletBinding()]
Param(
    $FilePath= 'C:\git\test\deployment.yml',
    $Regex = 'namespace\:\s(?<NameSpace>\S+)',
    $PostFix = '-test'
)


#region ScriptMain
$Content = Get-Content -Path $FilePath
$NewContent = @()
Foreach ($Line in $Content) {

    if ($Line -match $Regex) {
        $NameSpace = $Matches['NameSpace']
        Write-Verbose "Found Namespace: $NameSpace"
        $Line = $Line -replace'namespace\:\s(?<NameSpace>\S+)', "namespace: `${NameSpace}$PostFix"
    }
$NewContent += $line
}
$NewContent | Out-File -FilePath $FilePath

#endregion