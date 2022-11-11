fx_version 'adamant'
games {'rdr3'}
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'RDX'
version '1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

client_scripts {
	'client.lua'
}

ui_page "html/ui.html"

files {
	"html/*",
	"html/*.ttf"
}
