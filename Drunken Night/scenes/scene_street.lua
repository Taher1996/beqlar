-- Street Scene (Cleaned)
local composer = require("composer")
local scene = composer.newScene()

-- Forward declarations
local playerMovement = require("scripts.data")
local drunkenguy
local currentFrequence = "walkRight"
local speed = 2

-- Global keys table
if not _G.keysPressed then
    _G.keysPressed = {}
end
local keysPressed = _G.keysPressed

function scene:create(event)
    local sceneGroup = self.view

    -- Get screen dimensions
    local screenW = display.contentWidth
    local screenH = display.contentHeight

    -- Load background image
    local backGround = display.newImageRect("images/pixel_taivas.png", screenW, screenH)
    backGround.x = display.contentCenterX
    backGround.y = display.contentCenterY
    sceneGroup:insert(backGround)

    -- Load WALK sprite sheet
    local walkOptions = require("images.sprite-0004")
    local walkSheet = graphics.newImageSheet("images/Sprite-0004.png", walkOptions)

    -- Load JUMP sprite sheet
    local jumpOptions = require("images.sprite-0004jump")
    local jumpSheet = graphics.newImageSheet("images/Sprite-0004jump.png", jumpOptions)

    -- Create sprite with WALK sheet
    drunkenguy = display.newSprite(walkSheet, {
        {
            name = "walkRight",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkLeft",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkUp",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkDown",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkUpRight",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkUpLeft",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkDownRight",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        },
        {
            name = "walkDownLeft",
            frames = {1, 2, 3, 4, 5, 6, 7},
            time = 1300,
            loopCount = 0
        }
    })

    drunkenguy.x = display.contentCenterX
    drunkenguy.y = 510
    drunkenguy:setSequence("walkRight")
    drunkenguy.xScale = 0.5
    drunkenguy.yScale = 0.5
    sceneGroup:insert(drunkenguy)

    -- Save to scene data
    self.drunkenguy = drunkenguy
    self.jumpSheet = jumpSheet
end

function scene:show(event)
    local phase = event.phase

    if phase == "will" then
        -- When coming from kiosk scene, place character on right side
        if event.params and event.params.fromKiosk then
            drunkenguy.x = display.contentWidth - 50
        end
    end

    if phase == "did" then
        -- Reset keys first
        for k in pairs(_G.keysPressed) do
            _G.keysPressed[k] = nil
        end

        -- Keyboard listener
        local function onKey(event)
            if event.phase == "down" then
                keysPressed[event.keyName] = true
            elseif event.phase == "up" then
                keysPressed[event.keyName] = false
            end
            return false
        end

        -- Continuous update
        local sceneActive = true
        local function gameLoop()
            if not sceneActive then return end

            -- Update returns two values: sequence and isMoving
            currentFrequence = playerMovement.update(drunkenguy, keysPressed, currentFrequence, speed)

            -- Check scene transition: right -> kiosk
            if drunkenguy.x > display.contentWidth then
                sceneActive = false
                Runtime:removeEventListener("key", self.onKey)
                Runtime:removeEventListener("enterFrame", self.gameLoop)
                composer.gotoScene("scenes.scene_kiosk", {
                    effect = "slideLeft",
                    time = 300,
                    params = { fromStreet = true }
                })
            end
        end

        Runtime:addEventListener("key", onKey)
        Runtime:addEventListener("enterFrame", gameLoop)

        -- Save listeners for cleanup
        self.onKey = onKey
        self.gameLoop = gameLoop
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "will" then
        -- Remove listeners
        if self.onKey then
            Runtime:removeEventListener("key", self.onKey)
        end
        if self.gameLoop then
            Runtime:removeEventListener("enterFrame", self.gameLoop)
        end

        -- Reset all key presses
        for k in pairs(_G.keysPressed) do
            _G.keysPressed[k] = nil
        end
    end
end

function scene:destroy(event)
    -- Cleanup if needed
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene