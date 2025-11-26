-- Kiosk Scene (Cleaned)
local composer = require("composer")
local scene = composer.newScene()

-- Forward declarations
local playerMovement = require("scripts.data")
local drunkenguy
local kiosk
local kioskCollisionBox
local currentFrequence = "walkRight"
local speed = 2

-- Global keys table
if not _G.keysPressed then
    _G.keysPressed = {}
end
local keysPressed = _G.keysPressed

-- Collision check function
local function checkCollision(player, collisionBox)
    local playerLeft = player.x - (272 * math.abs(player.xScale))/4
    local playerRight = player.x + (272 * math.abs(player.xScale))/4
    local playerTop = player.y - (256 * player.yScale)/4
    local playerBottom = player.y + (256 * player.yScale)/4

    local boxLeft = collisionBox.x - collisionBox.width/1
    local boxRight = collisionBox.x + collisionBox.width/4
    local boxTop = collisionBox.y - collisionBox.height/4
    local boxBottom = collisionBox.y + collisionBox.height/4

    return not (playerLeft > boxRight or playerRight < boxLeft or
                playerTop > boxBottom or playerBottom < boxTop)
end

function scene:create(event)
    local sceneGroup = self.view

    -- Get screen dimensions
    local screenW = display.contentWidth
    local screenH = display.contentHeight

    -- Load background
    local backGround = display.newImageRect("images/tile_taivas.png", screenW, screenH)
    backGround.x = display.contentCenterX
    backGround.y = display.contentCenterY
    sceneGroup:insert(backGround)

    -- Load kiosk (left side, lower)
    kiosk = display.newImageRect("images/kioski.png", 200, 300)
    kiosk.x = 100
    kiosk.y = display.contentCenterY + 105
    sceneGroup:insert(kiosk)

    -- Create invisible collision box
    kioskCollisionBox = display.newRect(100, display.contentCenterY + 105, 120, 200)
    kioskCollisionBox.alpha = 0
    kioskCollisionBox.isVisible = false
    sceneGroup:insert(kioskCollisionBox)

    -- Load sprite sheet
    local walkOptions = require("images.sprite-0004")
    local walkSheet = graphics.newImageSheet("images/Sprite-0004.png", walkOptions)

    -- Create sprite
    drunkenguy = display.newSprite(walkSheet, {
        { name="walkRight", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkLeft", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkUp", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkDown", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkUpRight", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkUpLeft", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkDownRight", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 },
        { name="walkDownLeft", frames={1,2,3,4,5,6,7}, time=1300, loopCount=0 }
    })

    drunkenguy.x = display.contentCenterX
    drunkenguy.y = 510
    drunkenguy:setSequence("walkRight")
    drunkenguy.xScale = 0.5
    drunkenguy.yScale = 0.5
    sceneGroup:insert(drunkenguy)

    -- Save to scene data
    self.kiosk = kiosk
    self.kioskCollisionBox = kioskCollisionBox
end

function scene:show(event)
    local phase = event.phase

    if phase == "will" then
        -- When coming from main scene (left), place character on right side
        if event.params and event.params.fromMain then
            drunkenguy.x = display.contentWidth - 50
        end
        -- When coming from street scene (right), place character on left side
        if event.params and event.params.fromStreet then
            drunkenguy.x = 50
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

            -- Save old position
            local oldX = drunkenguy.x
            local oldY = drunkenguy.y

            currentFrequence = playerMovement.update(drunkenguy, keysPressed, currentFrequence, speed)

            -- Check collision with kiosk (use collision box)
            if checkCollision(drunkenguy, kioskCollisionBox) then
                -- Restore old position if collision
                drunkenguy.x = oldX
                drunkenguy.y = oldY
            end

            -- Check scene transition: right -> main
            if drunkenguy.x > display.contentWidth then
                sceneActive = false
                Runtime:removeEventListener("key", self.onKey)
                Runtime:removeEventListener("enterFrame", self.gameLoop)
                composer.gotoScene("scenes.scene_main", {
                    effect = "slideLeft",
                    time = 300,
                    params = { fromKiosk = true }
                })
            end

            -- Check scene transition: left -> street
            if drunkenguy.x < 0 then
                sceneActive = false
                Runtime:removeEventListener("key", self.onKey)
                Runtime:removeEventListener("enterFrame", self.gameLoop)
                composer.gotoScene("scenes.scene_street", {
                    effect = "slideLeft",
                    time = 300,
                    params = { fromKiosk = true }
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