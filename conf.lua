function love.conf(t)
	t.title = "Wild Gunners"
	t.version = "0.9.1"
	t.game_version = "00001"
	t.window.width = 800
	t.window.height = 600
	t.os = {
        "love",
        windows = {
            x32       = true,
            x64       = true,
            installer = false,
            appid     = nil,
        },
        "osx",
        "debian",
    }
end