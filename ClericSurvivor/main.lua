local physics = require ("physics")
physics.start ()
physics.setGravity (0, 0)
physics.setDrawMode ("normal")
display.setStatusBar (display.HiddenStatusBar)

local grupoBg = display.newGroup()
local grupoMain = display.newGroup()
local grupoUI = display.newGroup()

local pontos = 0
local vidas = 5
local especial = 0
local XP = 0

local bg = display.newImageRect (grupoBg, "imagens/floor.png", 750*1.5, 920*2)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local pontosText = display.newText (grupoUI, "Pontos: " .. pontos, 250, 700, native.systemFont, 32)
pontosText:setFillColor (4/255, 52/255, 148/255)
local vidasText  = display.newText (grupoUI, "Vidas: " .. vidas, 400, 700, native.systemFont, 32)
vidasText:setFillColor (4/255, 52/255, 148/255)
local especialText  = display.newText (grupoUI, "Especial: " .. especial, 550, 700, native.systemFont, 32)
especialText:setFillColor (4/255, 52/255, 148/255)

local retanguloArredondado = display.newRoundedRect (grupoBg, 400, 700, 500, 30, 50)
retanguloArredondado:setFillColor (167/255, 193/255, 245/255) 

local player = display.newImageRect (grupoMain, "imagens/cleric2.png", 334*0.55, 243*0.55)
player.x = display.contentCenterX
player.y = display.contentCenterY
player.myName = "Cleric"
physics.addBody (player, "kinematic")

local botaoDireita = display.newImageRect ("imagens/button.png", 1280/25, 1279/25)
botaoDireita.x = 140
botaoDireita.y = 700

local botaoEsquerda = display.newImageRect ("imagens/button.png", 1280/25, 1279/25)
botaoEsquerda.x = 20
botaoEsquerda.y = 700
botaoEsquerda.rotation = 180

local botaoCima = display.newImageRect ("imagens/button.png", 1280/25, 1279/25)
botaoCima.x = 80
botaoCima.y = 650
botaoCima.rotation = 270

local botaoBaixo = display.newImageRect ("imagens/button.png", 1280/25, 1279/25)
botaoBaixo.x = 80
botaoBaixo.y = 750
botaoBaixo.rotation = 90

local botaoAtaque = display.newImageRect (grupoMain, "imagens/button2.png", 142/2, 145/2)
botaoAtaque.x = 80
botaoAtaque.y = 700

-- Adicionar funções de movimentação
local DA = 1
print (DA)

local function direita ()
    player.x = player.x + 10
    player.xScale = 1
    DA = 1
    print (DA)
end

local function esquerda ()
    player.x = player.x - 10
    player.xScale = -1
    DA = 3
    print (DA)
end

local function cima ()
    player.y = player.y - 10
    DA = 4
    print (DA)
end

local function baixo ()
    player.y = player.y + 10
    DA = 2
    print (DA)
end

-- Adicionar o ouvinte e a função do botão.

botaoDireita:addEventListener ("tap", direita)
botaoEsquerda:addEventListener ("tap", esquerda)
botaoCima:addEventListener ("tap", cima)
botaoBaixo:addEventListener ("tap", baixo)

-- Função para atacar:
local function atacar ()
    if (DA == 1) then
        local ataque1 = display.newImageRect (grupoMain, "imagens/slash2.png", 360*0.45, 360*0.45)
        ataque1.x = player.x + 75
        ataque1.y = player.y
        physics.addBody (ataque1, "dynamic", {isSensor=true})
        transition.to (ataque1, {x=player.x + 75, time=500, 
                    onComplete = function () display.remove (ataque1)
                    end})
        ataque1.myName = "Smash"
        ataque1:toBack ()
    end

    if (DA == 2) then
        local ataque2 = display.newImageRect (grupoMain, "imagens/slash2.png", 360*0.45, 360*0.45)
        ataque2.x = player.x
        ataque2.y = player.y + 75
        ataque2.rotation = 90
        physics.addBody (ataque2, "dynamic", {isSensor=true})
        transition.to (ataque2, {y=player.y + 75, time=500, 
                    onComplete = function () display.remove (ataque2)
                    end})
        ataque2.myName = "Smash"
        ataque2:toBack ()       
    end
 
    if (DA == 3) then
        local ataque3 = display.newImageRect (grupoMain, "imagens/slash2.png", 360*0.45, 360*0.45)
        ataque3.x = player.x - 75
        ataque3.y = player.y
        ataque3.xScale = -1
        physics.addBody (ataque3, "dynamic", {isSensor=true})
        transition.to (ataque3, {x=player.x - 75, time=500, 
                    onComplete = function () display.remove (ataque3)
                    end})
        ataque3.myName = "Smash"
        ataque3:toBack ()       
    end

    if (DA == 4) then
        local ataque4 = display.newImageRect (grupoMain, "imagens/slash2.png", 360*0.45, 360*0.45)
        ataque4.x = player.x
        ataque4.y = player.y - 75
        ataque4.rotation = 270
        physics.addBody (ataque4, "dynamic", {isSensor=true})
        transition.to (ataque4, {y=player.y - 75, time=500, 
                    onComplete = function () display.remove (ataque4)
                    end})
        ataque4.myName = "Smash"
        ataque4:toBack ()
    end
end

