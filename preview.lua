local preview = {}

preview.hide_background = false

function preview:init(mod, button, menu)
	preview.mod_path = mod.path
	if MainMenu and not Kristal.Menu_madness then -- Should i even capitalize the name of the variable
		Kristal.Menu_madness = {
			--enter_explode = Utils.random() < 1/20 and true or false
			enter_explode = false
		}
		
		local orig = Kristal.loadMod
		function Kristal.loadMod(id, ...)
			if id == mod.id then
				Assets.stopSound("ui_select")
				Assets.stopAndPlaySound(Utils.random() < 1/50 and "badexplosion" or "error")
			else
				orig(id, ...)
			end
		end
		
	end
	local menu_madness = Kristal.Menu_madness
	
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
end

function preview:draw()
end

local subfont = Assets.getFont("main", 16)
function preview:drawOverlay()
	if MainMenu and MainMenu.state == "MODSELECT" then
		-- insert not-cringe code
		-- this is supposed to be like a template
		-- .. do you get what i mean?
	end
end

return preview