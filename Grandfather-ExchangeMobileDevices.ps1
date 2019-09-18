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
    #Copy the template object and work with that
    $workObj = $tempObj | Select-Object *

    Write-Host "Processing Mailbox: $Mailbox " -ForegroundColor Magenta
    Write-Host

    #creating a null array to store the DeviceIDs
    $DeviceIDs = @()

    #creating a null array to store the current mailbox's statistics
    $Devices = @()

    #get mobile device info for the user
    #if running on-prem, you may need to change this command to Get-ActiveSyncDeviceStatistics.  Parameters stay the same
    $Devices = Get-MobileDeviceStatistics -Mailbox $Mailbox.Identity

    #use the information retrieved above to store infromation about each Device
    foreach ($device in $Devices) {

        #evaluate the cut off time of the last successful sync to avoid any old devices
        if ($DeviceAgeLimit -lt $device.LastSuccessSync) {
            Write-Host "DeviceID:  "$device.DeviceID " last synchronized on " $device.LastSuccessSync
            $DeviceIDs += $device.DeviceID
        }
        Else {
            Write-Host "DeviceID: "$device.DeviceID "has not synched in the last 30 days, skipping..."
        }

    }
    #Write the collection of devices allowed for the given user
    #for testing i'm going to write-host this output to make sure it's correct
    write-host "Set-CASMailbox $Mailbox.Identity -ActiveSyncAllowedDeviceIDs $DeviceIDs"

    #list out the collection of devices allowed for the given user
    Write-Host "For User: $Mailbox Found " ($DeviceIDs).count " Devices"

    #populate the working Object with the necessary details
    $workObj.DisplayName = $Mailbox
    $workObj.AllowedDeviceIDs = $DeviceIDs

    #Display output to screen.
    $workObj

    $Output += $workObj
}

#Output to a CSV file if you need it. 
$Output | Export-Csv -Path $PWD\Output.csv -NoTypeInformation