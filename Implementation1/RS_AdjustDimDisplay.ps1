# Copyright � 2008, Microsoft Corporation. All rights reserved.

# Break on uncaught exceptions
trap {break}

. .\Powerconfig.ps1

#Localization Data
Import-LocalizedData localizationString

Write-DiagProgress -activity $localizationString.reset_DimDisplay

$subgroupguid = "7516b95f-f776-4464-8c53-06167f40cc99"
$settingguid = "17aaa29b-8b43-4b94-aafe-35f64daaf1ee"
$ACvalue = GetDefaultpowersetting $true $subgroupguid $settingguid
$DCvalue = GetDefaultpowersetting $false $subgroupguid $settingguid
$AC_settingvalue = Getpowersetting $true $subgroupguid $settingguid
$DC_settingvalue = Getpowersetting $false $subgroupguid $settingguid

$ObjectArray = new-object System.Collections.ArrayList

if(($AC_settingvalue -gt $ACvalue) -or ($AC_settingvalue -eq 0))
{
    $res = Setpowersetting $true $subgroupguid $settingguid $ACvalue
    #if reset AC value successfully
    if($res -eq 0)
    {
        $AC_settingvalue_original = $AC_settingvalue

        $AC_settingvalue_reset = Getpowersetting $true $subgroupguid $settingguid

        $AC_setting = New-Object -TypeName System.Management.Automation.PSObject

        Add-Member -InputObject $AC_setting -MemberType NoteProperty -Name "AC_settingvalue_original"  -Value $AC_settingvalue_original
        Add-Member -InputObject $AC_setting -MemberType NoteProperty -Name "AC_settingvalue_reset"-Value $AC_settingvalue_reset

        $ObjectArray.add($AC_setting)

    }
    $res.tostring() | convertto-xml | Update-DiagReport -id DimDisplay_AC_result -name $localizationString.Report_name_DimDisplay_AC_result -verbosity Debug
}

if((($DC_settingvalue -gt $DCvalue) -or ($DC_settingvalue -eq 0)) -and (IsLaptop))
{
    $res = Setpowersetting $false $subgroupguid $settingguid $DCvalue
    #if reset DC value successfully
    if($res -eq 0)
    {
        $DC_settingvalue_original = $DC_settingvalue
        $DC_settingvalue_reset = Getpowersetting $false $subgroupguid $settingguid

        $DC_setting = New-Object -TypeName System.Management.Automation.PSObject

        Add-Member -InputObject $DC_setting -MemberType NoteProperty -Name "DC_settingvalue_original"  -Value $DC_settingvalue_original
        Add-Member -InputObject $DC_setting -MemberType NoteProperty -Name "DC_settingvalue_reset"-Value $DC_settingvalue_reset

        $ObjectArray.add($DC_setting)

    }
    $res.tostring() | convertto-xml | Update-DiagReport -id DimDisplay_DC_result -name $localizationString.Report_name_DimDisplay_DC_result -verbosity Debug
}

if($ObjectArray.count -gt 0)
{
    $ObjectArray | select-object -Property @{Name=$localizationString.AC_settingvalue_original; Expression={$_.AC_settingvalue_original}},  @{Name=$localizationString.AC_settingvalue_reset; Expression={$_.AC_settingvalue_reset}}, @{Name=$localizationString.DC_settingvalue_original; Expression={$_.DC_settingvalue_original}},  @{Name=$localizationString.DC_settingvalue_reset; Expression={$_.DC_settingvalue_reset}} | convertto-xml | Update-DiagReport -id DimDisplay -name $localizationString.Report_name_DimDisplay
}
