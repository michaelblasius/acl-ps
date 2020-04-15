#Access Control List PowerShell Script
#20200415.02
function Show-Menu
{
     param (
           [string]$Title = 'Location'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press '1' Network Share."
     Write-Host "2: Press '2' Local Drive."
     Write-Host "Q: Press 'Q' to quit."
}
do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
				$DomainName = Read-Host -Prompt "domain" #domain name
				$UserName = Read-Host -Prompt "username" #user with rights
				$OpenDrive = Read-Host -Prompt "open drive letter (letter only)" #drive letter only that is available in system
				$path = Read-Host -Prompt "network path"  #define path to the shared folder
				$reportpath ="C:\acl.csv" #define path to export permissions report
				New-PSDrive -Name $OpenDrive -PSProvider FileSystem -Root $path -Credential $DomainName\$UserName
				dir -Recurse $path | where { $_.PsIsContainer } | % { $path1 = $_.fullname; Get-Acl $_.Fullname | % { $_.access | Add-Member -MemberType NoteProperty '.\Application Data' -Value $path1 -passthru }} | Export-Csv $reportpath
				Remove-PSDrive $OpenDrive
				echo "saving to $reportpath"
				exit
           } '2' {
                cls
				$path = Read-Host -Prompt "Folder location (ie c:\)"  #define path to the folder
				$reportpath ="C:\acl.csv" #define path to export permissions report
				dir -Recurse $path | where { $_.PsIsContainer } | % { $path1 = $_.fullname; Get-Acl $_.Fullname | % { $_.access | Add-Member -MemberType NoteProperty '.\Application Data' -Value $path1 -passthru }} | Export-Csv $reportpath
				echo "saving to $reportpath"
				exit
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')