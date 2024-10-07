local preview = {}

preview.hide_background = false

local mod_path = nil
local sprite_path = nil

function preview:init(mod, button, menu)
	mod_path = mod.path
	sprite_path = mod.path .. "/assets/sprites"

	--print(Utils.dump(Kristal.Mods.getMods()))
	--MainMenu.mod_list.list:addMod({hidden = false, name = "The Button", subtitle = "subtitle"})
	preview.mod_path = mod.path
	if MainMenu and not Kristal.Menu_madness then -- Should i even capitalize the name of the variable
		Kristal.Menu_madness = {
			--enter_explode = Utils.random() < 1/20 and true or false
			enter_explode = false,
		}
		
		local orig = Kristal.loadMod
		function Kristal.loadMod(id, ...)
			if id == mod.id then
				Assets.stopSound("ui_select")
				local random = Utils.random()
				Assets.stopAndPlaySound(random < 1/50 and "badexplosion" or "error")
				if random < 1/50 then -- only works like half the time, for some reason
					button.subtitle = "Explosion = Funny"
				end
				if Kristal.Menu_madness.eek_music then
					local pitch = MainMenu.music:getPitch()
					MainMenu.music:setPitch(pitch > 0.05 and pitch - 0.05 or pitch)

					pitch = MainMenu.music:getPitch()
					--print ( (tostring(pitch > 0.05)) .. " -> " .. pitch)

					if pitch <= 0.05 then
						Kristal.Menu_madness.eek_music_pitch_up = true
					end
				end
			else
				orig(id, ...)
			end
		end
		
	end

	if Utils.random() < 1/35 and not Kristal.Menu_madness.eek_music then
		MainMenu.music:stop()
		MainMenu.music:playFile(mod.path .. "/assets/music/eek.ogg", 1.3)
	end
	
    button:setColor(1, 0.5, 0.5)
    button:setFavoritedColor(1, 0, 0)

	local orig = MainMenu.onKeyPressed
	MainMenu.onKeyPressed = function(menu, key, is_repeat)
		if Kristal.Menu_madness.enter_explode and Input.isConfirm(key) then
			local uhhh = Sprite("player/heart_menu")
			uhhh:setPosition(MainMenu.heart:getPosition())
			uhhh.layer = MainMenu.heart.layer + 1
			MainMenu.stage:addChild(uhhh)
			uhhh:explode()
		end
		orig(menu, key, is_repeat)
	end
	
	Kristal.Menu_madness.enter_explode = false
	if not MainMenu then
		button.subtitle = "(kristal version outdated! cannot run)"
	elseif Utils.random() < 1/50 then
		button.subtitle = "And then it went all \"BOOOMMM!!\" Crazy right?!?"
		Kristal.Menu_madness.enter_explode = true
	elseif Utils.random() < 1/25 then
		button.subtitle = "Dark Place: Menu Edition"
	else
		button.subtitle = "Dark Place? I think not."
	end
	
end

function preview:update()
	if MainMenu then
		if Kristal.Menu_madness.eek_music_pitch_up then
			MainMenu.music:setPitch( MainMenu.music:getPitch() + 0.01 )
			if MainMenu.music:getPitch() >= 1 then
				Kristal.Menu_madness.eek_music_pitch_up = false
				MainMenu.music:setPitch(1)
			end
		end
		if MainMenu.music.current == mod_path .. "/assets/music/eek.ogg" then
			Kristal.Menu_madness.eek_music = true
		else
			Kristal.Menu_madness.eek_music = false
		end
	end
end

function preview:draw()
end

local subfont = Assets.getFont("main", 16)
function preview:drawOverlay()
	if MainMenu and MainMenu.state == "MODSELECT" then
		-- insert non-cringe code here
	end
end

return preview
