<#
//-----------------------------------------------------------------------

//     Copyright (c) {charbelnemnom.com}. All rights reserved.

//-----------------------------------------------------------------------

.SYNOPSIS
Converts the format, version type, and block size of a virtual hard disk (VHD) file.

.DESCRIPTION
Converts the format, version type, and block size of multiple virtual hard disk (VHD) files to VHDX.

.NOTES
File Name : ConvertTo-VHDX.ps1
Author    : Charbel Nemnom
Version   : 1.1
Date      : 10-February-2018
Update    : 12-February-2018
Requires  : PowerShell Version 4.0 or above
OS        : Windows Server 2012 R2 or above
Product   : Microsoft Hyper-V 2012 R2 or above

.LINK
To provide feedback or for further assistance please visit:
https://charbelnemnom.com

.EXAMPLE
./ConvertTo-VHDX -Source <SourcePath> -Destination <DestinationPath> -DirectoryName <DirectoryName>
This example converts all VHD in a source path to VHDX in a destination path, and finally set the PhysicalSectorSizeBytes to 4096.
A converted VHDX file has a physical sector size of 512 Bytes. 
However, when you create a new VHDX file it has a physical sector size of 4K. 
#>

[CmdletBinding()]
param (
    [Parameter(Position=0, Mandatory=$true, HelpMessage = 'Source Path')]
    [Alias('Source')]
    [String]$SourcePath,
    [Parameter(Position=1, Mandatory=$true, HelpMessage = 'Destination Path')]
    [Alias('Destination')]
    [String]$DestinationPath
)

If (-not(Test-Path -Path "$SourcePath\*" -Filter *.VHD)){
    Write-Warning -Message "Source Path does not contain VHD format, Please specify a correct source path"
    Exit
}

If (!(Test-Path -Path "$DestinationPath")){
    Write-Warning -Message "Destination Path does not exist, Please specify a correct destination path"
    Exit
}

# Convert-VHD
Get-ChildItem -Path "$SourcePath" -Recurse -Filter *.VHD | `
ForEach-Object {Convert-VHD -Path $_.FullName -Destination ("$DestinationPath" + ".vhdx")}

# Set-VHD to 4K
Get-ChildItem -Path "$DestinationPath" -Recurse -Filter *.VHDX | `
ForEach-Object {Set-VHD -Path $_.FullName -PhysicalSectorSizeBytes 4096}