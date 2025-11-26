--piilotetaan status bar
display.setStatusBar(display.HiddenStatusBar)

-- Ladataan playerMovement-moduuli
local playerMovement = require("scripts.data")

-- Hae näytön mitat
local screenW = display.contentWidth
local screenH = display.contentHeight

-- Lataa ja skaalaa taustakuva niin, että se täyttää koko näytön
local backGround = display.newImageRect("images/tile_taivas.png", screenW, screenH)

-- Aseta kuvan sijainti näytön keskelle
backGround.x = display.contentCenterX
backGround.y = display.contentCenterY

-- Lataa sprite sheet
local options = {
    width = 544,    -- yhden framen leveys
    height = 512,   -- yhden framen korkeus
    numFrames = 7   -- framien määrä (1-7)
}
local sheet = graphics.newImageSheet("images/Sprite-0004.png", options)

-- Animaatiosekvenssit: kävely kaikkiin suuntiin + diagonaalit
-- Kaikki käyttävät samoja 7 framea sheetista
local sequenceData = {
    { name="walkRight", start=1, count=7, time=1300, loopCount=1 },
    { name="walkLeft",  start=1, count=7, time=1300, loopCount=1 },
    { name="walkUp",    start=1, count=7, time=1300, loopCount=1 },
    { name="walkDown",  start=1, count=7, time=1300, loopCount=1 },
    { name="walkUpRight", start=1, count=7, time=1300, loopCount=1 },
    { name="walkUpLeft",  start=1, count=7, time=1300, loopCount=1 },
    { name="walkDownRight", start=1, count=7, time=1300, loopCount=1 },
    { name="walkDownLeft",  start=1, count=7, time=1300, loopCount=1 }
}

-- Luo sprite
local drunkenguy = display.newSprite(sheet, sequenceData)
drunkenguy.x = display.contentCenterX
drunkenguy.y = display.contentCenterY
drunkenguy:setSequence("walkRight")
drunkenguy.xScale = 0.5  -- 50% pienempi (kaksi kertaa pienempi)
drunkenguy.yScale = 0.5  -- 50% pienempi

-- Nopeus
local speed = 1

-- Seurataan painettuja näppäimiä
local keysPressed = {}
local currentFrequence = "walkRight"  -- muista nykyinen sekvenssi

-- Näppäimistön kuuntelija
local function onKey(event)
    if event.phase == "down" then
        keysPressed[event.keyName] = true
    elseif event.phase == "up" then
        keysPressed[event.keyName] = false
    end
    return false
end

-- Jatkuva päivitys - liike joka framella
local function gameLoop()
    currentFrequence = playerMovement.update(drunkenguy, keysPressed, currentFrequence, speed)
end

-- Lisää kuuntelijat
Runtime:addEventListener("key", onKey)
Runtime:addEventListener("enterFrame", gameLoop)