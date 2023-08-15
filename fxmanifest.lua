fx_version 'bodacious'
game 'gta5'

name 'da_qbwrapper'
author 'DaBurnerGermany'
version '1.0.0'

lua54 'yes'


client_scripts{
	'client/client.lua'
}

server_scripts {
	'server/server.lua'
}

exports {
	'getSharedObject'
}
server_exports {
	'getSharedObject'
}