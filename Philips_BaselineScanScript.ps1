#Clean everything up and create Date/Time Variable
clear host
$DATE = (Get-Date -Format FileDateTime)
#Create the variable $BASLINE that serves as the output file on the Current User's desktop via environmental path
$BASELINE = (New-Item -Path "$env:USERPROFILE\Desktop\" -Name "$env:USERNAME`_Baseline_$DATE.txt" -ItemType "file") 

#Create the header with System Date/Time for validation
echo "Starting Baseline Scan at System Date and Time:" | Out-File -FilePath $BASELINE -Append 
Get-Date -Format g | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data showing hostname
echo "The System Hostname is:"| Out-File -FilePath $BASELINE -Append
echo "$env:computername"| Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating Groups and their users, as well as logged in users -- NEEDS FORMATTING
echo "The Local Groups and User Accounts are:" | Out-File -FilePath $BASELINE -Append
(Get-CimInstance win32_group -filter "LocalAccount='True'"  |
Select Name,@{Name="Members";Expression={
 (Get-CimAssociatedInstance -InputObject $_ -ResultClassName Win32_UserAccount).Name -join ";"
}} )| Out-File -FilePath $BASELINE -Append

#AddingLoggedOnUsers
echo "`nThe Users that are currently logged in are:" | Out-File -FilePath $BASELINE -Append
((Get-CimInstance win32_loggedonuser).Antecedent.Name | Select-Object -Unique ) | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating running processes
echo "Current Running Processes:" | Out-File -FilePath $BASELINE -Append
(Get-Process | Select-Object -Property ProcessName,Id) | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating services and their states
echo "Services on this machine:" | Out-File -FilePath $BASELINE -Append
(Get-WmiObject win32_service | Select Name,DisplayName,State | Sort State,Name ) | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating Network Information and Listening Network Sockets
echo "Network Information:" | Out-File -FilePath $BASELINE -Append
Get-NetIpAddress | Out-File -FilePath $BASELINE -Append
echo "`nListening Network Sockets" | Out-File -FilePath $BASELINE -Append
Get-NetTCPConnection -State Established,Listen | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating System Information and Configuration
echo "System Information:"| Out-File -FilePath $BASELINE -Append
Get-ComputerInfo | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating Mapped Drives
echo "Mapped Drives:" | Out-File -FilePath $BASELINE -Append
Get-PSDrive | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating Plug and Play devices
echo "Plug and Play Devices:" | Out-File -FilePath $BASELINE -Append
Get-PnpDevice | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating Shared Resources
echo "Shared Resources:" | Out-File -FilePath $BASELINE -Append
Get-CimInstance -ClassName win32_share | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append

#Create header and data enumerating Scheduled Tasks
echo "Scheduled Tasks:" | Out-File -FilePath $BASELINE -Append
Get-ScheduledTask | Out-File -FilePath $BASELINE -Append
echo "================================================" | Out-File -FilePath $BASELINE -Append