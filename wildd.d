local numPlayerAllowed = 1 -- edit number, also make sure to like lolies

while not game:IsLoaded() do
    wait(1)
end

if #game.Players:GetPlayers() > numPlayerAllowed and game.PlaceId == 536102540 then
    game:Shutdown()
end

-- LocalScript (place it in StarterPlayerScripts or appropriate LocalScript context)

local StarterGui = game:GetService("StarterGui")

-- Your full script logic here
-- Example action:
print("Full script executed!") -- Replace with your actual script logic

-- Show notification in bottom-right corner
StarterGui:SetCore("SendNotification", {
    Title = "Script Executed";
    Text = "1 Person Per Server";
    Duration = 5; -- Duration in seconds
})

--// Settings
local Settings = {
    ["SlotWaitTime"] = 0.27, -- Time it takes between the last two chats
    ["KamiWaitTime"] = 0.27, -- Time it takes to talk to kami after slot switch
    ["HideName"] = "none",   -- "none" to disable
    ["StopAfter"] = 0,       -- 0 to disable
    ["LowGFX"] = true,       -- Enable low graphics?
    
    ["KibitoTalkWaitTime"] = 0.27, -- Time between Kibito's chat steps
    ["TeleportPlaceId"] = 536102540, -- Place ID for "world of the living"
    ["RetryIfFailed"] = true, -- Retry teleport if it fails
    ["StartDelay"] = 5, -- Delay before starting to talk to Kibito (seconds)
}

Accounts = {
    ["MP5KZ2"] = {
        ["Main"] = 1;
        ["Namek"] = 2;
    };
    ["MysteriousWalker52"] = {
        ["Main"] = 1;
        ["Namek"] = 2;
    };
    ["llVoidDummyll"] = {
        ["Main"] = 1;
        ["Namek"] = 2;
    };
    ["Voidwalking1"] = {
        ["Main"] = 3;
        ["Namek"] = 2;
    };
    ["SweeterXIII"] = {
        ["Main"] = 2;
        ["Namek"] = 1;
    };
}

Debug = false;

--[[
keep in mind, this source was never supposed to be given out lmao
created by aloof because I never gave myself credit
]]-- 

repeat
    task.wait()
until game:IsLoaded()
repeat
    task.wait()
until game.Players.LocalPlayer.Character
function getVars()
    plr = game.Players.LocalPlayer
    char = plr.Character
    hrp = char:WaitForChild("HumanoidRootPart")
    bp = plr:WaitForChild("Backpack")
    st = bp:FindFirstChild("ServerTraits")
end
getVars()
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    getVars()
end)
function notif(Title1,Message1) -- my old cmd notify func cus I can't remember how to make it
    game:GetService("StarterGui"):SetCore(
        "SendNotification",
        {
            Title = Title1,
            Text = Message1,
        }
    )
end

--// Settings
local Settings = {
    ["SlotWaitTime"] = 0.27, -- Time it takes between the last two chats
    ["KamiWaitTime"] = 0.27, -- Time it takes to talk to kami after slot switch
    ["HideName"] = "none",   -- "none" to disable
    ["StopAfter"] = 0,       -- 0 to disable
    ["LowGFX"] = true,       -- Enable low graphics?
    
    ["KibitoTalkWaitTime"] = 0.27, -- Time between Kibito's chat steps
    ["TeleportPlaceId"] = 536102540, -- Place ID for "world of the living"
    ["RetryIfFailed"] = true, -- Retry teleport if it fails
    ["StartDelay"] = 2, -- Delay before starting to talk to Kibito (seconds)
}

--// Variables
local Player = game.Players.LocalPlayer
local Teleporting = false

--// Functions
local function WaitTill(instance, Text)
    repeat task.wait() until (instance.Text == Text and Player.PlayerGui.HUD.Bottom.ChatGui.Visible == true)
end

local function Talk(NPC, Content, WaitTime, Texts, WaitForText)
    if not Player.Backpack:FindFirstChild("ServerTraits") then
        Player.Backpack:WaitForChild("ServerTraits", 30)
    end

    -- Start chat
    Player.Backpack.ServerTraits.ChatStart:FireServer(workspace.FriendlyNPCs[NPC])

    for i = 1, #Content do
        if WaitForText then
            WaitTill(Player.PlayerGui.HUD.Bottom.ChatGui.TextLabel, Texts[i])
            task.wait(WaitTime)
        else
            task.wait(WaitTime + 0.25)
        end

        Player.Backpack.ServerTraits.ChatAdvance:FireServer({Content[i]})
    end
