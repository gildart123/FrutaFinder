-- Espera o jogo carregar
repeat wait() until game:IsLoaded()

-- Serviços necessários
local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Lista de frutas
local fruitNames = {
    "Bomb", "Spike", "Chop", "Spring", "Kilo", "Spin", "Flame",
    "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Love",
    "Rubber", "Barrier", "Magma", "Quake", "Buddha", "String", "Phoenix"
}

-- Verifica se é uma fruta
local function isFruit(object)
    for _, name in ipairs(fruitNames) do
        if object:IsA("Tool") and object.Name:lower():find(name:lower()) then
            return true
        end
    end
    return false
end

-- Caminha até a fruta
local function walkTo(position)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = true,
        AgentJumpHeight = 10,
        AgentMaxSlope = 45
    })

    path:ComputeAsync(character.HumanoidRootPart.Position, position)

    if path.Status == Enum.PathStatus.Complete then
        for _, waypoint in ipairs(path:GetWaypoints()) do
            humanoid:MoveTo(waypoint.Position)
            humanoid.MoveToFinished:Wait()
        end
    else
        warn("❌ Caminho não encontrado.")
    end
end

-- Procura e vai até a fruta
local function procurarFruta()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if isFruit(obj) and obj:FindFirstChild("Handle") then
            print("🍍 Fruta encontrada: " .. obj.Name)
            walkTo(obj.Handle.Position)
            return
        end
    end
end

-- Loop
while true do
    pcall(function()
        character = player.Character or player.CharacterAdded:Wait()
        humanoid = character:WaitForChild("Humanoid")
        procurarFruta()
    end)
    wait(15)
end
