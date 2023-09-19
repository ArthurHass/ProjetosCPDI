
local composer = require( "composer" )

local scene = composer.newScene()

local fundo

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require ("json")-- Chama biblioteca json para a cena
local pontosTable = {} -- string/tabela para armazenar pontuações 
local filePath = system.pathForFile ("pontos.json", system.DocumentsDirectory) -- cria o arquivo pontos.json e o caminho/endereço para pasta.

local function carregaPontos()
	local pasta = io.open (filePath, "r") --"r" == somente leitura

	if pasta then
		local contents = pasta:read ("*a") -- extrai os dados i guarda na variavel contents (formato JSON)
		io.close (pasta) -- fecha o arquivo
		pontosTable = json.decode (contents) --decodifica de json para Lua e armazena na tabela
	end
	if (pontosTable == nil or #pontosTable == 0) then
		pontosTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	end
end

local function salvaPontos ()
	for i = #pontosTable, 11, -1 do
		table.remove (pontosTable, i)
	end

	local pasta = io.open (filePath, "w")

	if pasta then
		pasta:write (json.encode(pontosTable))
		io.close (pasta)
	end
end


local function gotoMenu ()
	composer.gotoScene ("menu", {time=800, effect="crossFade"})
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	carregaPontos() -- Executa a função que extrai aspontuações anteriores.

	-- Acrescenta a pontuação da partida na tabela.
	table.insert (pontosTable, composer.getVariable("scoreFinal"))

	composer.setVariable ("scoreFinal", 0) -- Redefinir o valor da variável.

	local function compare (a, b)
		-- Organiza os elementos da pontosTable do maior para o menor
		return a > b
	end

	table.sort (pontosTable, compare) -- Classifica a ordem definida na function acima

	salvaPontos() -- Salvaos dados atualizados no arquivo JSON

	local bg = display.newImageRect (sceneGroup, "imagens/bg.png",800, 1400)
	bg.x, bg.y = display.contentCenterX, display.contentCenterY

	local cabecalho = display.newText (sceneGroup, "recordes", display.contentCenterX, 100, native.systemFont, 80)
	cabecalho:setFillColor (0.75, 0.78, 1)
-- Cria um loop de 1 a 10
	for i = 1,10 do
		-- Atribui os valores da pontosTable como os do Loop.
		if (pontosTable[i]) then
			-- define que o espaçamento das pontuações seja uniforme de acordo com o número.
			local yPos = 150 + (i*56)

			local ranking = display.newText (sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 44)
			ranking:setFillColor (0.8)

			ranking.anchorX = 1 -- Alinha o texto a direita alterando a âncora.

			local finalPontos = display.newText (sceneGroup, pontosTable[i], display.contentCenterX-30, yPos, native.systemFont, 44)
			finalPontos.anchorX = 0 -- Alinha o texto a esquerda.
		end
	end

	local menu = display.newText (sceneGroup, "Menu", display.contentCenterX, 810, native.systemFont, 50)

	fundo = audio.loadStream ("audio/Escape_Looping.wav")

	menu:setFillColor (0.75, 0.78, 1)
	menu:addEventListener ("tap", gotoMenu)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		audio.play (fundo, {channel=1, loops=-1})
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene ("recordes")
		audio.stop (1)
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	audio.dispose (fundo)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
