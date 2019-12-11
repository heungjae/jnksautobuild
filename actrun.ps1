param(
[string] $ActIP,
[string] $ActUser,
[string] $ActPass)


$env:IGNOREACTCERTS = $true
$LocalTempDir = "c:\temp\"
If(!(test-path $LocalTempDir)) {
    New-Item -ItemType Directory -Force -Path $LocalTempDir | out-null
    }
    
$TmpPasswdFile = "$LocalTempDir\$env:USERNAME-passwd.key"

"$ActPass" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $TmpPasswdFile

if (! $env:ACTSESSIONID ){
   Connect-Act $ActIP -actuser $ActUser -passwordfile $TmpPasswdFile -ignorecerts | Out-Null
}

$verlist = udsinfo lsversion
foreach ($verid in $verlist) {
  write-output "comp = $verid.component, ver = $verid.version"
}

$verlist2 = udsinfo lsversion
foreach ($verid2 in $verlist) {
  write-output "installed = $verid2.installed, ver = $verid2.version"
}

udsinfo lscluster

if (! $env:ACTSESSIONID ){
  write-warning "Login to VDP $ActIP failed"
  break
} else {   
  Disconnect-Act | Out-Null
} 
