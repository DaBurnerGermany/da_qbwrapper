# da_qbwrapper
This script allowes you to use ESX-Ressources in QB-Framework

## how to use
1. download you ESX-Script you want ot use.
2. replace ESX = exports["es_extended"]:getSharedObject() or TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) to ESX = exports["da_qbwrapper"]:getSharedObject()
3. Make sure to Start this script before your ESX-Script and after qb-core.
4. Run your ESX-Script

## Database users => players
IF your script uses the users table of ESX make sure that you replace it with the players table of QB, this won't get replaced!

## Support
IF you have any errors with this script make an issue or concat me directly on Discord.. DaBurnerGermany is the tag you wanna search.

## Others
Enjoy! :)
