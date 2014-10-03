io.stdout:setvbuf("no")

function love.conf(t)
	t.window.title = 'Around the World in 80 Days'
	t.window.width = 1024
	t.window.height = 768
	t.window.fsaa = 2
	t.modules.physics = false
	t.modules.joystick = false
	t.modules.sound = false
	t.modules.thread = false
	t.modules.system = false
	t.modules.audio = false
end
