-- Player movement and animations module
local playerMovement = {}

-- Boundaries
local MIN_Y = 510  -- Ground level
local MAX_Y = display.contentHeight - 50  -- Bottom limit

-- Jump variables
local isJumping = false
local jumpVelocity = 0
local JUMP_POWER = -15
local GRAVITY = 0.8

-- Player movement update function
function playerMovement.update(character, keysPressed, currentSequence, speed)
    local moveX = 0
    local moveY = 0
    local newSequence = nil
    local isMoving = false

    -- Check movement direction
    if keysPressed["right"] or keysPressed["d"] then
        moveX = speed
    end
    if keysPressed["left"] or keysPressed["a"] then
        moveX = -speed
    end
    if keysPressed["up"] or keysPressed["w"] then
        moveY = -speed
    end
    if keysPressed["down"] or keysPressed["s"] then
        moveY = speed
    end

    -- Jump (only if not already jumping and on ground)
    if keysPressed["space"] and not isJumping and character.y >= MIN_Y then
        isJumping = true
        jumpVelocity = JUMP_POWER
    end

    -- If jumping
    if isJumping then
        jumpVelocity = jumpVelocity + GRAVITY
        character.y = character.y + jumpVelocity

        -- Check if landed
        if character.y >= MIN_Y then
            character.y = MIN_Y
            isJumping = false
            jumpVelocity = 0
        end

        -- Set jump animation
        newSequence = "jump"
    else
        -- Determine animation sequence based on pressed keys
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
        end
    end

    -- Change sequence only if needed
    if newSequence and currentSequence ~= newSequence then
        character:setSequence(newSequence)
        currentSequence = newSequence
        character:play()
    end

    -- Set correct xScale based on movement direction (if not jumping)
    if not isJumping then
        if moveX > 0 then
            character.xScale = 0.5
        elseif moveX < 0 then
            character.xScale = -0.5
        end
    end

    -- Move character horizontally (can move while jumping too)
    if moveX ~= 0 or moveY ~= 0 then
        if not isJumping then
            character:play()
        end

        -- Calculate new X position
        local newX = character.x + moveX

        -- Calculate new Y position (only if not jumping)
        if not isJumping then
            local newY = character.y + moveY

            -- Check Y-axis boundaries
            if newY < MIN_Y then
                newY = MIN_Y
            end
            if newY > MAX_Y then
                newY = MAX_Y
            end

            character.y = newY
        end

        character.x = newX
    else
        -- If not moving and not jumping, pause animation
        if not isJumping then
            character:pause()
        end
    end

    return currentSequence, isMoving
end

return playerMovement