end

local function TeleportToLivingWorld()
    if Teleporting then return end
    Teleporting = true

    print("Waiting "..Settings.StartDelay.." seconds before talking to Kibito...")
    task.wait(Settings.StartDelay)

    print("Talking to Kibito...")

    Talk(
        "Kibito", -- NPC
        {"Yes"}, -- Choice
        Settings.KibitoTalkWaitTime, -- Wait time
        {"Interested in visiting the world of the living?"}, -- Text to wait for
        true -- Wait for text
    )

    print("Finished talking to Kibito. Waiting for teleport...")

    task.spawn(function()
        local StartTime = os.clock()
        repeat
            task.wait(0.5)
            if game.PlaceId == Settings.TeleportPlaceId then
                print("✅ Successfully teleported to Living World!")
                Teleporting = false
                return
            end
        until os.clock() - StartTime > 10 -- timeout 10 sec

        print("❌ Teleport failed.")
        Teleporting = false

        if Settings.RetryIfFailed then
            print("Retrying teleport...")
            task.wait(2)
            TeleportToLivingWorld()
        end
    end)
end

--// Auto-Start (ONLY if in PlaceId 3552157537)
if game.PlaceId == 3552157537 then
    print("In correct place (3552157537), starting Kibito teleport...")
    TeleportToLivingWorld()
else
    print("Not in the correct place. Script not running.")
end

function getAcc()
    if game.PlaceId == 552500546 then return end
    for i,v in pairs(Accounts) do
        if i:lower() == (plr.Name):lower() then
            return v["Main"], v["Namek"]
        end
    end
    return false
end
if getAcc() == false then
    notif("Inf stat","Account not found")
    return
end
local MainSlot, NamekSlot = getAcc()
function stop()
    if Settings["StopAfter"] == 0 then return end
    local tL = plr.PlayerGui.HUD.Bottom.Stats.StatPoints.Val
    if tonumber(tL.Text) >= Settings["StopAfter"] then
        return false
    end
end

function getKami()
    for i,v in pairs(game:GetDescendants()) do
        if v.Name == "KAMI" then
            if v.Parent.Name == "Hidden" or v.Parent.Name == "FriendlyNPCs" then
                return v
            end
        end
    end
