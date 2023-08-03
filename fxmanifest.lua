fx_version "adamant"

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

game "rdr3"

client_scripts {
	'@redm-events/dataview.lua',
	'@redm-events/events.lua',
	'client/api.lua',
	'client/main.lua',
	'client/progress.lua',
	'client/hat_tracker.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua'
}

exports {
	'DataViewNativeGetEventData'
}

files {
	'html/*',
	'html/**/*'
}

ui_page 'html/progress.html'
