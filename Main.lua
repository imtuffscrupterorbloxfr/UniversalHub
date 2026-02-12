local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

local function getHRP()
	return getChar():WaitForChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,120,0,35)
toggle.Position = UDim2.new(0,20,0,20)
toggle.Text = "Open Hub"
toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = gui
Instance.new("UICorner", toggle)

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,350)
frame.Position = UDim2.new(0.5,-160,0.5,-175)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame)

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggle.Text = frame.Visible and "Close Hub" or "Open Hub"
end)

local function makeBtn(text, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0.8,0,0,40)
	b.Position = UDim2.new(0.1,0,0,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = frame
	Instance.new("UICorner", b)
	return b
end

local function makeBox(placeholder, y)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.8,0,0,35)
	box.Position = UDim2.new(0.1,0,0,y)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(45,45,45)
	box.TextColor3 = Color3.new(1,1,1)
	box.Parent = frame
	Instance.new("UICorner", box)
	return box
end

--------------------------------------------------
-- SPEED
--------------------------------------------------

local speedBox = makeBox("Enter Speed (Default 16)", 40)
local speedBtn = makeBtn("Set Speed", 80)

speedBtn.MouseButton1Click:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		getHum().WalkSpeed = num
	end
end)

--------------------------------------------------
-- GODMODE
--------------------------------------------------

local god = false
local godBtn = makeBtn("Godmode: OFF", 130)

godBtn.MouseButton1Click:Connect(function()
	god = not god
	godBtn.Text = god and "Godmode: ON" or "Godmode: OFF"
end)

RunService.Heartbeat:Connect(function()
	if god then
		local hum = getHum()
		if hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end
end)

--------------------------------------------------
-- CLICK TELEPORT
--------------------------------------------------

local clickTP = false
local tpBtn = makeBtn("ClickTP: OFF", 180)

tpBtn.MouseButton1Click:Connect(function()
	clickTP = not clickTP
	tpBtn.Text = clickTP and "ClickTP: ON" or "ClickTP: OFF"
end)

mouse.Button1Down:Connect(function()
	if clickTP and mouse.Hit then
		getHRP().CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
	end
end)

--------------------------------------------------
-- FLY
--------------------------------------------------

local flying = false
local flyBtn = makeBtn("Fly: OFF", 230)
local bodyVelocity
local bodyGyro

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"

	local hrp = getHRP()

	if flying then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.Parent = hrp

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp

		RunService.RenderStepped:Connect(function()
			if flying and bodyVelocity then
				bodyVelocity.Velocity =
					workspace.CurrentCamera.CFrame.LookVector * 60
				bodyGyro.CFrame =
					workspace.CurrentCamera.CFrame
			end
		end)
	else
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	end
end)
