--tähän kirjoitetaan kaikki hahmon liikkuvuudet, sekä animaatiot

-- Luodaan moduuli
local playerMovement = {}

-- Pelaajan liikkumisen update-funktio
function playerMovement.update(character, keysPressed, currentSequence, speed)
    local isMoving = false
    local moveX = 0
    local moveY = 0
    local newSequence = nil

    -- Tarkista liikkeen suunta
    if keysPressed["right"] then
        moveX = speed
    end
    if keysPressed["left"] then
        moveX = -speed
    end
    if keysPressed["up"] then
        moveY = -speed
    end
    if keysPressed["down"] then
        moveY = speed
    end

    -- Määritä animaatiossekvenssi sen perusteella mitä näppäimiä pidetään pohjassa
    if moveX ~= 0 or moveY ~= 0 then
        isMoving = true

        if moveX > 0 and moveY == 0 then
            newSequence = "walkRight"
        elseif moveX < 0 and moveY == 0 then
            newSequence = "walkLeft"
        elseif moveX == 0 and moveY < 0 then
            newSequence = "walkUp"
        elseif moveX == 0 and moveY > 0 then
            newSequence = "walkDown"
        elseif moveX > 0 and moveY < 0 then
            newSequence = "walkUpRight"
        elseif moveX < 0 and moveY < 0 then
            newSequence = "walkUpLeft"
        elseif moveX > 0 and moveY > 0 then
            newSequence = "walkDownRight"
        elseif moveX < 0 and moveY > 0 then
            newSequence = "walkDownLeft"
        end

        -- Vaihda sekvenssi vain tarvittaessa
        if newSequence and currentSequence ~= newSequence then
            character:setSequence(newSequence)
            currentSequence = newSequence
        end

        character:play()

        -- Aseta oikea xScale riippuen liikkeen suunnasta
        if moveX > 0 then
            character.xScale = 0.5
        elseif moveX < 0 then
            character.xScale = -0.5
        end

        -- Liikuta hahmoa
        character.x = character.x + moveX
        character.y = character.y + moveY
    else
        -- Jos ei liikuta, pysäytä animaatio
        character:pause()
    end

    return currentSequence, isMoving
end

return playerMovement