-- High.XD GUI: Final Fixed Version with Working Close, Minimize, Toggle, and R15 Button

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "HighXD_GUI_Cleaned"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local base = Instance.new("Frame", gui)
base.Size = UDim2.new(0, 600, 0, 360)
base.Position = UDim2.new(0.5, -300, 0.5, -180)
base.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Instance.new("UICorner", base).CornerRadius = UDim.new(0, 10)

local top = Instance.new("Frame", base)
top.Size = UDim2.new(1, 0, 0, 36)
top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", top)
title.Text = "High.XD"
title.Font = Enum.Font.SourceSansSemibold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", top)
close.Text = "✕"
close.Size = UDim2.new(0, 36, 1, 0)
close.Position = UDim2.new(1, -36, 0, 0)
close.TextColor3 = Color3.fromRGB(255, 80, 80)
close.Font = Enum.Font.SourceSans
close.TextSize = 22
close.BackgroundTransparency = 1

local minimize = Instance.new("TextButton", top)
minimize.Text = "–"
minimize.Size = UDim2.new(0, 36, 1, 0)
minimize.Position = UDim2.new(1, -72, 0, 0)
minimize.TextColor3 = Color3.fromRGB(200, 200, 200)
minimize.Font = Enum.Font.SourceSans
minimize.TextSize = 28
minimize.BackgroundTransparency = 1

local navHolder = Instance.new("ScrollingFrame", base)
navHolder.Size = UDim2.new(0, 140, 1, -36)
navHolder.Position = UDim2.new(0, 0, 0, 36)
navHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
navHolder.ScrollBarThickness = 5
navHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", navHolder).CornerRadius = UDim.new(0, 8)

local navList = Instance.new("UIListLayout", navHolder)
navList.SortOrder = Enum.SortOrder.LayoutOrder
navList.Padding = UDim.new(0, 4)

local content = Instance.new("Frame", base)
content.Size = UDim2.new(1, -140, 1, -36)
content.Position = UDim2.new(0, 140, 0, 36)
content.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 8)

local pages = Instance.new("Folder", content)
pages.Name = "Pages"

local function createTab(name, buttons)
	local btn = Instance.new("TextButton", navHolder)
	btn.Size = UDim2.new(1, -10, 0, 28)
	btn.Text = name
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 18
	btn.TextColor3 = Color3.fromRGB(230, 230, 230)
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

	local section = Instance.new("Frame", pages)
	section.Name = name
	section.Size = UDim2.new(1, 0, 1, 0)
	section.Visible = false
	section.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", section)
	layout.Padding = UDim.new(0, 10)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	for _, info in ipairs(buttons) do
		local b = Instance.new("TextButton", section)
		b.Size = UDim2.new(0, 240, 0, 36)
		b.Text = info[1]
		b.Font = Enum.Font.Gotham
		b.TextSize = 16
		b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		b.TextColor3 = Color3.fromRGB(255, 255, 255)
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseButton1Click:Connect(info[2])
	end

	btn.MouseButton1Click:Connect(function()
		for _, s in pairs(pages:GetChildren()) do s.Visible = false end
		section.Visible = true
	end)
end

