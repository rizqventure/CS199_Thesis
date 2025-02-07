# Copyright � 2008, Microsoft Corporation. All rights reserved.


PARAM($printerName)
#
# Update the printer driver
#
Import-LocalizedData -BindingVariable localizationString -FileName CL_LocalizationData
. .\CL_Utility.ps1

Write-DiagProgress -activity $localizationString.progress_rs_printerDriver

$updateDriverFile = GetAbsolutionPath "UpdatePrinterDriver.dll"
if ($updateDriverFile -eq $null) {
    return
}

Get-DiagInput -id "IT_UpdateDriver" -parameter @{"UPDATEDRIVER"=$updateDriverFile;"DRIVERENTRY"="UpdatePrinterDriverEntry";"PRINTERNAME"=$printerName;}