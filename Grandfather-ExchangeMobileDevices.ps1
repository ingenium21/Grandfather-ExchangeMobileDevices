#Declare an empty array to hold the output
$Output = @()

#create a custom PS Object that will be used as a template from multiple sources
$tempObj = New-Object PSObject | select DisplayName, AllowedDeviceIDs

#Create a maximum of age of devices that are to be carried over.  If the device has not synched successfully in this period, it won't be grandfathered in
$AgeLimit = 30
$DeviceAgeLimit = (Get-Date).AddDays(-$AgeLimit)

write-host "Processing Devices that have synched after:" $DeviceAgeLimit -ForegroundColor Green
Write-Host "WARNING: Only devices that have synched in the last 30 days will be ported over!"

$MailboxList = Get-CasMailbox * -resultsSize Unlimited | where {$_.ActiveSyncEnabled -eq $true} 

foreach ($Mailbox in $MailboxList) {
    $workObj = $tempObj | Select-Object *

    Write-Host "Processing Mailbox: $Mailbox " -ForegroundColor Magenta

    $DeviceIDs = @()
    $Devices = @()

    $Devices = Get-MobileDeviceStatistics -Mailbox $Mailbox.Identity

    foreach ($device in $Devices) {

        if ($DeviceAgeLimit -lt $device.LastSuccessSync) {
            Write-Host "DeviceID:  "$device.DeviceID " last synchronized on " $device.LastSuccessSync
            $DeviceIDs += $device.DeviceID
        }
        Else {
            Write-Host "DeviceID: "$device.DeviceID "has not synched in the last 30 days, skipping..."
        }

    }
    #list out the collection of devices allowed for the given user
    Write-Host "For User: $Mailbox Found " ($DeviceIDs).count " Devices"

    #populate the working Object with the necessary details
    $workObj.DisplayName = $Mailbox
    $workObj.AllowedDeviceIDs = $DeviceIDs

    #Display output to screen.
    $workObj

    $Output += $workObj
}