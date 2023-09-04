fx_version 'bodacious'
game 'gta5'

name 'da_qbwrapper'
author 'DaBurnerGermany'
version '1.0.4'
github 'https://github.com/DaBurnerGermany/da_qbwrapper'

lua54 'yes'

shared_scripts {
	'locale.lua'
}

client_scripts{
	'client/client.lua'
}

server_scripts {
	'server/server.lua'
}

exports {
	'getSharedObject',
	'isESX',
	'isQB'
}
server_exports {
	'getSharedObject',
	'isESX',
	'isQB'
}