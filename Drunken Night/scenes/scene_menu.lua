-- Menu Scene (Cleaned)
local composer = require("composer")
local scene = composer.newScene()

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

    -- Title
    local title = display.newText("DRUNKEN NIGHT", display.contentCenterX, 100, native.systemFont, 48)
    title:setFillColor(1, 1, 1)
    sceneGroup:insert(title)

    -- Start button
    local startButton = display.newRect(display.contentCenterX, 300, 200, 60)
    startButton:setFillColor(0.2, 0.5, 0.8)
    sceneGroup:insert(startButton)

    local startText = display.newText("START", display.contentCenterX, 300, native.systemFont, 36)
    startText:setFillColor(1, 1, 1)
    sceneGroup:insert(startText)

    -- Quit button
    local quitButton = display.newRect(display.contentCenterX, 400, 200, 60)
    quitButton:setFillColor(0.8, 0.2, 0.2)
    sceneGroup:insert(quitButton)

    local quitText = display.newText("QUIT GAME", display.contentCenterX, 400, native.systemFont, 36)
    quitText:setFillColor(1, 1, 1)
    sceneGroup:insert(quitText)

    -- Sound settings icon (top right)
    local soundIcon = display.newRect(screenW - 50, 50, 60, 60)
    soundIcon:setFillColor(0.3, 0.3, 0.3)
    sceneGroup:insert(soundIcon)

    local soundText = display.newText("🔊", screenW - 50, 50, native.systemFont, 36)
    soundText:setFillColor(1, 1, 1)
    sceneGroup:insert(soundText)

    -- Button functions
    local function onStartButtonPress(event)
        if event.phase == "ended" then
            composer.gotoScene("scenes.scene_main", "slideLeft")
        end
        return true
    end

    local function onQuitButtonPress(event)
        if event.phase == "ended" then
            native.requestExit()
        end
        return true
    end

    local function onSoundIconPress(event)
        if event.phase == "ended" then
            -- Sound settings coming later
            print("Sound settings (coming soon)")
        end
        return true
    end

    -- Add touch listeners
    startButton:addEventListener("touch", onStartButtonPress)
    quitButton:addEventListener("touch", onQuitButtonPress)
    soundIcon:addEventListener("touch", onSoundIconPress)
end

function scene:show(event)
    -- Scene is visible (no empty branches)
end

function scene:hide(event)
    -- Scene is hidden (no empty branches)
end

function scene:destroy(event)
    -- Cleanup
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene