#
# Powershell script the prepares GHS logon environment


#Search for user details
$UserName = $env:USERNAME
$UserSearch = New-Object DirectoryServices.DirectorySearcher -Property @{
    Filter = "(&(objectCategory=person)(objectClass=user)(sAMAccountName= $UserName))"}
$UserResult = $UserSearch.FindOne()
$UserAttr=$UserResult.GetDirectoryEntry()
$ActiveClient = $UserAttr.Name # AD Attribute - name 
if([string]::IsNullOrEmpty($ActiveClient))
{
    $ActiveClient =  "Unknown"
}
else
{
   $ActiveClient = $ActiveClient
}
#Search for computer details
$DeviceName = $env:COMPUTERNAME
$DeviceSearch = New-Object DirectoryServices.DirectorySearcher -Property @{
    Filter = "(&(objectCategory=computer)(objectClass=computer)(cn= $DeviceName))"}
$DeviceResult = $DeviceSearch.FindOne()
$DeviceAttr=$DeviceResult.GetDirectoryEntry()
$Attr2 = $DeviceAttr.extensionattribute2 # Room Allocation
if([string]::IsNullOrEmpty($Attr2))
{
    $RoomAllocation =  "Unknown"
}
else
{
   $RoomAllocation = $Attr2
}
<#
$Attr3 = $DeviceAttr.extensionattribute3 # Device Type
if([string]::IsNullOrEmpty($Attr3))
{
    $DeviceType = "Unknown"
}
else
{
   $DeviceType = $Attr3
}

$Attr4 = $DeviceAttr.extensionattribute4 # Device Role
if([string]::IsNullOrEmpty($Attr4))
{
    $DeviceRole = "Unknown"
}
else
{
   $DeviceRole = $Attr4
}
$RegBuildVersion = Get-ItemPropertyValue -Path 'Registry::HKLM\SOFTWARE\DET\Build\' -Name MOE_BUILD_VERSION # Build Version
#$DeviceAttr.extensionattribute5 
if($RegBuildVersion -eq $null)
{
    $BuildVersion = "Unknown"    
}
else
{
   $BuildVersion = $RegBuildVersion
}
<#
$Attr6 = $DeviceAttr.extensionattribute6 # Unit Name
if([string]::IsNullOrEmpty($Attr6))
{
    $UnitName = "Unknown"
}
else
{
   $UnitName = $Attr6
}
$Attr7 = $DeviceAttr.extensionattribute7 # Unit Manager
if([string]::IsNullOrEmpty($Attr7))
{
    $UnitManager = "Unknown"    
}
else
{
   $UnitManager = $Attr7
}
$Attr8 = $DeviceAttr.extensionattribute8 # Device Custodian
if([string]::IsNullOrEmpty($Attr8))
{
    $DeviceCustodian = "Unknown"
}
else
{
   $DeviceCustodian = $Attr8
}



$Vendor = (Get-WmiObject Win32_Computersystem).Manufacturer
$MTM = (Get-WmiObject Win32_Computersystem).Model
$SerialNUmber = (Get-WmiObject -Class:Win32_BIOS).SerialNumber

$Memory = "$([math]::round((Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1024)) MB"

#Calculate C: Drive Free Space
$CDisk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
$CDisk = @{'FreeSpace' = [Math]::Round($CDisk.FreeSpace / 1GB)}
$FreeSpace = $CDisk.FreeSpace

$OSArchitecture =  (Get-WmiObject Win32_OperatingSystem).OSArchitecture
$OSEdition = (Get-WmiObject win32_operatingsystem).caption
$OSRelease = ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId)
$DomainName = $env:USERDOMAIN

#>

$siteName =  [System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite().Name
$siteContainerDN = (“CN=Sites,” + "CN=Configuration,DC=DETNSW,DC=WIN")
$siteDN = “CN=” + $siteName + “,” + $siteContainerDN
$querySite = new-object system.directoryservices.directorysearcher
$querySite.SearchRoot = "LDAP://$($siteDN)" 
$FoundSite = $querySite.findone()
$siteProperty = $FoundSite.Properties.description.split(",")
$LocationCode = $siteProperty[0]
$CurrentLocation = $siteProperty[1]

if([string]::IsNullOrEmpty($CurrentLocation)) 
{
   $CurrentLocation = "Unknown"
}
else
{
   $CurrentLocation = $CurrentLocation
}
if([string]::IsNullOrEmpty($LocationCode)) 
{
   $LocationCode = "Unknown"
}
else
{
   $LocationCode = $LocationCode
}

# DeviceOU - AD Computer - Get Computer Parent OU Description
$DeviceOUParent = $DeviceAttr.Parent
$DeviceOUSearch = new-object system.directoryservices.directorysearcher
$DeviceOUSearch.SearchRoot = "$DeviceOUParent" 
$DeviceOUDesc = $DeviceOUSearch.findone()
$DeviceOU = $DeviceOUDesc.Properties.description
if([string]::IsNullOrEmpty($DeviceOU)) 
{
   $DeviceOU = "Unknown"
}
else
{
   $DeviceOU = $DeviceOU
}

$IPAddress = (Get-NetIPAddress | Where-Object {$_.PrefixOrigin -eq "Manual" -or $_.PrefixOrigin -eq "DHCP"-and  $_.AddressFamily -eq "IPv4"}).IPAddress -join "`n"

Function Delete-NetworkPrinters
{
	$NetworkPrinters = Get-WmiObject -Class Win32_Printer | Where-Object{$_.Network}
	If ($NetworkPrinters -ne $null)
	{
		Try
		{
			Foreach($NetworkPrinter in $NetworkPrinters)
			{
				$NetworkPrinter.Delete()
				Write-Host "Successfully deleted the network printer:" + $NetworkPrinter.Name -ForegroundColor Green	
			}
		}
		Catch
		{
			Write-Host $_
		}
	}
	Else
	{
		Write-Warning "Cannot find network printer in the currently environment."
	}
}

<#
#Data displayed on wallpaper
$o = ([ordered]@{     
  
    "Device Name:" = $DeviceName
    "Vendor:" = $Vendor
    "MTM:" = $MTM
    "Serial Number:" = $SerialNUmber
    "Memory:" = "$Memory"
    "Free Space:" =  "C:\ $FreeSpace GB"
    "OS Architecture:" = $OSArchitecture
    "OS Edition:" = $OSEdition
    "OS Release ID:" = "$OSRelease `n"    
    
    "Active Client:" =  $ActiveClient
    "Domain Name:" = $DomainName 
    "Build Version:" =  $BuildVersion   
    "Current Location:" = "$CurrentLocation"
    "Location Code:" = "$LocationCode"
    "Device OU:" = "$DeviceOU"
    "Device Type:" = "$DeviceType"
    "Device Role:" = "$DeviceRole"
    "Room Allocation:" = "$RoomAllocation"
    "IP Address:" = "$IPAddress `n"
    "Last Updated:" = (Get-Date).ToString()

#   "Device Custodian:" =  "$DeviceCustodian"
#   "Unit Manager:" = "$UnitManager" 
#   "Unit Name:" = "$UnitName`n"
})
#>

#Parse user role

if ($userAttr.memberOf -match "Greystanes HS" -and $userAttr.memberOf -match "DIP management"){$role = "administrator"}
elseif ($userAttr.memberOf -match "Greystanes HS" -and $userAttr.memberOf -match "DIP management"){$role = "staff"}
else {$role = "student"}

#Parse room location

$DeviceLocation = $RoomAllocation -split ","

#Summary of Variables to be used for environment

Write-Host "Computer location: " $RoomAllocation
Write-Host "User role: " $role

#test if folder exists
$path = "\\8385dip000sf002\Mapping_Resources\_SiteConfig\_"
$printerListRaw = @()

#reading the mapping file
foreach ($num in 0..2){
    $path = $path + $DeviceLocation[$num]
    
    if ($path | Test-Path){
    Write-Host "Mapping from the following location: " $path
    $sr = New-Object System.IO.StreamReader($path + "\Printer_Mapping.txt")
    $srLineNumber = 1
        while ($sr.Peek() -ne -1){
            if ($sr.Peek() -eq 59 -or $sr.Peek() -eq 13){
                [void]$sr.ReadLine()
            }
            else {
                $line = $sr.ReadLine()
                if ($line -match 'NTWPrinter'){
                    $printerListRaw += $line
                }
            }
        }
    $sr.Dispose()

    }
}

#filter list of printers based on role
$printerListParsed = New-Object System.Collections.ArrayList($null)
foreach ($printer in 0..2){
    $defaultSetting = 0
    if ($printerListRaw[$printer] -match "default"){$defaultSetting = 1}
    $printerPath = $printerListRaw[$printer].Substring($printerListRaw[$printer].IndexOf("\")).Split('#')
    if ($printerPath[1] -match "all" -or $role -match "admin" -or $printerPath[1] -match $role ){
        [void]$printerListParsed.Add(@($printerPath[0],$printerPath[1],$defaultSetting))
    }
}
Delete-NetworkPrinters
Write-Host "The following printers will be mapped: " -ForegroundColor Green	
$printerListParsed

Write-Host "Setting printers..."

foreach ($printer in $printerListParsed){
    (New-Object -ComObject WScript.Network).AddWindowsPrinterConnection($printer[0])
    if ($printer[2]){
    (New-Object -ComObject WScript.Network).SetDefaultPrinter($printer[0])
    }
}
Write-Host "Finished"