end
function anti_afk()
    plr.Idled:Connect(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end
anti_afk()
function getLvl()
    for i,v in pairs(char:GetChildren()) do
        if v.Name:find("Lvl.") and v.Name:match("Lvl.%s(%d+)") then
            return tonumber(v.Name:match('Lvl.%s(%d+)'))
        end
    end
    return false
end -- overcomplicated func. just fucking with string patterns
function debugPrt(arg)
    if Debug then
        print(arg)
        return
    end
    return false
end
function reJoin()
    plr:Kick("Rejoining, don't leave like Nebi did")
    task.wait(0.2)
    game:GetService("TeleportService"):Teleport(game.PlaceId,plr)
end
function load()
    debugPrt("Load Starting")
    if game.PlaceId == 552500546 then return end
    repeat task.wait(); debugPrt("Waiting for Char") until char
    char:WaitForChild("PowerOutput",5)
    debugPrt(char:FindFirstChild("PowerOutput"))
    if not char:FindFirstChild("PowerOutput") then
        debugPrt("P/O not found")
        reJoin()
        return
    end
    local tim = os.time()
    repeat task.wait() until (getLvl() ~= false) or (os.time()-tim) > 5
    if os.time()-tim > 5 then
        reJoin()
        return
    end
    debugPrt("getLvl() was true")
    return true
end
load()
debugPrt("Initial load function completed")
function getSlot()
    if char:FindFirstChild("Head") and char:FindFirstChild("Race") then
        local race = char:FindFirstChild("Race")
        if race.Value == "Namekian" then
            if getLvl() <= 100 then
                return "Namek"
            end
        end
    end
    return "Main"
end
function findQuestGiver(questChat)
    for i,v in pairs(game.Workspace.FriendlyNPCs:GetDescendants()) do
        if v.Name == "Chat" and v:IsA("StringValue") and v.Value == questChat then
            return v
        end
    end
end
function cAd(chat)
        st.ChatAdvance:FireServer({tostring(chat)})
    task.wait(0.6)
end
function lvlUp()
    if getSlot() == "Namek" then
        if getLvl() < 50 then
            local fNPC = game.Workspace.FriendlyNPCs
            st.ChatStart:FireServer(fNPC.Bulma.Chat)
            task.wait(0.4)
            cAd("k")
            cAd("Yes")
            cAd("k")
            st.ChatStart:FireServer(fNPC:FindFirstChild("SpaceShip"))
            task.wait(0.4)
            cAd("No")
            cAd("k")
            st.ChatStart:FireServer(findQuestGiver("I heard there's a spaceship in Yunzabit Heights").Parent)
            task.wait(0.4)
            cAd("k")
            cAd("Yes")
            cAd("k")
            st.ChatStart:FireServer(fNPC.NamekianShip)
            task.wait(0.4)
            cAd("No")
            cAd("k")
            st.ChatStart:FireServer(fNPC["Trunks [Future]"])
            task.wait(0.4)
            cAd("k")
            cAd("Yes")
            cAd("k")
            st.ChatStart:FireServer(fNPC.TimeMachine)
            task.wait(0.4)
            cAd("No")
            cAd("k")
            st.ChatStart:FireServer(fNPC["Elder Kai"])
            task.wait(0.4)
            cAd("k")
            cAd("Yes")
            cAd("k")
            cAd("k")
            st.ChatStart:FireServer(fNPC["Korin"].Chat.Chat)
            task.wait(0.4)
            st.ChatAdvance:FireServer({"k"})
            task.wait(0.4)
            st.ChatAdvance:FireServer({"k"})
            task.wait(0.4)
            st.ChatAdvance:FireServer({"DRINK"})
            task.wait(0.4)
            st.ChatAdvance:FireServer({"k"})
        end
    end
end
function resetChar()
    if game.placeId == 552500546 then
        repeat
            task.wait()
        until plr.Backpack:FindFirstChild("Scripter"):FindFirstChild("Setup"):FindFirstChild("Frame"):FindFirstChild("Side").Visible == true
        task.wait(4)
        bp.Scripter.RemoteEvent:FireServer(bp.Scripter.Setup.Frame.Side.Race,"up")
        task.wait(1)
        bp.Scripter.RemoteEvent:FireServer("woah")
        task.wait(1)
        game:Shutdown()
    else
        st.ChatStart:FireServer(game.Workspace.FriendlyNPCs["Start New Game [Redo Character]"])
        task.wait(0.4)
        st.ChatAdvance:FireServer({"Yes"})
        task.wait(0.4)
        st.ChatAdvance:FireServer({"k"})
        task.wait(0.4)
        st.ChatAdvance:FireServer({"Yes"})
        task.wait(1)
        game:GetService("TeleportService"):Teleport(552500546)
    end
end
function getName()
    if Settings["HideName"]:lower() ~= ("None"):lower() then
        return Settings["HideName"]
    else
        return plr.Name
    end
end
debugPrt("Functions loaded correctly")
success = false
resetSlot = false
notif("Inf Stat","Public Version V4")
function doTheInf()
debugPrt("doTheInf function started")
local timeToWait = 10

    if stop() == false then
        return
    end

    if game.PlaceId == 552500546 then
        resetChar()
        return
    end;
    success = false
    if game.GameId ~= 210213771 then -- not in fs nigger!
        return
    end

    if game.PlaceId ~= 536102540 then
        -- teleport or say fuck it
        return;
    end
    repeat task.wait() until getSlot() ~= nil
    debugPrt("Passed initial functions in doTheInf function")
    if getSlot() == "Namek" then
        debugPrt("Namekian slot found")
        if getLvl() < 50 then
            debugPrt("Namekian is lvl < 50, leveling up the slot")
            local time = os.time()
            repeat
                lvlUp() -- levels up if you're below level 50
                task.wait(5)
            until ((os.time()-time) >= 60) or (getLvl() >= 50)
            task.wait(3)
            if(os.time()-time >= 60 and getLvl() < 50) then -- failed!
                reJoin()
                return
            elseif getLvl() >= 50 then
                doTheInf()
            end
        end;
        if getLvl() >= 50 then
            debugPrt("Lvl >= 50")
            if (getKami() == false) or (resetSlot == true)  then
                debugPrt("Kami not found")
                if getLvl() > 100 then return end
                notif("Test","shit is NOT WORKING....... resetting slot :(")
                task.wait(5)
                resetChar() -- if kami is bugged, resets the character, restarting the cycle
                return
            end
            local chatStart = st.ChatStart
            local chatAdv  = st.ChatAdvance
            local textLabel = plr.PlayerGui:WaitForChild("HUD"):WaitForChild("Bottom"):WaitForChild("ChatGui").TextLabel
            local time = os.time()
            local done = false
            local chatted_with_kami = false
            resetSlot = false
            repeat task.wait(); chatStart:FireServer(game.Workspace.FriendlyNPCs:FindFirstChild("Character Slot Changer")); until textLabel.text == "Change Character Slots?" or (os.time()-time) >= timeToWait
            repeat task.wait(); chatAdv:FireServer({"Yes"}) until textLabel.text == "Alright" or (os.time()-time) >= timeToWait
            repeat task.wait(); chatAdv:FireServer({"k"}) until textLabel.text == "Which slot would you like to play in?" or (os.time()-time) >= timeToWait
            task.wait(0.1)
            if textLabel.text ~= "Which slot would you like to play in?" then
                doTheInf()
                return
            end
            task.wait(Settings["SlotWaitTime"])
            chatAdv:FireServer({"Slot"..tostring(MainSlot)})
            task.wait(Settings["KamiWaitTime"])
            if textLabel.text ~= "Loading!" then
                debugPrt("Redoing")
                doTheInf()
                return
            end
            local kami = getKami()
            local kamiChat = function()
                st.ChatStart:FireServer(kami.Chat)
                st.ChatAdvance:FireServer({"k"})      
            end
            repeat task.wait(); kamiChat() until textLabel.Text == "Mr Popo is a nice guy" or textLabel.Text == "Alright let's do it" or not plr.PlayerGui:FindFirstChild("HUD")
            if textLabel.Text == "Mr Popo is a nice guy" then
                resetSlot = true
                notif("Inf stat","Reset slot yay")
            elseif textLabel.Text == "Alright let's do it" then
                task.wait(0.3)
                if not hrp:FindFirstChild("Booster") then
                    reJoin()
                    return
                end
            end
            task.wait(0.8)
            if plr.PlayerGui:FindFirstChild("HUD") then
                if hrp:FindFirstChild("Booster") then
                    resetSlot = true
                    task.wait(3)
                    resetChar()
                end
            elseif not plr.PlayerGui:FindFirstChild("HUD") then
                chatted_with_kami = true
            end
            debugPrt("Namekian side completed")
        end
    elseif getSlot() == "Main" then
        debugPrt("Main Started")
        local chatStart = st.ChatStart
        local chatAdv  = st.ChatAdvance
        local textLabel = plr.PlayerGui:WaitForChild("HUD"):WaitForChild("Bottom"):WaitForChild("ChatGui"):WaitForChild("TextLabel")
        local done = false  
        local fucked_up_main_slot_change = false
        local time = os.time()
        repeat chatStart:FireServer(game.Workspace.FriendlyNPCs:FindFirstChild("Character Slot Changer")); task.wait();  until textLabel.text == "Change Character Slots?" or (os.time()-time) >= timeToWait
        repeat chatAdv:FireServer({"Yes"}); task.wait(); plr.PlayerGui.HUD.Bottom.ChatGui.Visible = true until textLabel.text == "Alright" or (os.time()-time) >= timeToWait
        repeat chatAdv:FireServer({"k"}); task.wait(); until textLabel.text == "Which slot would you like to play in?" or (os.time()-time) >= timeToWait
        repeat chatAdv:FireServer({"Slot"..tostring(NamekSlot)}); task.wait(0.15); until textLabel.text == "Loading!" or (os.time()-time) >= timeToWait
        task.wait(0.9)
        if plr.PlayerGui:FindFirstChild("HUD") then
            doTheInf()
            return
        end
        task.wait(0.5)
        if not plr.PlayerGui:FindFirstChild("HUD") then done = true end
    end
    success = true
end

plr.CharacterAdded:Connect(function()
    local t = tick()
    load()
    plr.PlayerGui.HUD.Bottom.Stats.Labvel.TextLabel.Text = "Player Stats"
    plr.PlayerGui.HUD.Bottom.Stats.Namae.Val.Text = getName()
    plr.PlayerGui.HUD.Bottom.Stats.Visible = true
    doTheInf()
end)
doTheInf()

-- Function to enable low graphics
local function enableLowGFX()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain

    -- Set terrain settings to minimal
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 1  -- Make water invisible for maximum performance

    -- Set lighting settings to minimal (without making it too dark)
    l.GlobalShadows = false
    l.FogEnd = 9e9  -- No fog
    l.Brightness = 0.5  -- Slightly dim, but not too dark
    l.Ambient = Color3.fromRGB(128, 128, 128)  -- Neutral ambient lighting
    l.OutdoorAmbient = Color3.fromRGB(128, 128, 128)  -- Neutral outdoor lighting

    -- Set rendering quality to minimum
    settings().Rendering.QualityLevel = "Level01"  -- Lowest rendering quality
    settings().Rendering.SmoothLighting = false    -- No smooth lighting
    settings().Rendering.SunRaysQuality = "None"   -- No sun rays
    settings().Rendering.TextureQuality = "Low"    -- Lowest texture quality
    settings().Rendering.ShadowQuality = "Low"     -- No shadows
    settings().Rendering.ParticleQuality = "Low"   -- No particles

    -- Adjust game objects for minimal performance
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.Transparency = 1  -- Make all parts fully transparent (not visible)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1  -- Make decals and textures invisible
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)  -- Stop particle emitters
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1  -- Disable explosions' effects
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false  -- Disable fire, spotlight, smoke, sparkles
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957  -- Replace texture with a simple one
        end
    end

    -- Disable all visual effects in Lighting
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false  -- Turn off all post-processing effects
        end
    end

    -- Disable all shadows (global and parts)
    game.Lighting.GlobalShadows = false
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CastShadow = false  -- Disable shadows for individual parts
        end
    end

    -- Disable physics for parts that don't need it
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored then
            part.Anchored = true  -- Disable physics for non-moving parts
        end
    end

    -- Disable all sounds in the game
    for _, sound in pairs(game:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Stop()  -- Stop any sounds that are playing
        end
    end

    -- Optional: Disable camera effects like depth of field, and blur
    local Camera = game.Workspace.CurrentCamera
    Camera.FieldOfView = 70  -- Default camera FOV (field of view)
    Camera.CameraType = Enum.CameraType.Custom  -- Use the standard camera

    -- Disable animations (if needed) to reduce additional overhead
    for _, animator in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if animator:IsA("Animator") then
            animator:Stop()  -- Stop all animations
        end
    end
end

-- Function to disable low graphics (restore to normal)
local function disableLowGFX()
    -- Reset terrain settings
    local t = game.Workspace.Terrain
    t.WaterWaveSize = 1
    t.WaterWaveSpeed = 1
    t.WaterReflectance = 0.5
    t.WaterTransparency = 0

    -- Reset lighting settings
    local l = game.Lighting
    l.GlobalShadows = true
    l.FogEnd = 100000
    l.Brightness = 2
    l.Ambient = Color3.fromRGB(255, 255, 255)
    l.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

    -- Reset rendering quality
    settings().Rendering.QualityLevel = "Level03"  -- Default quality
    settings().Rendering.SmoothLighting = true
    settings().Rendering.SunRaysQuality = "High"
    settings().Rendering.TextureQuality = "High"
    settings().Rendering.ShadowQuality = "High"
    settings().Rendering.ParticleQuality = "High"

    -- Reset game objects
    for i, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = "SmoothPlastic"
            v.Reflectance = 0.5
            v.Transparency = 0  -- Make parts visible again
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0  -- Make decals and textures visible again
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(1)  -- Enable particle emitters
        elseif v:IsA("Explosion") then
            v.BlastPressure = 5000
            v.BlastRadius = 50  -- Reset explosion settings
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = true  -- Enable fire, spotlight, smoke, sparkles
        elseif v:IsA("MeshPart") then
            v.Material = "SmoothPlastic"
            v.Reflectance = 0.5
            v.TextureID = 0  -- Restore original texture
        end
    end

    -- Enable all visual effects in Lighting
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = true  -- Enable all post-processing effects
        end
    end

    -- Enable shadows (global and parts)
    game.Lighting.GlobalShadows = true
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CastShadow = true  -- Enable shadows for individual parts
        end
    end

    -- Re-enable physics
    for _, part in pairs(game.Workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false  -- Re-enable physics
        end
    end

    -- Re-enable all sounds in the game
    for _, sound in pairs(game:GetDescendants()) do
        if sound:IsA("Sound") then
            sound:Play()  -- Start sounds again
        end
    end

    -- Re-enable GUI elements
    local Player = game.Players.LocalPlayer
    local PG = Player.PlayerGui
    -- Add back any necessary GUIs here
end

-- Check LowGFX setting and apply the appropriate function
if Settings["LowGFX"] then
    enableLowGFX()  -- Enable low graphics
else
    disableLowGFX()  -- Disable low graphics
end
