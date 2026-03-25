local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local SIDE_OFFSET = 8

local function loadScript(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and result then
        loadstring(result)()
    else
        warn("Error al cargar script: " .. tostring(result))
    end
end

local boss = Workspace:FindFirstChild("Cake Queen", true)
if boss and boss:IsA("Model") then
    local root = boss:FindFirstChild("HumanoidRootPart")
        or boss:FindFirstChild("PrimaryPart")
        or boss:FindFirstChildWhichIsA("BasePart")

    if root then
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(root.Position + (root.CFrame.RightVector * SIDE_OFFSET), root.Position)
        print("Reposicionado al lado de Cake Queen")
        task.wait(0.2)
        loadScript("https://raw.githubusercontent.com/LordMoon17/FBScript/main/Farm/WholeCake/CakeQueen/follow.lua")
    end
end