local function tapDuplo (event)
    
    if (event.numTaps == 2 ) and (especial >= 1) then
        print ("Objeto tocado duas vezes: " ..tostring (event.target))
        local shield = display.newImageRect (grupoMain, "imagens/shield2.png", 360*0.85, 360*0.85)
        shield.x = player.x
        shield.y = player.y
        shield.alpha = 0.75
        physics.addBody (shield, "dynamic", {isSensor=true})
        transition.to (shield, {x=player.x, y=player.y, time=3000, 
                    onComplete = function () display.remove (shield)
                    end})
        shield.myName = "Shield"
        shield:toBack ()
        especial = especial -1
        especialText.text = "Especial: " .. especial
    else
        return true
    end
end 

botaoAtaque:addEventListener ("tap", atacar)
botaoAtaque:addEventListener ("tap", tapDuplo)

-- Adicionar Inimigo

local necromance = display.newImageRect (grupoMain, "imagens/necro2.png", 334*0.65, 243*0.65)
necromance.x = display.contentCenterX
necromance.y = -80
necromance.myName = "Necro"
physics.addBody (necromance, "kinematic")
local direcaoNecro = "direita"

-- Função para alien atirar:

local function magiaNecro ()
    local necroSpell = display.newImageRect (grupoMain, "imagens/skeli2.png", 330*0.45, 242*0.55)
    necroSpell.x = necromance.x
    necroSpell.y = necromance.y 
    physics.addBody (necroSpell, "dynamic", {isSensor=true})
    transition.to (necroSpell, {x=player.x, y=800, time=10000,
                    onComplete = function () 
                        display.remove (necroSpell)
                    end})
    necroSpell.myName = "Skeli"
end

-- Criando o timer de disparo do inimigo:
-- Comandos timer: (tempo repetição, função,  )
necromance.timer = timer.performWithDelay (math.random (5000, 10000), magiaNecro, 0)

-- Movimentação do inimigo:
local function movimentarInimigo ()

    if not (necromance.x == nil ) then

        if (direcaoNecro == "direita" ) then
            necromance.x = necromance.x + (math.random(1, 25))

            if (necromance.x >= 1150 ) then
                    direcaoNecro = "esquerda"
            end

        elseif (direcaoNecro == "esquerda" ) then
            necromance.x = necromance.x - (math.random(1, 25))

            if (necromance.x <= 10 ) then
                direcaoNecro = "direita"
            end
        end
    end
end

Runtime:addEventListener ("enterFrame", movimentarInimigo)

-- Adicionar inimigo2

local necromance2 = display.newImageRect (grupoMain, "imagens/necro2.png", 334*0.65, 243*0.65)
necromance2.x = 1300
necromance2.y = display.contentCenterY
necromance2.myName = "Necro2"
physics.addBody (necromance2, "kinematic")
local direcaoNecro2 = "baixo"

-- Função para inimigo2 atirar:

local function magiaNecro2 ()
    local necroSpell2 = display.newImageRect (grupoMain, "imagens/skeli2.png", 330*0.45, 242*0.55)
    necroSpell2.x = necromance2.x
    necroSpell2.y = necromance2.y 
    physics.addBody (necroSpell2, "dynamic", {isSensor=true})
    transition.to (necroSpell2, {x= -20, y=player.y, time=10000,
                    onComplete = function () 
                        display.remove (necroSpell2)
                    end})
    necroSpell2.myName = "Skeli"
end
necromance2.timer = timer.performWithDelay (math.random (3000, 3500), magiaNecro2, 0)

-- Movimentação do inimigo2:

local function movimentarInimigo2 ()

    if not (necromance2.x == nil ) then

        if (direcaoNecro2 == "cima" ) then
            necromance2.y = necromance2.y - math.random (0, 25)

            if (necromance2.y <= 50 ) then
                    direcaoNecro2 = "baixo"
            end

        elseif (direcaoNecro2 == "baixo" ) then
            necromance2.y = necromance2.y + math.random (0, 25)

            if (necromance2.y >= 700 ) then
                direcaoNecro2 = "cima"
            end
        end
    end
end

Runtime:addEventListener ("enterFrame", movimentarInimigo2)

--Colisões:

local function onCollision (event)

    if (event.phase == "began" ) then

        local obj1 = event.object1
        local obj2 = event.object2

        if ((obj1.myName == "Smash" and obj2.myName == "Skeli") or (obj1.myName == "Skeli" and obj2.myName == "Smash"))
        then
            if (obj1.myName == "Skeli") then

            display.remove (obj1)
            else
            display.remove (obj2)
            end

            pontos = pontos + 10
    XP = XP + 1
            pontosText.text = "Pontos: " .. pontos
            if (XP == 10) then
                vidas = vidas +1
                especial = especial +1
                vidasText.text = "Vidas: " .. vidas
                especialText.text = "Especial: " .. especial
                XP = 0
                pontosText.text = "Pontos: " .. pontos
            end

        elseif ((obj1.myName == "Skeli" and obj2.myName == "Shield") or (obj1.myName == "Shield" and obj2.myName == "Skeli")) then

            if (obj1.myName == "Skeli") then
                    display.remove (obj1)
            else
                    display.remove (obj2)
            end
            pontos = pontos + 10
            XP = XP + 1
            pontosText.text = "Pontos: " .. pontos
            if (XP == 10) then
                vidas = vidas +1
                vidasText.text = "Vidas: " .. vidas
                XP = 0
                pontosText.text = "Pontos: " .. pontos
            end
        end
    end
end

Runtime:addEventListener ("collision", onCollision)