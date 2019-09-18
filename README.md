
# Grandfather-ExchangeMobileDevices
 Before turning on quarantine, you may want to grandfather mobile devices that are already enrolled, this script is to do just that.

# Synopsis
When changing the device policy settings in O365 from Allow to Quarantined or Blocked, all of your earlier devies that were enrolled will be blocked.
There are a couple of ways to get around this:

One way is to create all of the device rules in advance, prior to making this change.  

Another is to get a listing of all the ActiveSync Devices and grandfather existing devices in.  

This script will go into all of your users devices and set them as valid.

Please run this in your lab and test before running in production.

# Extra
Script is being executed from a Office 365 Exchange session, if you're not familiar with how to do that please go to this site:
https://www.tachytelic.net/2018/12/connect-office-365-powershell/

You will need to connect to Exchange O365 first.
You can also run this in an on-prem Exchange Management Shell

Script will be executed by someone who has the correct permissions to do so (My account has Global Admin permissions)


# Author
Renato Regalado

# Disclaimer
THIS SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.