-- Home tab with reanimation button
createTab("Home", {
	{"R15 Animation", function()
		
    Players = game:GetService("Players")
    Workspace = game:GetService("Workspace")
    UserInputService = game:GetService("UserInputService")
    RunService = game:GetService("RunService")
    ReplicatedStorage = game:GetService("ReplicatedStorage")
    TweenService = game:GetService("TweenService")
    LocalPlayer = Players.LocalPlayer
    HttpService = game:GetService("HttpService") -- Get HttpService for JSON
    
    -- Variables for state storage
    local ghostEnabled = false
    local originalCharacter
    local ghostClone
    local originalCFrame
    local originalAnimateScript
    local updateConnection
    
    -- Variable to store the original HipHeight of the clone
    local ghostOriginalHipHeight
    
    -- Clone settings: overall scale and extra width factor (default = 1, i.e., original size)
    local cloneSize = 1
    local cloneWidth = 1
    
    -- Tables to store the original sizes of parts and Motor6D CFrames (for non-uniform scaling)
    local ghostOriginalSizes = {}
    local ghostOriginalMotorCFrames = {}
    
    -- List of body parts to synchronize
    local bodyParts = {
    "Head", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }
    
    -- Built-in Animations R15 (Example - you can expand this table)
    -- Built-in Animations R15
local BuiltInAnimationsR15 = {
    ["griddy"] = 8916572099,
    ["orange justice"] = 11212163754,
    ["seqa"] = 113197266804415,
    ["twerk"] = 77493234914180,
    ["worm"] = 7160307855,
    ["dougie"] = 7619764422,
    ["weeknd"] = 15643535842,
    ["RAT"] = 7135288116,
    ["LUNAR"] = 11767212398,
    ["tyla"] = 18218681238,
    ["caffeniated"] = 94939091699336,
    ["jabba"] = 10646825705,
    ["outwest"] = 9848086412,
    ["mufasa"] = 91350748363698,
    ["slickback"] = 16570530493,
    ["california"] = 10844909971,
    ["billy bounce"] = 8917592832,
    ["speed"] = 16455715993,
    ["AD"] = 8720728883,
    ["scenario"] = 8924083749,
    ["embrace"] = 72117290471362,
    ["A"] = 85510928563896,
    ["nazi"] = 93170225110433,
    ["lapdaCE"] = 18726264577,
    ["dogg"] = 132477655284495,
    ["bugha"] = 120219890159884,
    ["SPIDER3"] = 8228461600,
    ["AD"] = 72555904469135,
    ["egypt"] = 16906415457,
    ["a"] = 94631359696320,
    ["world"] = 16006724706,
    ["ASS"] = 7070158948,
    ["L"] = 7160050144,
    ["l"] = 16197768633,
    ["DEAD"] = 18851345656,
    ["DRAKE"] = 135788271145619,
    ["a"] = 11056185537,
    ["a"] = 107788763755159,
    ["rollie"] = 139528127590899,
    ["ambitious"] = 18705619831,
    ["mask off"] = 72256725363371,
    ["other twerk"] = 91014640753525,
    ["AD"] = 127818220981023,
    ["neymar"] = 17090375482,
    ["belly"] = 14765075073,
    ["ad"] = 12256726178,
    ["ride it"] = 6863561770,
    ["suck"] = 109075167996134,
    ["Lay Down Jerk🤨📷"] = 95421373878235,
    ["suck it😭"] = 101555445003253,
    ["Propose💍"] = 132065459234038,
    ["car🚗"] = 124347166122116,
    ["peeing😭"] = 83050872634433,
    ["scooter🛴😭"] = 83679388563782,
    ["jerk ?"] = 100326364261785,
    ["Tank😭🔪"] = 139536023841932,
    ["buttface😭"] = 96417733315159,
    ["Backshotted V2💀😭"] = 94185561525265,
    ["Dog peeing😭🙏"] = 110112282374944,
    ["scissor💀"] = 80874465275235,
    ["phut hon"] = 16455464780,
    ["Sturdy🔥"] = 137959340008695,
    ["Backflip🔥🔥"] = 18550514533,
    ["Self Head💀🔥"] = 118102314688059,
    ["Fucking Sturdy🔥"] = 13688011089,
    ["Swinging Dick😭🔥"] = 94392118788089,
    ["Helicopter🚁"] = 124497218592541,
    ["Violated😭"] = 109153480315538,
    ["Exercise🔥"] = 88939300337240,
    ["Hump🙎‍♀️"] = 97781029740229,
    ["Jerk Thin😭🔥"] = 134910678221367,
    ["Lay Down Twerk😭🤓"] = 79332351515290,
    ["Transformer😭🔥😔"] = 76128548432128,
    ["Multiple😔"] = 123784047162125,
    ["Nigger😭🤓🔥"] = 106430924761491,
    ["BBC😔"] = 112499477851180,
    ["BBC V2🔥"] = 138756768062616,
    ["Pooping😭🔥"] = 98067308981029,
    ["Russia"] = 8749319208,
    ["Pole🔥"] = 108168498821513,
    ["Boys a Liar"] = 15188441823,
    ["Lil Whip'"] = 10280549156,
    ["big swastika"] = 94631359696320,
    ["on knees eating"] = 72555904469135,
    ["Bachata"] = 94769679405979
}
    local newAnimations = {
-- Corrected position
    }
    
    -- Check for duplicates and add new animations
    local existingIds = {}
    for _, id in pairs(BuiltInAnimationsR15) do
        existingIds[id] = true
    end
    
    for animName, animId in pairs(newAnimations) do
        if not existingIds[animId] then
            BuiltInAnimationsR15[animName] = animId
            print("Added animation:", animName, "with ID:", animId)
        else
            print("Duplicate animation ID found, skipping:", animName, "with ID:", animId)
        end
    end
    
    -- NEW: Table to store favorite animations (by name)
    local favoriteAnimations = {}
    -- NEW: Table to store keybinds for animations (animation name -> KeyCode)
    local animationKeybinds = {}
    
    -- Function to save favorite animations to a file
    local function saveFavorites()
        local success, encodedFavorites = pcall(HttpService.JSONEncode, HttpService, favoriteAnimations)
        if success then
            if writefile then
                local saveSuccess, errorMessage = pcall(function()
                    writefile("favorite_animations.json", encodedFavorites)
                end)
                if not saveSuccess then
                    warn("Error saving favorites:", errorMessage)
                end
            else
                warn("File system functions not supported in this environment")
            end
        else
            warn("Error encoding favorites:", encodedFavorites)
        end
    end
    
    -- Function to load favorite animations from a file
    local function loadFavorites()
        local success, fileContent = pcall(readfile, "favorite_animations.json")
        if success then
            local decodeSuccess, decodedFavorites = pcall(function()
                return HttpService:JSONDecode(fileContent)
            end)
            if decodeSuccess and typeof(decodedFavorites) == "table" then
                favoriteAnimations = decodedFavorites
                print("Favorites loaded successfully.")
            else
                warn("Error decoding favorites:", decodedFavorites)
                favoriteAnimations = {}
            end
        else
            warn("No favorites file found, starting with empty favorites")
            favoriteAnimations = {}
        end
    end
    
    -- NEW: Function to save animation keybinds to a file
    local function saveKeybinds()
        local keybindsToSave = {}
        for animName, keyCode in pairs(animationKeybinds) do
            keybindsToSave[animName] = keyCode.Name -- Save KeyCode as String
        end
        local success, encodedKeybinds = pcall(HttpService:JSONEncode(keybindsToSave))
        if success then
            local saveSuccess, errorMessage = pcall(function()
                writefile("animation_keybinds.json", encodedKeybinds) -- Changed to writefile and new filename
            end)
            if not saveSuccess then
                warn("Error saving keybinds:", errorMessage)
            end
        else
            warn("Error encoding keybinds:", encodedKeybinds)
        end
    end
    
    -- NEW: Function to load animation keybinds from a file
    local function loadKeybinds()
        local success, fileContent = pcall(readfile, "animation_keybinds.json")
        if success then
            local decodeSuccess, decodedKeybinds = pcall(HttpService:JSONDecode(fileContent))
            if decodeSuccess and typeof(decodedKeybinds) == "table" then
                for animName, keyName in pairs(decodedKeybinds) do
                    animationKeybinds[animName] = Enum.KeyCode[keyName] -- Convert String back to KeyCode
                end
                print("Keybinds loaded successfully.")
            else
                warn("Error decoding keybinds:", decodedKeybinds)
                animationKeybinds = {}
            end
        else
            warn("No keybinds file found, starting with empty keybinds:", fileContent)
            animationKeybinds = {}
        end
    end
    
    
    -- Helper function to scale a CFrame uniformly (keeps rotation)
    local function scaleCFrame(cf, scale)
        local pos = cf.Position * scale
        local xRot, yRot, zRot = cf:ToEulerAnglesXYZ()
        return CFrame.new(pos) * CFrame.Angles(xRot, yRot, zRot)
    end
    
    -- Function that moves the clone so its lowest point (Y-coordinate) is at 0
    local function adjustCloneToGround(clone)
        if not clone then return end
        local lowestY = math.huge
        for _, part in ipairs(clone:GetDescendants()) do
            if part:IsA("BasePart") then
                local bottomY = part.Position.Y - (part.Size.Y / 2)
                if bottomY < lowestY then
                    lowestY = bottomY
                end
            end
        end
        local groundY = 0
        local offset = groundY - lowestY
        if offset > 0 then
            if clone.PrimaryPart then
                clone:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame + Vector3.new(0, offset, 0))
            else
                clone:TranslateBy(Vector3.new(0, offset, 0))
            end
        end
    end
    
    -- Functions to temporarily preserve GUIs (ResetOnSpawn)
    local preservedGuis = {}
    local function preserveGuis()
        local playerGui = LocalPlayer:FindFirstChildWhichIsA("PlayerGui")
        if playerGui then
            for _, gui in ipairs(playerGui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.ResetOnSpawn then
                    table.insert(preservedGuis, gui)
                    gui.ResetOnSpawn = false
                end
            end
        end
    end
    
    local function restoreGuis()
        for _, gui in ipairs(preservedGuis) do
            gui.ResetOnSpawn = true
        end
        table.clear(preservedGuis)
    end
    
    -- Function to update the clone’s scale using both cloneSize (uniform scaling)
    -- and cloneWidth (extra scaling only on the X-axis).
    local function updateCloneScale()
        if not ghostClone then return end
        for part, origSize in pairs(ghostOriginalSizes) do
            if part and part:IsA("BasePart") then
                part.Size = Vector3.new(origSize.X * cloneSize * cloneWidth, origSize.Y * cloneSize, origSize.Z * cloneSize)
            end
        end
        for motor, orig in pairs(ghostOriginalMotorCFrames) do
            if motor and motor:IsA("Motor6D") then
                local c0 = orig.C0
                local c1 = orig.C1
                local newC0 = CFrame.new(
                    c0.Position.X * cloneSize * cloneWidth,
                    c0.Position.Y * cloneSize,
                    c0.Position.Z * cloneSize
                ) * CFrame.Angles(c0:ToEulerAnglesXYZ())
                local newC1 = CFrame.new(
                    c1.Position.X * cloneSize * cloneWidth,
                    c1.Position.Y * cloneSize,
                    c1.Position.Z * cloneSize
                ) * CFrame.Angles(c1:ToEulerAnglesXYZ())
                motor.C0 = newC0
                motor.C1 = newC1
            end
        end
    
        local ghostHumanoid = ghostClone:FindFirstChildWhichIsA("Humanoid")
        if ghostHumanoid and ghostOriginalHipHeight then
            ghostHumanoid.HipHeight = ghostOriginalHipHeight * cloneSize
        end
    
        adjustCloneToGround(ghostClone)
    end
    
    -- Function to update the clone’s transparency (fully invisible)
    local function updateCloneTransparency()
        if not ghostClone then return end
        for _, part in pairs(ghostClone:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        local head = ghostClone:FindFirstChild("Head")
        if head then
            for _, child in ipairs(head:GetChildren()) do
                if child:IsA("Decal") then
                    child.Transparency = 1
                end
            end
        end
    end
    
    -- Function to synchronize the ragdolled body parts
    local function updateRagdolledParts()
        if not ghostEnabled or not originalCharacter or not ghostClone then return end
        for _, partName in ipairs(bodyParts) do
            local originalPart = originalCharacter:FindFirstChild(partName)
            local clonePart = ghostClone:FindFirstChild(partName)
            if originalPart and clonePart then
                originalPart.CFrame = clonePart.CFrame
                originalPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                originalPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
    
    -- Function to enable/disable ghost mode
    local function setGhostEnabled(newState)
        ghostEnabled = newState
    
        if ghostEnabled then
            local char = LocalPlayer.Character
            if not char then
                warn("No character found!")
                return
            end
    
            local humanoid = char:FindFirstChildWhichIsA("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root then
                warn("Character is missing either Humanoid or HumanoidRootPart!")
                return
            end
    
            originalCharacter = char
            originalCFrame = root.CFrame
    
            char.Archivable = true
            ghostClone = char:Clone()
            char.Archivable = false
    
            local originalName = originalCharacter.Name
            ghostClone.Name = originalName .. "_clone"
    
            local ghostHumanoid = ghostClone:FindFirstChildWhichIsA("Humanoid")
            if ghostHumanoid then
                ghostHumanoid.DisplayName = originalName .. "_clone"
                ghostOriginalHipHeight = ghostHumanoid.HipHeight
            end
    
            if not ghostClone.PrimaryPart then
                local hrp = ghostClone:FindFirstChild("HumanoidRootPart")
                if hrp then
                    ghostClone.PrimaryPart = hrp
                end
            end
    
            for _, part in ipairs(ghostClone:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
            local head = ghostClone:FindFirstChild("Head")
            if head then
                for _, child in ipairs(head:GetChildren()) do
                    if child:IsA("Decal") then
                        child.Transparency = 1
                    end
                end
            end
    
            ghostOriginalSizes = {}
            ghostOriginalMotorCFrames = {}
            for _, desc in ipairs(ghostClone:GetDescendants()) do
                if desc:IsA("BasePart") then
                    ghostOriginalSizes[desc] = desc.Size
                elseif desc:IsA("Motor6D") then
                    ghostOriginalMotorCFrames[desc] = { C0 = desc.C0, C1 = desc.C1 }
                end
            end
    
            if cloneSize ~= 1 or cloneWidth ~= 1 then
                updateCloneScale()
            end
    
            local animate = originalCharacter:FindFirstChild("Animate")
            if animate then
                originalAnimateScript = animate
                originalAnimateScript.Disabled = true
                originalAnimateScript.Parent = ghostClone
            end
    
            preserveGuis()
            ghostClone.Parent = originalCharacter.Parent
    
            adjustCloneToGround(ghostClone)
    
            LocalPlayer.Character = ghostClone
            if ghostHumanoid then
                Workspace.CurrentCamera.CameraSubject = ghostHumanoid
            end
            restoreGuis()
    
            if originalAnimateScript then
                originalAnimateScript.Disabled = false
            end
    
            task.delay(0, function() -- Changed delay to 0
                if not ghostEnabled then return end
                ReplicatedStorage.RagdollEvent:FireServer()
                task.delay(0, function()
                    if not ghostEnabled then return end
                    if updateConnection then updateConnection:Disconnect() end
                    updateConnection = RunService.Heartbeat:Connect(updateRagdolledParts)
                end)
            end)
    
        else
            if updateConnection then
                updateConnection:Disconnect()
                updateConnection = nil
            end
    
            if not originalCharacter or not ghostClone then return end
    
            for i = 1, 3 do
                ReplicatedStorage.UnragdollEvent:FireServer()
                task.wait(0.1)
            end
    
            local origRoot = originalCharacter:FindFirstChild("HumanoidRootPart")
            local ghostRoot = ghostClone:FindFirstChild("HumanoidRootPart")
            local targetCFrame = ghostRoot and ghostRoot.CFrame or originalCFrame
    
            local animate = ghostClone:FindFirstChild("Animate")
            if animate then
                animate.Disabled = true
                animate.Parent = originalCharacter
            end
    
            ghostClone:Destroy()
    
            if origRoot then
                origRoot.CFrame = targetCFrame
            end
    
            local origHumanoid = originalCharacter:FindFirstChildWhichIsA("Humanoid")
            preserveGuis()
            LocalPlayer.Character = originalCharacter
            if origHumanoid then
                Workspace.CurrentCamera.CameraSubject = origHumanoid
            end
            restoreGuis()
    
            if animate then
                task.wait(0.1)
                animate.Disabled = false
            end
    
            cloneSize = 1
            cloneWidth = 1
        end
    end
    
    -- NEW SECTION: Fake Animation on Ghost (Fake) Character --
    local fakeAnimStop
    local function stopFakeAnimation()
        fakeAnimStop = true
        fakeAnimRunning = false -- Ensure the loop breaks
        for i,script in pairs(ghostClone:GetChildren()) do
            if script:IsA("LocalScript") and script.Enabled == false then
                script.Enabled=true
            end
        end
        -- Reset body parts to original positions
        if ghostClone then
            for motor, orig in pairs(ghostOriginalMotorCFrames) do
                if motor and motor:IsA("Motor6D") then
                    motor.C0 = orig.C0
                    motor.C1 = orig.C1
                end
            end
    
            -- Reset velocity on all body parts
            for _, partName in ipairs(bodyParts) do
                local part = ghostClone:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    end
    -- Variables to control the fake animation loop
    local fakeAnimRunning = false
    fakeAnimStop = false
    local fakeAnimSpeed = 1 -- Default speed (1.0 = 100%)
    local function playFakeAnimation(animationId)
        if not ghostClone then
            warn("No fake character available!")
            return
        end
        if animationId == "" then return end
        if fakeAnimRunning then
            stopFakeAnimation()
        end
        wait(0.1)
        -- Reset ghostClone scaling so it's at its original size
        cloneSize = 1
        cloneWidth = 1    updateCloneScale()

        -- Reset joints to original values before applying animation transforms
        for motor, orig in pairs(ghostOriginalMotorCFrames) do
            motor.C0 = orig.C0
        end

        local success, NeededAssets = pcall(function()
            return game:GetObjects("rbxassetid://" .. animationId)[1]
        end)
        if not success or not NeededAssets then
            warn("Invalid Animation ID.")
            return
        end

        -- Get the joints from ghostClone (assuming an R15 rig)
        local character = ghostClone
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local head = character:WaitForChild("Head")
        local leftFoot = character:WaitForChild("LeftFoot")
        local leftHand = character:WaitForChild("LeftHand")
        local leftLowerArm = character:WaitForChild("LeftLowerArm")
        local leftLowerLeg = character:WaitForChild("LeftLowerLeg")
        local leftUpperArm = character:WaitForChild("LeftUpperArm")
        local leftUpperLeg = character:WaitForChild("LeftUpperLeg")
        local lowerTorso = character:WaitForChild("LowerTorso")
        local rightFoot = character:WaitForChild("RightFoot")
        local rightHand = character:WaitForChild("RightHand")
        local rightLowerArm = character:WaitForChild("RightLowerArm")
        local rightLowerLeg = character:WaitForChild("RightLowerLeg")
        local rightUpperArm = character:WaitForChild("RightUpperArm")
        local rightUpperLeg = character:WaitForChild("RightUpperLeg")
        local upperTorso = character:WaitForChild("UpperTorso")

        local Joints = {
            ["Torso"] = rootPart:FindFirstChild("RootJoint"),
            ["Head"] = head:FindFirstChild("Neck"),
            ["LeftUpperArm"] = leftUpperArm:FindFirstChild("LeftShoulder"),
            ["RightUpperArm"] = rightUpperArm:FindFirstChild("RightShoulder"),
            ["LeftUpperLeg"] = leftUpperLeg:FindFirstChild("LeftHip"),
            ["RightUpperLeg"] = rightUpperLeg:FindFirstChild("RightHip"),
            ["LeftFoot"] = leftFoot:FindFirstChild("LeftAnkle"),
            ["RightFoot"] = rightFoot:FindFirstChild("RightAnkle"),
            ["LeftHand"] = leftHand:FindFirstChild("LeftWrist"),
            ["RightHand"] = rightHand:FindFirstChild("RightWrist"),
            ["LeftLowerArm"] = leftLowerArm:FindFirstChild("LeftElbow"),
            ["RightLowerArm"] = rightLowerArm:FindFirstChild("RightElbow"),
            ["LeftLowerLeg"] = leftLowerLeg:FindFirstChild("LeftKnee"),
            ["RightLowerLeg"] = rightLowerLeg:FindFirstChild("RightKnee"),
            ["LowerTorso"] = lowerTorso:FindFirstChild("Root"),
            ["UpperTorso"] = upperTorso:FindFirstChild("Waist"),
        }
        
        fakeAnimStop = false
        fakeAnimRunning = true
        
        local part = Instance.new("Part")
        part.Size = Vector3.new(2048,0.1,2048)
        part.Anchored = true
        part.Position = game.Players.LocalPlayer.Character.LowerTorso.Position + Vector3.new(0,-0.2,0)
        part.Transparency = 1
        part.Parent = workspace
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
        wait(0.1)
        for i,script in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if script:IsA("LocalScript") and script.Enabled then
                script.Enabled=false
            end
        end
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        part:Destroy()
        spawn(function()
            while fakeAnimRunning do
            if fakeAnimStop then
                fakeAnimRunning = false
                break
            end

            pcall(function() -- Add pcall to handle errors gracefully
                local keyframes = NeededAssets:GetKeyframes()
                for ii = 1, #keyframes do
                if fakeAnimStop then break end

                local currentFrame = keyframes[ii]
                local nextFrame = keyframes[ii + 1] or keyframes[1] -- Loop back to first frame
                local currentTime = currentFrame.Time
                local nextTime = nextFrame.Time
                if nextTime <= currentTime then
                    nextTime = nextTime + NeededAssets.Length
                end

                local frameLength = (nextTime - currentTime) / fakeAnimSpeed
                local startTime = tick()
                
                while tick() - startTime < frameLength and not fakeAnimStop do
                    local alpha = (tick() - startTime) / frameLength
                    
                    pcall(function() -- Add nested pcall for pose updates
                    for _, currentPose in pairs(currentFrame:GetDescendants()) do
                        local nextPose = nextFrame:FindFirstChild(currentPose.Name, true)
                        local motor = Joints[currentPose.Name]
                        
                        if motor and nextPose and ghostOriginalMotorCFrames[motor] then
                        local currentCF = ghostOriginalMotorCFrames[motor].C0 * currentPose.CFrame
                        local nextCF = ghostOriginalMotorCFrames[motor].C0 * nextPose.CFrame
                        motor.C0 = currentCF:Lerp(nextCF, alpha)
                        end
                    end
                    end)
                    
                    RunService.RenderStepped:Wait()
                end
                end
            end)
            
            -- Small delay to prevent tight loops if errors occur
            wait(0.03)
            end
        end)
        end
    -- End of Fake Animation Section
    
    -- NEW: Function to update Keybind Button Text
    local function updateKeybindButtonText(animButtonData, animName)
        local keybind = animationKeybinds[animName]
        if keybind then
            animButtonData.KeybindButton.Text = keybind.Name -- Display KeyCode Name
        else
            animButtonData.KeybindButton.Text = "Key"
        end
    end
    
    
    -- Function to create the separate Animation List GUI
    local function createAnimationListGui(animTextBox)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "AnimationListGui"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
        loadFavorites() -- Load favorites when GUI is created
        loadKeybinds() -- Load keybinds when GUI is created
    
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 330, 0, 400) -- Less wide here, changed from `UDim2.new(0, 350, 0, 400)` to `UDim2.new(0, 330, 0, 400)`
        mainFrame.Position = UDim2.new(0.75, -175, 0.5, -200) -- Position to the right of main GUI
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        mainFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner") -- Rounded corner for mainFrame
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = mainFrame
        mainFrame.Parent = screenGui
    
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 50) -- Increased height of titleBar here
        titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        titleBar.BorderSizePixel = 0
        local titleCorner = Instance.new("UICorner") -- Rounded corner for titleBar
        titleCorner.CornerRadius = UDim.new(0, 10)
        titleCorner.Parent = titleBar
        titleBar.Parent = mainFrame
    
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -50, 1, 0)
        titleLabel.Position = UDim2.new(0, 25, 0, 0)
        titleLabel.Text = "Animation List"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamSemibold
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar
    
        -- Close Button
        local closeButton = Instance.new("TextButton")
        closeButton.Name = "CloseButton"
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -35, 0, 10) -- Adjusted position to be vertically centered in the wider title bar
        closeButton.Text = ""
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeButton.TextSize = 18
        closeButton.Font = Enum.Font.GothamSemibold
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        closeButton.BackgroundTransparency = 0.5
        closeButton.AutoButtonColor = true
        local closeCorner = Instance.new("UICorner") -- Rounded corner for closeButton
        closeCorner.CornerRadius = UDim.new(0, 8)
        closeCorner.Parent = closeButton
        closeButton.Parent = titleBar
    
        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, -20, 1, -60) -- Adjusted height to account for wider title bar
        contentFrame.Position = UDim2.new(0, 10, 0, 55) -- Adjusted position to account for wider title bar
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = mainFrame
    
        -- ADDED: Search TextBox
        local animSearchTextBox = Instance.new("TextBox")
        animSearchTextBox.Name = "AnimSearchTextBox"
        animSearchTextBox.Text = ""
        animSearchTextBox.Size = UDim2.new(1, 0, 0, 30)
        animSearchTextBox.Position = UDim2.new(0, 0, 0, 0)
        animSearchTextBox.PlaceholderText = "Search Animations..."
        animSearchTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        animSearchTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        animSearchTextBox.ClearTextOnFocus = false
        local animSearchTextBoxCorner = Instance.new("UICorner") -- Rounded corner for animSearchTextBox
        animSearchTextBoxCorner.CornerRadius = UDim.new(0, 6)
        animSearchTextBoxCorner.Parent = animSearchTextBox
        animSearchTextBox.Parent = contentFrame
    
        local animScrollFrame = Instance.new("ScrollingFrame")
        animScrollFrame.Name = "AnimScrollFrame"
        animScrollFrame.Size = UDim2.new(1, 0, 1, -40) -- Take up remaining space
        animScrollFrame.Position = UDim2.new(0, 0, 0, 35)
        animScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        animScrollFrame.BorderSizePixel = 0
        animScrollFrame.ScrollBarThickness = 6
        animScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        local scrollFrameCorner = Instance.new("UICorner") -- Rounded corner for animScrollFrame
        scrollFrameCorner.CornerRadius = UDim.new(0, 6)
        scrollFrameCorner.Parent = animScrollFrame
        animScrollFrame.Parent = contentFrame
    
        -- Table to store animation buttons for search functionality
        local animationButtons = {}
        local keybindInputActive = false
        local currentAnimationForKeybind = nil
    
        -- Function to update animation button visibility based on search text and favorites
        local function updateAnimationButtonsVisibility(searchText)
            local yOffset = 5
            local visibleButtonCount = 0
    
            -- Sort animations: Favorites first, then alphabetically
            local sortedAnimationNames = {}
            local favoriteNames = {}
            local nonFavoriteNames = {}
    
            for animName in pairs(BuiltInAnimationsR15) do
                if favoriteAnimations[animName] then
                    table.insert(favoriteNames, animName)
                else
                    table.insert(nonFavoriteNames, animName)
                end
            end
            table.sort(favoriteNames)
            table.sort(nonFavoriteNames)
            for _, name in ipairs(favoriteNames) do
                table.insert(sortedAnimationNames, name)
            end
            for _, name in ipairs(nonFavoriteNames) do
                table.insert(sortedAnimationNames, name)
            end
    
    
            for _, animName in ipairs(sortedAnimationNames) do -- Iterate through sorted names
                local animButtonData = animationButtons[animName]
                if not animButtonData then continue end -- Safety check
    
                if string.find(string.lower(animName), string.lower(searchText)) then
                    animButtonData.NameButton.Visible = true
                    animButtonData.PlayButton.Visible = true
                    animButtonData.FavoriteButton.Visible = true -- Show Favorite Button
                    animButtonData.StopButton.Visible = true -- Show Stop Button
                    animButtonData.KeybindButton.Visible = true -- Show Keybind Button
                    animButtonData.NameButton.Position = UDim2.new(0, 5, 0, yOffset)
                    animButtonData.PlayButton.Position = UDim2.new(0, 5, 0, yOffset + 30)
                    animButtonData.FavoriteButton.Position = UDim2.new(1, -125, 0, yOffset) -- Position Favorite button right of NameButton - Adjusted for wider Keybind button, changed from `UDim2.new(1, -145, 0, yOffset)` to `UDim2.new(1, -125, 0, yOffset)`
                    animButtonData.StopButton.Position = UDim2.new(1, -85, 0, yOffset) -- Position Stop button right of Favorite Button - Adjusted for wider Keybind button, changed from `UDim2.new(1, -105, 0, yOffset)` to `UDim2.new(1, -85, 0, yOffset)`
                    animButtonData.KeybindButton.Position = UDim2.new(1, -45, 0, yOffset) -- Position Keybind button right of Stop Button - Adjusted for wider Keybind button, changed from `UDim2.new(1, -65, 0, yOffset)` to `UDim2.new(1, -45, 0, yOffset)`
                    yOffset = yOffset + 65
                    visibleButtonCount = visibleButtonCount + 1
    
                    -- Highlight favorite animations visually
                    if favoriteAnimations[animName] then
                        animButtonData.NameButton.BackgroundColor3 = Color3.fromRGB(80, 70, 90) -- Different background for favorites
                    else
                        animButtonData.NameButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    end
                    updateKeybindButtonText(animButtonData, animName) -- Update Keybind Button Text
    
                else
                    animButtonData.NameButton.Visible = false
                    animButtonData.PlayButton.Visible = false
                    animButtonData.FavoriteButton.Visible = false -- Hide Favorite Button too
                    animButtonData.StopButton.Visible = false -- Hide Stop Button too
                    animButtonData.KeybindButton.Visible = false -- Hide Keybind Button too
                end
            end
            animScrollFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(0, yOffset - 60 + 5))
        end
    
        -- Create buttons for each animation in the BuiltInAnimationsR15 table
        for animName, animId in pairs(BuiltInAnimationsR15) do
            local animNameButton = Instance.new("TextButton")
            animNameButton.Name = animName .. "NameButton"
            animNameButton.Size = UDim2.new(1, -80, 0, 30) -- Wider button for title - Adjusted for wider Keybind button - Changed here from `UDim2.new(1, -100, 0, 30)` to `UDim2.new(1, -80, 0, 30)`
            animNameButton.Position = UDim2.new(0, 5, 0, 5) -- Initial position, updated by search function
            animNameButton.Text = animName
            animNameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            animNameButton.TextSize = 14
            animNameButton.Font = Enum.Font.GothamMedium
            animNameButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            animNameButton.BorderSizePixel = 0
            animNameButton.TextXAlignment = Enum.TextXAlignment.Center -- Centered Text Here
            local buttonCorner = Instance.new("UICorner") -- Rounded corner for animNameButton
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = animNameButton
            animNameButton.Parent = animScrollFrame
    
            -- When clicked, set the animation ID in the textbox of the main GUI
            animNameButton.MouseButton1Click:Connect(function()
                animTextBox.Text = tostring(animId)
            end)
    
            -- Play Animation Button
            local playAnimButton = Instance.new("TextButton")
            playAnimButton.Name = animName .. "PlayButton"
            playAnimButton.Size = UDim2.new(1, -10, 0, 30) -- Same size as name button for now
            playAnimButton.Position = UDim2.new(0, 5, 0, 35) -- Position below the name button
            playAnimButton.Text = "Play" -- Shorter text
            playAnimButton.TextColor3 = Color3.fromRGB(200, 200, 200) -- Slightly different color
            playAnimButton.TextSize = 12 -- Smaller text size
            playAnimButton.Font = Enum.Font.GothamMedium
            playAnimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80) -- Slightly darker background
            playAnimButton.BorderSizePixel = 0
            local playButtonCorner = Instance.new("UICorner")
            playButtonCorner.CornerRadius = UDim.new(0, 4)
            playButtonCorner.Parent = playAnimButton
            playAnimButton.Parent = animScrollFrame
    
            playAnimButton.MouseButton1Click:Connect(function()
                playFakeAnimation(tostring(animId)) -- Call playFakeAnimation with the ID
            end)
    
            -- Favorite Animation Button
            local favoriteAnimButton = Instance.new("TextButton")
            favoriteAnimButton.Name = animName .. "FavoriteButton"
            favoriteAnimButton.Size = UDim2.new(0, 40, 0, 30) -- Smaller button for favorite
            favoriteAnimButton.Position = UDim2.new(1, -125, 0, 5) -- Position Favorite button right of NameButton - Adjusted for wider Keybind button, changed from `UDim2.new(1, -145, 0, 5)` to `UDim2.new(1, -125, 0, 5)`
            favoriteAnimButton.Text = favoriteAnimations[animName] and "★" or "☆" -- Filled star if favorite, otherwise empty
            favoriteAnimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            favoriteAnimButton.TextSize = 20
            favoriteAnimButton.Font = Enum.Font.GothamBold
            favoriteAnimButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            favoriteAnimButton.BorderSizePixel = 0
            local favoriteButtonCorner = Instance.new("UICorner")
            favoriteButtonCorner.CornerRadius = UDim.new(0, 4)
            favoriteButtonCorner.Parent = favoriteAnimButton
            favoriteAnimButton.Parent = animScrollFrame
    
            favoriteAnimButton.MouseButton1Click:Connect(function()
                if favoriteAnimations[animName] then
                    favoriteAnimations[animName] = nil -- Remove from favorites
                else
                    favoriteAnimations[animName] = true -- Add to favorites
                end
                favoriteAnimButton.Text = favoriteAnimations[animName] and "★" or "☆" -- Update button text
                updateAnimationButtonsVisibility(animSearchTextBox.Text) -- Refresh list to re-sort
                saveFavorites() -- Save favorites after change
            end)
    
            -- Stop Animation Button
            local stopAnimButton = Instance.new("TextButton")
            stopAnimButton.Name = animName .. "StopButton"
            stopAnimButton.Size = UDim2.new(0, 40, 0, 30) -- Smaller button for stop
            stopAnimButton.Position = UDim2.new(1, -85, 0, 5) -- Position Stop button right of Favorite Button - Adjusted for wider Keybind button, changed from `UDim2.new(1, -105, 0, 5)` to `UDim2.new(1, -85, 0, 5)`
            stopAnimButton.Text = "🛑"
            stopAnimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            stopAnimButton.TextSize = 16
            stopAnimButton.Font = Enum.Font.GothamBold
            stopAnimButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
            stopAnimButton.BorderSizePixel = 0
            local stopButtonCorner = Instance.new("UICorner")
            stopButtonCorner.CornerRadius = UDim.new(0, 4)
            stopButtonCorner.Parent = stopAnimButton
            stopAnimButton.Parent = animScrollFrame
    
            stopAnimButton.MouseButton1Click:Connect(function()
                stopFakeAnimation() -- Call stopFakeAnimation function
            end)
    
            -- NEW: Keybind Animation Button
            local keybindAnimButton = Instance.new("TextButton")
            keybindAnimButton.Name = animName .. "KeybindButton"
            keybindAnimButton.Size = UDim2.new(0, 40, 0, 30) -- Wider button for keybind - Increased width here, changed from `UDim2.new(0, 60, 0, 30)` to `UDim2.new(0, 40, 0, 30)`
            keybindAnimButton.Position = UDim2.new(1, -45, 0, 5) -- Position Keybind button right of Stop Button - Adjusted for wider Keybind button, changed from `UDim2.new(1, -65, 0, 5)` to `UDim2.new(1, -45, 0, 5)`
            keybindAnimButton.Text = "Set Keybind" -- Initial text
            keybindAnimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            keybindAnimButton.TextSize = 12
            keybindAnimButton.Font = Enum.Font.GothamMedium
            keybindAnimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
            keybindAnimButton.BorderSizePixel = 0
            local keybindButtonCorner = Instance.new("UICorner")
            keybindButtonCorner.CornerRadius = UDim.new(0, 4)
            keybindButtonCorner.Parent = keybindAnimButton
            keybindAnimButton.Parent = animScrollFrame
    
            keybindAnimButton.MouseButton1Click:Connect(function()
                if keybindInputActive then return end -- Prevent overlapping keybind inputs
                keybindInputActive = true
                currentAnimationForKeybind = animName
                keybindAnimButton.Text = "Press" -- Prompt user to press a key
    
                local function inputBeganHandler(input, gameProcessedEvent)
                    if not keybindInputActive or currentAnimationForKeybind ~= animName then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        animationKeybinds[animName] = input.KeyCode
                        saveKeybinds()
                        updateKeybindButtonText(animationButtons[animName], animName)
                        keybindInputActive = false
                        currentAnimationForKeybind = nil
                        UserInputService.InputBegan:Disconnect(inputBeganHandler) -- Disconnect after setting keybind
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        -- Allow canceling keybind setting by clicking away
                        updateKeybindButtonText(animationButtons[animName], animName) -- Revert text
                        keybindInputActive = false
                        currentAnimationForKeybind = nil
                        UserInputService.InputBegan:Disconnect(inputBeganHandler)
                    end
                end
    
                UserInputService.InputBegan:Connect(inputBeganHandler)
            end)
    
    
            animationButtons[animName] = {
                NameButton = animNameButton,
                PlayButton = playAnimButton,
                FavoriteButton = favoriteAnimButton,
                StopButton = stopAnimButton,
                KeybindButton = keybindAnimButton -- NEW: Keybind Button
            }
        end
    
        -- Initially update button visibility to show all animations
        updateAnimationButtonsVisibility("")
    
        -- Update button visibility when search text changes
        animSearchTextBox:GetPropertyChangedSignal("Text"):Connect(function()
            updateAnimationButtonsVisibility(animSearchTextBox.Text)
        end)
    
        -- Drag functionality for the Animation List GUI
        local dragging = false
        local dragInput, dragStart, startPos
        local function updateInput(input)
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
    
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
    
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input == dragInput) then
                updateInput(input)
            end
        end)
    
        return screenGui
    end
    
    local animationListGui = nil -- Variable to track if animation list is open
    
    -- Creates a draggable GUI with a compact layout.
    local function createDraggableGui(getGhostEnabled, toggleGhost, getSizeValue, setSizeValue, getWidthValue, setWidthValue)
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "EnhancedGhostGui"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
        local mainFrame = Instance.new("Frame")
        mainFrame.Name = "MainFrame"
        mainFrame.Size = UDim2.new(0, 350, 0, 450)  -- Increased height to accommodate speed slider
        mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)  -- Adjusted position for taller size
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        mainFrame.BorderSizePixel = 0
        local uiCorner = Instance.new("UICorner") -- Rounded corner for mainFrame
        uiCorner.CornerRadius = UDim.new(0, 10)
        uiCorner.Parent = mainFrame
        mainFrame.Parent = screenGui
    
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        titleBar.BorderSizePixel = 0
        local titleCorner = Instance.new("UICorner") -- Rounded corner for titleBar
        titleCorner.CornerRadius = UDim.new(0, 10)
        titleCorner.Parent = titleBar
        titleBar.Parent = mainFrame
    
        local titleBarBottom = Instance.new("Frame")
        titleBarBottom.Name = "BottomEdge"
        titleBarBottom.Size = UDim2.new(1, 0, 0, 10)
        titleBarBottom.Position = UDim2.new(0, 0, 1, -10)
        titleBarBottom.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        titleBarBottom.BorderSizePixel = 0
        titleBarBottom.ZIndex = 0
        titleBarBottom.Parent = titleBar
    
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.Size = UDim2.new(0, 24, 0, 24)
        logo.Position = UDim2.new(0, 13, 0, 8)
        logo.BackgroundTransparency = 1
        logo.Image = "rbxassetid://6022668885"
        logo.Parent = titleBar
    
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -100, 1, 0)
        titleLabel.Position = UDim2.new(0, 50, 0, 0)
        titleLabel.Text = "Reanimation"
        titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        titleLabel.TextSize = 18
        titleLabel.Font = Enum.Font.GothamSemibold
        titleLabel.BackgroundTransparency = 1
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = titleBar
    
        -- Minimize Button
        local minimizeButton = Instance.new("TextButton") -- Added Minimize Button
        minimizeButton.Name = "MinimizeButton"
        minimizeButton.Size = UDim2.new(0, 30, 0, 30)
        minimizeButton.Position = UDim2.new(1, -65, 0, 5) -- Position next to close button
        minimizeButton.Text = "-" -- Minimize Icon (you can use an image instead)
        minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        minimizeButton.TextSize = 24
        minimizeButton.Font = Enum.Font.GothamSemibold
        minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        minimizeButton.BackgroundTransparency = 0.5
        minimizeButton.AutoButtonColor = true
        local minimizeCorner = Instance.new("UICorner") -- Rounded corner for minimizeButton
        minimizeCorner.CornerRadius = UDim.new(0, 8)
        minimizeCorner.Parent = minimizeButton
        minimizeButton.Parent = titleBar
    
        -- Close Button
        local closeButton = Instance.new("TextButton")
        closeButton.Name = "CloseButton"
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -35, 0, 5)
        closeButton.Text = "X"
        closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeButton.TextSize = 18
        closeButton.Font = Enum.Font.GothamSemibold
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        closeButton.BackgroundTransparency = 0.5
        closeButton.AutoButtonColor = true
        local closeCorner = Instance.new("UICorner") -- Rounded corner for closeButton
        closeCorner.CornerRadius = UDim.new(0, 8)
        closeCorner.Parent = closeButton
        closeButton.Parent = titleBar
    
        -- Content Frame
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, -20, 1, -50)
        contentFrame.Position = UDim2.new(0, 10, 0, 45)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Parent = mainFrame
    
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(1, 0, 0, 40)
        toggleButton.Position = UDim2.new(0, 0, 0, 0)
        toggleButton.Text = "Enable Reanimation"
        toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleButton.TextSize = 16
        toggleButton.Font = Enum.Font.GothamSemibold
        toggleButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
        toggleButton.BorderSizePixel = 0
        toggleButton.AutoButtonColor = true
        local toggleCorner = Instance.new("UICorner") -- Rounded corner for toggleButton
        toggleCorner.CornerRadius = UDim.new(0, 8)
        toggleCorner.Parent = toggleButton
        toggleButton.Parent = contentFrame
    
        -- Size Slider Section (compact layout)
        local sizeSection = Instance.new("Frame")
        sizeSection.Name = "SizeSection"
        sizeSection.Size = UDim2.new(1, 0, 0, 50)
        sizeSection.Position = UDim2.new(0, 0, 0, 45) -- Reduced spacing
        sizeSection.BackgroundTransparency = 1
        sizeSection.Parent = contentFrame
    
        local sizeLabel = Instance.new("TextLabel")
        sizeLabel.Name = "SizeLabel"
        sizeLabel.Size = UDim2.new(1, 0, 0, 20)
        sizeLabel.Text = "Clone Size: 100%"
        sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sizeLabel.TextSize = 14
        sizeLabel.Font = Enum.Font.GothamMedium
        sizeLabel.BackgroundTransparency = 1
        sizeLabel.TextXAlignment = Enum.TextXAlignment.Left
        sizeLabel.Parent = sizeSection
    
        local sizeSliderBG = Instance.new("Frame")
        sizeSliderBG.Name = "SliderBG"
        sizeSliderBG.Size = UDim2.new(1, 0, 0, 12)
        sizeSliderBG.Position = UDim2.new(0, 0, 0, 25)
        sizeSliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        sizeSliderBG.BorderSizePixel = 0
        local sliderBGCorner = Instance.new("UICorner") -- Rounded corner for sizeSliderBG
        sliderBGCorner.CornerRadius = UDim.new(0, 4)
        sliderBGCorner.Parent = sizeSliderBG
        sizeSliderBG.Parent = sizeSection
    
        local sizeSliderFill = Instance.new("Frame")
        sizeSliderFill.Name = "SliderFill"
        sizeSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        sizeSliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        sizeSliderFill.BorderSizePixel = 0
        local sliderFillCorner = Instance.new("UICorner") -- Rounded corner for sizeSliderFill
        sliderFillCorner.CornerRadius = UDim.new(0, 4)
        sliderFillCorner.Parent = sliderFill
        sizeSliderFill.Parent = sizeSliderBG
    
        local function updateSizeSlider(value)
            local fillValue = 0
            if value <= 0.5 then
                fillValue = 0
            elseif value >= 20 then
                fillValue = 1
            else
                fillValue = (value - 0.5) / 19.5
            end
            sizeSliderFill.Size = UDim2.new(fillValue, 0, 1, 0)
            sizeLabel.Text = "Clone Size: " .. math.floor(value * 100) .. "%"
            setSizeValue(value)
        end
    
        updateSizeSlider(getSizeValue())
    
        local isDraggingSize = false
        local function updateSizeFromPosition(input)
            local sliderPosition = (input.Position.X - sizeSliderBG.AbsolutePosition.X) / sizeSliderBG.AbsoluteSize.X
            sliderPosition = math.clamp(sliderPosition, 0, 1)
            local newValue = 0.5 + sliderPosition * 19.5
            updateSizeSlider(newValue)
        end
    
        sizeSliderBG.InputBegan:Connect(sizeSliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSize = true
                updateSizeFromPosition(input)
            end
        end))
        sizeSliderBG.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSize = false
            end
        end)
        sizeSliderBG.InputChanged:Connect(function(input)
            if isDraggingSize and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSizeFromPosition(input)
            end
        end)
    
        -- Width Slider Section (compact layout)
        local widthSection = Instance.new("Frame")
        widthSection.Name = "WidthSection"
        widthSection.Size = UDim2.new(1, 0, 0, 50)
        widthSection.Position = UDim2.new(0, 0, 0, 95) -- Reduced spacing
        widthSection.BackgroundTransparency = 1
        widthSection.Parent = contentFrame
    
        local widthLabel = Instance.new("TextLabel")
        widthLabel.Name = "WidthLabel"
        widthLabel.Size = UDim2.new(1, 0, 0, 20)
        widthLabel.Text = "Clone Width: 100%"
        widthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        widthLabel.TextSize = 14
        widthLabel.Font = Enum.Font.GothamMedium
        widthLabel.BackgroundTransparency = 1
        widthLabel.TextXAlignment = Enum.TextXAlignment.Left
        widthLabel.Parent = widthSection
    
        local widthSliderBG = Instance.new("Frame")
        widthSliderBG.Name = "WidthSliderBG"
        widthSliderBG.Size = UDim2.new(1, 0, 0, 12)
        widthSliderBG.Position = UDim2.new(0, 0, 0, 25)
        widthSliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        widthSliderBG.BorderSizePixel = 0
        local widthSliderBGCorner = Instance.new("UICorner") -- Rounded corner for widthSliderBG
        widthSliderBGCorner.CornerRadius = UDim.new(0, 4)
        widthSliderBGCorner.Parent = widthSliderBG
        widthSliderBG.Parent = widthSection
    
        local widthSliderFill = Instance.new("Frame")
        widthSliderFill.Name = "SliderFill"
        widthSliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        widthSliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        widthSliderFill.BorderSizePixel = 0
        local widthSliderFillCorner = Instance.new("UICorner") -- Rounded corner for widthSliderFill
        widthSliderFillCorner.CornerRadius = UDim.new(0, 4)
        widthSliderFillCorner.Parent = widthSliderFill
        widthSliderFill.Parent = widthSliderBG
    
        local function updateWidthSlider(value)
            local fillValue = 0
            if value <= 0.5 then
                fillValue = 0
            elseif value >= 20 then
                fillValue = 1
            else
                fillValue = (value - 0.5) / 19.5
            end
            widthSliderFill.Size = UDim2.new(fillValue, 0, 1, 0)
            widthLabel.Text = "Clone Width: " .. math.floor(value * 100) .. "%"
            setWidthValue(value)
        end
    
        updateWidthSlider(getWidthValue())
    
        local isDraggingWidth = false
        local function updateWidthFromPosition(input)
            local sliderPosition = (input.Position.X - widthSliderBG.AbsolutePosition.X) / widthSliderBG.AbsoluteSize.X
            sliderPosition = math.clamp(sliderPosition, 0, 1)
            local newValue = 0.5 + sliderPosition * 19.5
            updateWidthSlider(newValue)
        end
    
        widthSliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingWidth = true
                updateWidthFromPosition(input)
            end
        end)
        widthSliderBG.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingWidth = false
            end
        end)
        widthSliderBG.InputChanged:Connect(function(input)
            if isDraggingWidth and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateWidthFromPosition(input)
            end
        end)
    
        -- Animation Speed Slider Section (compact layout)
        local speedSection = Instance.new("Frame")
        speedSection.Name = "SpeedSection"
        speedSection.Size = UDim2.new(1, 0, 0, 50)
        speedSection.Position = UDim2.new(0, 0, 0, 145) -- Position below width slider
        speedSection.BackgroundTransparency = 1
        speedSection.Parent = contentFrame
    
        local speedLabel = Instance.new("TextLabel")
        speedLabel.Name = "SpeedLabel"
        speedLabel.Size = UDim2.new(1, 0, 0, 20)
        speedLabel.Text = "Animation Speed: 100%"
        speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLabel.TextSize = 14
        speedLabel.Font = Enum.Font.GothamMedium
        speedLabel.BackgroundTransparency = 1
        speedLabel.TextXAlignment = Enum.TextXAlignment.Left
        speedLabel.Parent = speedSection
    
        local speedSliderBG = Instance.new("Frame")
        speedSliderBG.Name = "SpeedSliderBG"
        speedSliderBG.Size = UDim2.new(1, 0, 0, 12)
        speedSliderBG.Position = UDim2.new(0, 0, 0, 25)
        speedSliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        speedSliderBG.BorderSizePixel = 0
        local speedSliderBGCorner = Instance.new("UICorner")
        speedSliderBGCorner.CornerRadius = UDim.new(0, 4)
        speedSliderBGCorner.Parent = speedSliderBG
        speedSliderBG.Parent = speedSection
    
        local speedSliderFill = Instance.new("Frame")
        speedSliderFill.Name = "SpeedSliderFill"
        speedSliderFill.Size = UDim2.new(1, 0, 1, 0)
        speedSliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        speedSliderFill.BorderSizePixel = 0
        local speedSliderFillCorner = Instance.new("UICorner")
        speedSliderFillCorner.CornerRadius = UDim.new(0, 4)
        speedSliderFillCorner.Parent = speedSliderFill
        speedSliderFill.Parent = speedSliderBG
    
        local function updateSpeedSlider(value)
            local fillValue = 0
            if value <= 0 then -- Min speed 0%
                fillValue = 0
            elseif value >= 3.6 then -- Max speed 360%
                fillValue = 1
            else
                fillValue = (value) / (3.6)
            end
            speedSliderFill.Size = UDim2.new(fillValue, 0, 1, 0)
            speedLabel.Text = "Animation Speed: " .. math.floor(value * 100) .. "%"
            fakeAnimSpeed = value -- Update global animation speed variable, 100% on slider is original speed
        end
    
        updateSpeedSlider(1.7) -- Initialize slider to 170% which will be original speed
    
        local isDraggingSpeed = false
        local function updateSpeedFromPosition(input)
            local sliderPosition = (input.Position.X - speedSliderBG.AbsolutePosition.X) / speedSliderBG.AbsoluteSize.X
            sliderPosition = math.clamp(sliderPosition, 0, 1)
            local newValue = sliderPosition * 3.6 -- Slider range 0 to 3.6 (0% to 360%)
            updateSpeedSlider(newValue)
        end
    
        speedSliderBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSpeed = true
                updateSpeedFromPosition(input)
            end
        end)
        speedSliderBG.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingSpeed = false
            end
        end)
        speedSliderBG.InputChanged:Connect(function(input)
            if isDraggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSpeedFromPosition(input)
            end
        end)
    
    
        closeButton.MouseButton1Click:Connect(function()
            screenGui:Destroy()
        end)
    
        -- Minimize Logic ---
        local originalGuiHeight = mainFrame.Size.Y.Offset -- Store initial height
        local minimizedGuiHeight = titleBar.Size.Y.Offset + 10 -- Height when minimized
        local minimized = false -- Track minimized state
    
        minimizeButton.MouseButton1Click:Connect(function() -- Minimize button functionality
            minimized = not minimized
            if minimized then
                contentFrame.Visible = false -- Hide content
                mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, minimizedGuiHeight) -- Resize to minimized height
            else
                contentFrame.Visible = true -- Show content
                mainFrame.Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, originalGuiHeight) -- Restore original height
            end
        end)
        -- End Minimize Logic ---
    
    
        toggleButton.MouseButton1Click:Connect(function()
            local newState = not getGhostEnabled()
            toggleGhost(newState)
            if newState then
                toggleButton.Text = "Disable Reanimation"
                toggleButton.BackgroundColor3 = Color3.fromRGB(211, 47, 47)
                updateSizeSlider(getSizeValue())
                updateWidthSlider(getWidthValue())
            else
                toggleButton.Text = "Enable Reanimation"
                toggleButton.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            end
        end)
    
        local dragging = false
        local dragInput, dragStart, startPos
        local function updateInput(input)
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
    
        titleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
    
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input == dragInput) then
                updateInput(input)
            end
        end)
    
        -- EXTRA SECTION: Animation Input & Buttons
        local fakeAnimSection = Instance.new("Frame")
        fakeAnimSection.Name = "FakeAnimSection"
        fakeAnimSection.Size = UDim2.new(1, 0, 0, 50)
        fakeAnimSection.Position = UDim2.new(0, 0, 0, 195) -- Position below width slider
        fakeAnimSection.BackgroundTransparency = 1
        fakeAnimSection.Parent = contentFrame
    
        local fakeAnimTextBox = Instance.new("TextBox")
        fakeAnimTextBox.Name = "FakeAnimTextBox"
        fakeAnimTextBox.Text = ""
        fakeAnimTextBox.Size = UDim2.new(0.8, 0, 0.8, 0)
        fakeAnimTextBox.Position = UDim2.new(0.1, 0, 0, 0)
        fakeAnimTextBox.PlaceholderText = "Animation ID"
        fakeAnimTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        fakeAnimTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        local fakeAnimTextBoxCorner = Instance.new("UICorner") -- Rounded corner for fakeAnimTextBox
        fakeAnimTextBoxCorner.CornerRadius = UDim.new(0, 6)
        fakeAnimTextBoxCorner.Parent = fakeAnimTextBox
        fakeAnimTextBox.Parent = fakeAnimSection
    
        local fakeAnimButton = Instance.new("TextButton")
        fakeAnimButton.Name = "FakeAnimButton"
        fakeAnimButton.Size = UDim2.new(0.8, 0, 0.8, 0)
        fakeAnimButton.Position = UDim2.new(0.1, 0, 1, 0)
        fakeAnimButton.Text = "Play Animation"
        fakeAnimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        fakeAnimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        local fakeAnimButtonCorner = Instance.new("UICorner") -- Rounded corner for fakeAnimButton
        fakeAnimButtonCorner.CornerRadius = UDim.new(0, 8)
        fakeAnimButtonCorner.Parent = fakeAnimButton
        fakeAnimButton.Parent = fakeAnimSection
    
        local stopFakeAnimButton = Instance.new("TextButton")
        stopFakeAnimButton.Name = "StopFakeAnimButton"
        stopFakeAnimButton.Size = UDim2.new(0.8, 0, 0.8, 0)
        stopFakeAnimButton.Position = UDim2.new(0.1, 0, 2, 0)
        stopFakeAnimButton.Text = "Stop Animation"
        stopFakeAnimButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        stopFakeAnimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        local stopFakeAnimButtonCorner = Instance.new("UICorner") -- Rounded corner for stopFakeAnimButton
        stopFakeAnimButtonCorner.CornerRadius = UDim.new(0, 8)
        stopFakeAnimButtonCorner.Parent = stopFakeAnimButton
        stopFakeAnimButton.Parent = fakeAnimSection
    
        fakeAnimButton.MouseButton1Click:Connect(function()
            if ghostClone then
                local animId = fakeAnimTextBox.Text
                playFakeAnimation(animId)
            else
                warn("No fake character available!")
            end
        end)
    
        stopFakeAnimButton.MouseButton1Click:Connect(function()
            stopFakeAnimation()
        end)
    
        -- Animation List Button Section
        local animListSection = Instance.new("Frame")
        animListSection.Name = "AnimListSection"
        animListSection.Size = UDim2.new(1, 0, 0, 40)
        animListSection.Position = UDim2.new(0, 0, 1, -40) -- Position at the bottom
        animListSection.BackgroundTransparency = 1
        animListSection.Parent = contentFrame
    
        local animListButton = Instance.new("TextButton")
        animListButton.Name = "AnimListButton"
        animListButton.Size = UDim2.new(1, 0, 1, 0)
        animListButton.Position = UDim2.new(0, 0, 0, 0)
        animListButton.Text = "Open Animation List"
        animListButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        animListButton.TextSize = 16
        animListButton.Font = Enum.Font.GothamSemibold
        animListButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        animListButton.BorderSizePixel = 0
        animListButton.AutoButtonColor = true
        local animListCorner = Instance.new("UICorner") -- Rounded corner for animListButton
        animListCorner.CornerRadius = UDim.new(0, 8)
        animListCorner.Parent = animListButton
        animListButton.Parent = animListSection
    
        animListButton.MouseButton1Click:Connect(function()
            if animationListGui then
                animationListGui:Destroy()
                animationListGui = nil
                animListButton.Text = "Open Animation List"
            else
                animationListGui = createAnimationListGui(fakeAnimTextBox)
                animListButton.Text = "Close Animation List"
            end
        end)
    
    
        return screenGui
    end
    
    local gui = createDraggableGui(
        function() return ghostEnabled end,
        setGhostEnabled,
        function() return cloneSize end,
        function(size)
            cloneSize = size
            if ghostEnabled and ghostClone then
                updateCloneScale()
            end
        end,
        function() return cloneWidth end,
        function(width)
            cloneWidth = width
            if ghostEnabled and ghostClone then
                updateCloneScale()
            end
        end
    )
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    -- NEW: Keybind Handling outside GUI
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end -- Don't process if chat or other UI is using input
        if input.UserInputType == Enum.UserInputType.Keyboard then
            for animName, keyCode in pairs(animationKeybinds) do
                if input.KeyCode == keyCode then
                    playFakeAnimation(BuiltInAnimationsR15[animName])
                    return -- Stop checking after finding a match
                end
            end
        end
    end)

	end}
})

