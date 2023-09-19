-- Chamar a biblioteca de física.
local physics = require ("physics")
-- Iniciar o motor de física.
physics.start ()
-- Definir a gravidade.
physics.setGravity (0, 0)
-- Definir o modo de renderização.
physics.setDrawMode ("normal")

-- Remover a barra de notificações.
display.setStatusBar (display.HiddenStatusBar)

-- Criar os grupos de exibição.
local grupoBg = display.newGroup() -- Objetos decorativos, cenários (não tem interação)
local grupoMain = display.newGroup() -- Bloco principal (tudo que precisa interagir com o player fica nesse grupo)
local grupoUI = display.newGroup() -- Interface do usuário (placares, botões, pontos, menus)
local bgAudio = audio.loadStream ("Audio/bg.mp3")
audio.reserveChannels (1)
audio.setVolume (0.6, {channel=1})
audio.play (bgAudio, {channel=1, loops=-1})

local audioTiro = audio.loadSound ("Audio/feitico.mp3")
local parametros = {time = 1000, fadein = 100}

-- Criar variáveis de pontos e vidas para atribuição de valor.
local pontos = 0
local vidas = 5

-- Adicionar Backgroun.
local bg = display.newImageRect (grupoBg, "imagens/bg3.png", 480*1.5, 253*2)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

-- Adicionar placar na tela.
local pontosText = display.newText (grupoUI, "Pontos: " .. pontos, 50, 30, native.systemFont, 20)
pontosText:setFillColor (39/255, 68/255, 199/255)

local vidasText  = display.newText (grupoUI, "Vidas: " .. vidas, 150, 30, native.systemFont, 20)
vidasText:setFillColor (39/255, 68/255, 199/255)

-- Adicionar herói
local player = display.newImageRect (grupoMain, "imagens/player3.png", 274*0.25, 184*0.25)
player.x = 30
player.y = 370
player.myName = "Spaceship"
physics.addBody (player, "kinematic")

-- Criar botões:
local botaoCima = display.newImageRect (grupoMain, "imagens/button.png", 1280/22, 1279/22)
botaoCima.x = 240
botaoCima.y = 440
botaoCima.rotation = -90

local botaoBaixo = display.newImageRect (grupoMain, "imagens/button.png", 1280/22, 1279/22)
botaoBaixo.x = 80
botaoBaixo.y = 440
botaoBaixo.rotation = 90

-- Adicionar funções de movimentação
local function cima ()
    player.y = player.y - 10
end

local function baixo ()
    player.y = player.y + 10
end

-- Adicionar o ouvinte e a função do botão.
botaoCima:addEventListener ("tap", cima)
botaoBaixo:addEventListener ("tap", baixo)

-- Adicionar botão de tiro:
local botaoTiro = display.newImageRect (grupoMain, "imagens/button.png", 1280/22, 1279/22)
botaoTiro.x = 160
botaoTiro.y = 440

-- Função para atirar:
local function atirar ()
    local laserPlayer = display.newImageRect (grupoMain, "imagens/beam3.png", 73, 42)
    laserPlayer.x = player.x + 25
    laserPlayer.y = player.y
    physics.addBody (laserPlayer, "dynamic", {isSensor=true})
    transition.to (laserPlayer, {x=500, time=900, 
                    onComplete = function () display.remove (laserPlayer)
                    end})
    laserPlayer.myName = "Laser"
    laserPlayer:toBack ()
end

botaoTiro:addEventListener ("tap", atirar)

-- Adicionar inimigo
local alien = display.newImageRect (grupoMain, "imagens/enemy3.png", 567*0.15, 440*0.15)
alien.x = 270
alien.y = 370
alien.myName = "ET"
physics.addBody (alien, "kinematic")
local direcaoAlien = "cima"

-- Função para alien atirar:
local function inimigoAtirar ()
    local tiroInimigo = display.newImageRect (grupoMain, "imagens/extra3.png", 170*0.2, 170*0.2)
    tiroInimigo.x = alien.x - 55
    tiroInimigo.y = alien.y 
    tiroInimigo.rotation = 45
    physics.addBody (tiroInimigo, "dynamic", {isSensor=true})
    transition.to (tiroInimigo, {x=-200, time=900,
                    onComplete = function () 
                        display.remove (tiroInimigo)
                    end})
    tiroInimigo.myName = "meteor"
end

-- Criando o timer de disparo do inimigo:
-- Comandos timer: (tempo repetição, função,  )
alien.timer = timer.performWithDelay (math.random (1000, 1500), inimigoAtirar, 0)

-- Movimentação do inimigo:
local function movimentarInimigo ()
-- se a localização x não for igual a nulo então
    if not (alien.x == nil ) then
-- Quando a direção do inimigo for cima então
        if (direcaoAlien == "cima" ) then
            alien.y = alien.y - math.random (0, 10)
-- Se a localização y do inimigo for menor ou igual a 50 então
            if (alien.y <= 50 ) then
                    direcaoAlien = "baixo"
            end

        elseif (direcaoAlien == "baixo" ) then
            alien.y = alien.y + math.random (0, 10)

            if (alien.y >= 400 ) then
                direcaoAlien = "cima"
            end
        end

    else
         print ("Inimigo morreu!")
-- Runtime: representa todo o jogo (evento executafo para todos,por um tempo) enterFrame: está ligado ao valor FPS (no caso 60 vezes por segundo)
        Runtime:removeEventListener ("enterFrame", movimentarInimigo)
    end
end

Runtime:addEventListener ("enterFrame", movimentarInimigo)

local function onCollision (event)

-- Fase do evento began
    if (event.phase == "began" ) then
-- Variáveis criadas para facilitar a escrita do código.
        local obj1 = event.object1
        local obj2 = event.object2

        if ((obj1.myName == "Laser" and obj2.myName == "ET") or (obj1.myName == "ET" and obj2.myName == "Laser"))
        then       

            if (obj1.myName == "Laser") then
-- remove o projétil.
                display.remove (obj1)
            else
                display.remove (obj2)
            end
                audio.play (audioTiro, parametros)

-- Somar 10 pontos.
            pontos = pontos + 10
-- Atualizo os pontos na tela.
            pontosText.text = "Pontos: " .. pontos

        elseif ((obj1.myName == "Spaceship" and obj2.myName == "meteor") or (obj1.myName == "meteor" and obj2.myName == "Spaceship")) then

            if (obj1.myName == "meteor") then
                    display.remove (obj1)
            else
                    display.remove (obj2)
            end
                audio.play (audioTiro, parametros)

-- Reduz uma vida do player a cada colisão e atualiza as vidas e mostra.
        vidas = vidas -1
        vidasText.text = "Vidas: " .. vidas
            if (vidas <= 0) then
                Runtime:removeEventListener ("collision", onCollision)
                Runtime:removeEventListener ("enterFrame", movimentarInimigo)
                timer.pause (alien.timer)
                botaoBaixo:removeEventListener ("tap", baixo)
                botaoCima:removeEventListener ("tap", cima)
                botaoTiro:removeEventListener ("tap", atirar)
        
                local gameOver = display.newImageRect (grupoUI, "imagens/gg3.png", 1080/5, 1080/5)
                gameOver.x = display.contentCenterX
                gameOver.y = display.contentCenterY
            end
        end
    end
end

Runtime:addEventListener ("collision", onCollision)
