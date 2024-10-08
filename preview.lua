local preview = {}

preview.hide_background = false

local mod_path = nil
local sprite_path = nil

function preview:init(mod, button, menu)

    preview.button = button
    preview.mod_path = mod.path
    
    mod_path = mod.path
    sprite_path = mod.path .. "/assets/sprites"

    --print(Utils.dump(Kristal.Mods.getMods()))
    --MainMenu.mod_list.list:addMod({hidden = false, name = "The Button", subtitle = "subtitle"})
    if MainMenu and not Kristal.Menu_madness then -- Should i even capitalize the name of the variable
        Kristal.Menu_madness = {
            --enter_explode = Utils.random() < 1/20 and true or false
            enter_explode = false,
            the_button_on = true
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
    
    Kristal.Menu_madness.started = true -- so you can do things that ONLY happen when the engine is first started up

    preview.version_timer = DT*10
    preview.title_num = 1
end

function preview:update()

    preview:updatename()

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

        if Kristal.Menu_madness.the_button_on and not Kristal.Menu_madness.the_button then

            local img = love.graphics.newImage(sprite_path .. "/the_button.png")
            Kristal.Menu_madness.the_button = Sprite(img,610,240)
            local spr = Kristal.Menu_madness.the_button
            spr:setScale(2)
            spr:setOrigin(0.5,0.5)
            local xy, wh = {spr:getPosition()},{spr:getSize()}
            spr.collider = Hitbox(spr, 0,0, wh[1], wh[2])

            MainMenu.stage:addChild(Kristal.Menu_madness.the_button)
            Kristal.showCursor()
        end
        if Kristal.Menu_madness.the_button then
            Kristal.Menu_madness.the_button:setScale(Utils.approach(Kristal.Menu_madness.the_button:getScale(), 2, 0.02))
            if Kristal.Menu_madness.the_button.collider:clicked() then
                local sound = Utils.pick({
                    "badexplosion",
                    "bell",
                    "screenshake",
                    "ui_select",
                    "suslaugh",
                    "alert",
                    "awkward",
                    "bageldefeat",
                    "damage",
                    "dtrans_flip",
                    "egg",
                    "grab",
                    "icespell",
                    "impact",
                    "noise", -- generic lol
                    "phone",
                    "spare",
                    "splat",

                })
                Assets.stopAndPlaySound(sound)
                Kristal.Menu_madness.the_button:setScale(2.4)
            end
        end
    else
        if Kristal.Menu_madness.the_button then
            Kristal.Menu_madness.the_button:remove()
            Kristal.Menu_madness.the_button = nil

            Kristal.hideCursor()
        end

    end
end


function preview:updatename()

    local name = "Menu Madness Menu Madness " -- despite be commited by TFLTV this code was made by SadDiamondMan. they made the code, not me.
    local name_length = #name
    

    if preview.version_timer >= 1 then
        local x = string.sub(name, -preview.title_num + name_length/2, -preview.title_num + name_length)

        preview.button.name = x

        if preview.title_num == name_length/2 then
            preview.title_num = 0
        else
            preview.title_num = preview.title_num + 1
        end
        preview.version_timer = 0
    else
        preview.version_timer = preview.version_timer + DT*10
    end

    preview.button.rotation = math.random(6, -6)/500

    preview.button.x = 4 + math.random(2, -2)
end

return preview