-- Add a few more sample tabs
createTab("VC", {
	{"Force Disconnect VC", function() game:GetService("VoiceChatInternal"):Leave() end},
	{"Force Reconnect", function() local voiceChatService = game:GetService("VoiceChatService")
voiceChatService:joinVoice()
 end},
	{"Backpack", function() print("Backpack opened") end}
})

createTab("Teleports", {
	{"TP to Spawn", function() print("Teleport Spawn") end},
	{"TP to Player", function() print("Teleport Player") end},
	{"TP to Base", function() print("Teleport Base") end}
})

pages:FindFirstChild("Home").Visible = true

navList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	navHolder.CanvasSize = UDim2.new(0, 0, 0, navList.AbsoluteContentSize.Y + 10)
end)

local dragging, dragInput, dragStart, startPos
top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = base.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

top.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		base.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Minimize Animation
local isMinimized = false
minimize.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local newSize = isMinimized and UDim2.new(0, 600, 0, 40) or UDim2.new(0, 600, 0, 360)
	TweenService:Create(base, TweenInfo.new(0.3), {Size = newSize}):Play()
	navHolder.Visible = not isMinimized
	content.Visible = not isMinimized
end)

-- RightShift slide toggle
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		local hidden = base.Position.Y.Scale > 1
		local target = hidden and UDim2.new(0.5, -300, 0.5, -180) or UDim2.new(0.5, -300, 1.5, 0)
		TweenService:Create(base, TweenInfo.new(0.4), {Position = target}):Play()
	end
end)

-- Smooth Close
close.MouseButton1Click:Connect(function()
	TweenService:Create(base, TweenInfo.new(0.4), {
		Position = UDim2.new(0.5, -300, 1.5, 0)
	}):Play()
	task.wait(0.4)
	gui:Destroy()
end)
