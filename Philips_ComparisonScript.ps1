#Clean everything up
clear host

#Creates variables for comparison and prompts User for the Filenames to Compare
$File1 = Read-Host -Prompt 'Input the first filepath for comparison:'
$File2 = Read-Host -Prompt 'Input the second filepath for comparison:'
#Create Output File
$DATE = (Get-Date -Format FileDateTime)
$OUTFILE = (New-Item -Path "$env:USERPROFILE\Desktop\" -Name "$env:USERNAME`_Comparison_$DATE.txt" -ItemType "file")
#Compare Files
Compare-Object -ReferenceObject $(Get-Content $File1) -DifferenceObject $(get-content $File2) | Out-File -Filepath $OUTFILE