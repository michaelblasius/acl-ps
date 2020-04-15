$DomainName = Read-Host -Prompt "domain" #domain name
$UserName = Read-Host -Prompt "username" #user with rights
$OpenDrive = Read-Host -Prompt "open drive letter (letter only)" #drive letter only that is available in system
$RootPath = Read-Host -Prompt "network path (\\server\share)"  #define path to the shared folder
New-PSDrive -Name $OpenDrive -PSProvider FileSystem -Root $path -Credential $DomainName\$UserName
$OutFile = "C:\Permissions.csv"
$Header = "Folder Path,IdentityReference,AccessControlType,IsInherited,InheritanceFlags,PropagationFlags"
Del $OutFile
New-Item -Path $OutFile
Add-Content -Value $Header -Path $OutFile 
$Folders = dir $RootPath -recurse | where {$_.psiscontainer -eq $true}

foreach ($Folder in $Folders){
	$ACLs = get-acl $Folder.fullname | ForEach-Object { $_.Access  }
	Foreach ($ACL in $ACLs){
	$OutInfo = $Folder.Fullname + "," + $ACL.IdentityReference  + "," + $ACL.AccessControlType + "," + $ACL.IsInherited + "," + $ACL.InheritanceFlags + "," + $ACL.PropagationFlags
	Add-Content -Value $OutInfo -Path $OutFile
	}}
Remove-PSDrive $OpenDrive
echo "saving to $OutFile"