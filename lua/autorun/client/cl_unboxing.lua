include("unboxing_config.lua")

hasInited = false

function init2233()

	if hasInited == false and IsValid(LocalPlayer()) then

		LocalPlayer().unboxing = {}
		LocalPlayer().unboxing.keys =0
		LocalPlayer().unboxing.crates = 0

		hasInited  = true

		net.Start("GetSpawnUpdateUnbox")
		net.SendToServer()

	end

end

hook.Add( "Think", "InitThePlayer", init2233 )

surface.CreateFont( "SpinFont", {
	font = "Nexa Bold",
	size = 30,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "SpinFont2", {
	font = "Nexa Bold",
	size = 40,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "SpinFont3", {
	font = "Nexa Bold",
	size = 60,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


surface.CreateFont( "SpinButton4", {

	font = "Nexa Bold",
	size = 17,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,

} )

surface.CreateFont( "SpinButton5", {

	font = "Nexa Bold",
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,

} )

local Frame = nil
local SpinPanel = nil
local items = {}
local isSpinning = false
local glass = Material("unboxing/glass.png")
local glass2 = Material("unboxing/glass_2.png")

UnboxWindowOpen = false
IsUnboxingItems = false

local KeyIcon = Material("unboxing/icon_key.png")
local CrateIcon = Material("unboxing/icon_crate.png")
local OpenIcon = Material("unboxing/icon_padlock.png")

function OpenStore()

	Frame = vgui.Create("DFrame")
	Frame:SetSize(700,640)
	Frame:Center()
	Frame:SetVisible(true)
	Frame:MakePopup()
	Frame:SetDeleteOnClose(true)
	Frame:ShowCloseButton(false)
	Frame:SetTitle("")
	Frame.Paint = function(self , w ,h)

		draw.RoundedBox(0,0,0,w,h,Color(20,20,20,255))

	end

	Frame.OnClose = function(self)

		UnboxWindowOpen = false
		self:Remove()

	end

	CloseButton = vgui.Create("DButton" , Frame)
	CloseButton:SetSize(20,20)
	CloseButton:SetPos(700 - 25 , 5)
	CloseButton:SetText("")
	CloseButton.Paint = function(self , w , h)

		if IsUnboxingItems == false then

			draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

		else

			draw.RoundedBox(0,0,0,w,h,Color(60,60,60))

		end

			surface.SetTextColor(Color( 180,180,180))
			surface.SetFont("SpinButton5")
			local x = surface.GetTextSize("X")/2
			surface.SetTextPos((w/2 )- x , 0)
			surface.DrawText("X")


	end
	CloseButton.DoClick = function(self)

		if IsUnboxingItems == false then
			
			Frame:Close()

		end

	end


	IconPanel = vgui.Create("DPanel" , Frame)
	IconPanel:SetSize(700,380)
	IconPanel:SetPos(0,20)
	IconPanel.Paint = function(self , w , h)

		surface.SetMaterial(CrateIcon)
		surface.SetDrawColor(120,120,120)
		surface.DrawTexturedRect(50 + 20,20,124,124)

		surface.SetTextColor(Color(120,120,120))
		surface.SetFont("SpinFont3")
		local x = surface.GetTextSize(LocalPlayer().unboxing.crates)/2
		surface.SetTextPos((50 + 20) + (124/2) - x ,150)
		surface.DrawText(LocalPlayer().unboxing.crates)

		surface.SetMaterial(OpenIcon )
		surface.SetDrawColor(120,120,120)
		surface.DrawTexturedRect(50 + 233, 20,124,124)

		surface.SetMaterial(KeyIcon)
		surface.SetDrawColor(120,120,120)
		surface.DrawTexturedRect(50 + 233 * 2, 20,124,124)

		surface.SetTextColor(Color(120,120,120))
		surface.SetFont("SpinFont3")
		local x = surface.GetTextSize(LocalPlayer().unboxing.keys)/2
		surface.SetTextPos((50 + 233 * 2) + (124/2) - x ,150)
		surface.DrawText(LocalPlayer().unboxing.keys)

	end

	BuyCrate = vgui.Create("DButton" , IconPanel)
	BuyCrate:SetSize(140 , 30)
	BuyCrate:SetPos(50 + 20  - 10 , 230)
	BuyCrate:SetText("")
	BuyCrate.Paint = function(self , w , h)

		draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

		surface.SetTextColor(Color(180,180,180))
		surface.SetFont("SpinButton4")
		local x = surface.GetTextSize("BUY CRATE ("..UnboxingConfig.CratePrice..")")/2
		surface.SetTextPos(w / 2 - x  , h / 4)
		surface.DrawText("BUY CRATE ("..UnboxingConfig.CratePrice..")")

	end
	BuyCrate.DoClick = function()

		net.Start("BuyCrate")
		net.SendToServer()

	end

	GiftCrate = vgui.Create("DButton" , IconPanel)
	GiftCrate:SetSize(140 , 30)
	GiftCrate:SetPos(50 + 20  - 10 , 230+40)
	GiftCrate:SetText("")
	GiftCrate.Paint = function(self , w , h)

		if LocalPlayer().unboxing.crates > 0 and isSpinning == false then

			draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

		else

			draw.RoundedBox(0,0,0,w,h,Color( 60,60,60))

		end

		surface.SetTextColor(Color(180,180,180))
		surface.SetFont("SpinButton4")
		local x = surface.GetTextSize("GIFT CRATE")/2
		surface.SetTextPos(w / 2 - x  , h / 4)
		surface.DrawText("GIFT CRATE")

	end
	GiftCrate.DoClick = function()

		if LocalPlayer().unboxing.crates > 0 and isSpinning == false then

			CreateGiftCrateMenu()

		end

	end
 
	UnboxCrate = vgui.Create("DButton" , IconPanel)
	UnboxCrate:SetSize(140 , 30)
	UnboxCrate:SetPos(50 + 233 - 10 , 230)
	UnboxCrate:SetText("")
	UnboxCrate.Paint = function(self , w , h)

		if LocalPlayer().unboxing.crates > 0 and LocalPlayer().unboxing.keys > 0 and IsUnboxingItems == false then

			draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

			surface.SetTextColor(Color(180,180,180))
			surface.SetFont("SpinButton4")
			local x = surface.GetTextSize("OPEN CRATE")/2
			surface.SetTextPos(w / 2 - x  , h / 4)
			surface.DrawText("OPEN CRATE")

		else


			draw.RoundedBox(0,0,0,w,h,Color( 60,60,60))

			surface.SetTextColor(Color(180,180,180))
			surface.SetFont("SpinButton4")
			local x = surface.GetTextSize("OPEN CRATE")/2
			surface.SetTextPos(w / 2 - x  , h / 4)
			surface.DrawText("OPEN CRATE")


		end

	end
	UnboxCrate.DoClick = function()

		if LocalPlayer().unboxing.crates > 0 and LocalPlayer().unboxing.keys > 0 and IsUnboxingItems == false then

			net.Start("OpenCrate")
			net.SendToServer()

		end

	end

	UnboxGiftCrate = vgui.Create("DButton" , IconPanel)
	UnboxGiftCrate:SetSize(140 , 30)
	UnboxGiftCrate:SetPos(50 + 233 - 10 , 230 + 40)
	UnboxGiftCrate:SetText("")
	UnboxGiftCrate.Paint = function(self , w , h)

		if LocalPlayer().unboxing.crates > 0 and LocalPlayer().unboxing.keys > 0 and IsUnboxingItems == false then

			draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

			surface.SetTextColor(Color(180,180,180))
			surface.SetFont("SpinButton4")
			local x = surface.GetTextSize("GIFT UNBOX")/2
			surface.SetTextPos(w / 2 - x  , h / 4)
			surface.DrawText("GIFT UNBOX")

		else


			draw.RoundedBox(0,0,0,w,h,Color( 60,60,60))

			surface.SetTextColor(Color(180,180,180))
			surface.SetFont("SpinButton4")
			local x = surface.GetTextSize("GIFT UNBOX")/2
			surface.SetTextPos(w / 2 - x  , h / 4)
			surface.DrawText("GIFT UNBOX")


		end

	end
	UnboxGiftCrate.DoClick = function()

		if LocalPlayer().unboxing.crates > 0 and LocalPlayer().unboxing.keys > 0 and IsUnboxingItems == false then

			net.Start("OpenGiftCrate")
			net.SendToServer()

		end

	end


	BuyKey = vgui.Create("DButton" , IconPanel)
	BuyKey:SetSize(140 , 30)
	BuyKey:SetPos((50 + 233 + 233) - 10  , 230)
	BuyKey:SetText("")
	BuyKey.Paint = function(self , w , h)

		draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

		surface.SetTextColor(Color(180,180,180))
		surface.SetFont("SpinButton4")
		local x = surface.GetTextSize("BUY KEY ("..UnboxingConfig.KeyPrice..")")/2
		surface.SetTextPos(w / 2 - x  , h / 4)
		surface.DrawText("BUY KEY ("..UnboxingConfig.KeyPrice..")")

	end
	BuyKey.DoClick = function()

		net.Start("BuyKey")
		net.SendToServer()

	end

	GiftKey = vgui.Create("DButton" , IconPanel)
	GiftKey:SetSize(140 , 30)
	GiftKey:SetPos((50 + 233 + 233) - 10  , 230 + 40)
	GiftKey:SetText("")
	GiftKey.Paint = function(self , w , h)

		if LocalPlayer().unboxing.keys> 0 and isSpinning == false then

			draw.RoundedBox(0,0,0,w,h,Color( 85 , 125 , 37))

		else

			draw.RoundedBox(0,0,0,w,h,Color( 60,60,60))

		end

		surface.SetTextColor(Color(180,180,180))
		surface.SetFont("SpinButton4")
		local x = surface.GetTextSize("GIFT KEY")/2
		surface.SetTextPos(w / 2 - x  , h / 4)
		surface.DrawText("GIFT KEY")

	end
	GiftKey.DoClick = function()

		if LocalPlayer().unboxing.keys > 0 and isSpinning == false then

			CreateGiftKeyMenu()

		end

	end

	CreateWindow()
	GenerateItems(GenerateSpinList())
	ShiftItems()

end


function GenerateSpinList()
	
	local totalChance = 0

	for k , v in pairs(UnboxingItems) do
		
		totalChance = totalChance + v.itemChance

	end

	local itemList = {}

	for i = 0  , 99 do
		
		local num = math.random(1 , totalChance)

		local prevCheck = 0
		local curCheck = 0

		local item

		for k ,v in pairs(UnboxingItems) do
			
			if num >= prevCheck and num <= prevCheck + v.itemChance then
				

				item = v

			end

			prevCheck = prevCheck + v.itemChance

		end

		itemList[i] = item

	end

	return itemList


end

function ShiftItems()

	for k ,v in pairs(items) do
		
		v.panel:SetPos(v.xPos + 2000 , 10)

	end


end

function CreateGiftCrateMenu()

	local Menu = vgui.Create( "DMenu" )

	local players = player.GetAll()

	for k ,v in pairs(players) do
		
		local temp =  Menu:AddOption(v:Nick())
		temp.ply = v
		temp.DoClick = function(self)

			net.Start("GiftCrate")
			net.WriteEntity(self.ply)
			net.SendToServer()

		end

	end

	Menu:Open()

end

function CreateGiftKeyMenu()

	local Menu = vgui.Create( "DMenu" )

	local players = player.GetAll()

	for k ,v in pairs(players) do
		
		local temp =  Menu:AddOption(v:Nick())
		temp.ply = v
		temp.DoClick = function(self)

			net.Start("GiftKey")
			net.WriteEntity(self.ply)
			net.SendToServer()

		end

	end

	Menu:Open()

end

function CreateWindow()

	UnboxWindowOpen = true

	SpinPanel = vgui.Create("DPanel" , Frame)
	SpinPanel:SetPos(700/2  - (680/2), 330)
	SpinPanel:SetSize(680 , 300)
	SpinPanel.Paint = function(self, w ,h)

		draw.RoundedBox(0,0,0,w,h,Color(30,30,30))

	end

	--GenerateItems()

end

local coinImage = Material("unboxing/points.png")

function GenerateItems(DataTable)

	local randomItems = DataTable

	for i = 0 , 99 do
		
		items[i] = {}
		items[i].xPos = ((((280 + 10) * i) * -1) + ((280 + 10)/2)) - 80

		items[i].panel = vgui.Create("DPanel" , SpinPanel)
		items[i].panel.id = i
		items[i].panel.item = randomItems[i]
		items[i].panel:SetPos( ((((280 + 10) * i) * -1) + ((280 + 10)/2)) - 55 ,10)
		items[i].panel:SetSize(280 , 280)
		items[i].panel.Paint = function(self , w , h)

			draw.RoundedBox(0,0,0,w,h,Color(180,180,180))
			draw.RoundedBox(0,0,h-80,w,80,self.item.itemColor)
			draw.SimpleText(self.item.itemName , "SpinFont" , 5,205 , Color(255,255,255))

		end

		if randomItems[i].Type ~= "POINTS" and randomItems[i].Type ~= "TRAIL" then

			items[i].modelView  = vgui.Create("DModelPanel" , items[i].panel )
			items[i].modelView:SetSize(280,200)
			items[i].modelView:SetModel(items[i].panel.item.itemModel)

			local min, max = items[i].modelView.Entity:GetRenderBounds()

			items[i].modelView:SetCamPos(min:Distance(max) * Vector(0.7, 0.7, 0.7))
			items[i].modelView:SetLookAt((max + min) / 2)

		else

			items[i].modelView  = vgui.Create("DImage" , items[i].panel )
			items[i].modelView:SetSize(200,200)
			items[i].modelView:SetPos(40,0)

			if randomItems[i].Type == "POINTS" then

				items[i].modelView:SetImage("unboxing/points.png")

			else

				items[i].modelView:SetImage("unboxing/trail.png")
				items[i].modelView:SetSize(120,120)
				items[i].modelView:SetPos(80,40)

			end

		end

	end

	Line = vgui.Create("DPanel" , SpinPanel)
	Line:SetSize(680 , 300)
	Line.Paint = function(self , w , h)

		draw.RoundedBox(0,680/2 - 2 , 0 , 4 , h , Color(244,129,0 , 150))

		surface.SetDrawColor(255,255,255 , 255)
		surface.SetMaterial(glass)
		surface.SetDrawColor(255,255,255 , 255)
		surface.DrawTexturedRect(0,0,w,h)
		surface.SetDrawColor(255,255,255 , 255)
		surface.SetMaterial(glass2)
		surface.SetDrawColor(255,255,255 , 255)
		surface.DrawTexturedRect(0,0,w,h)

	end

end

net.Receive("InitSpin" , function()

	local data = net.ReadTable()

	Spin(data)

end)

Speed = 10000
EndPoint = 0

function Spin(data)

	CreateWindow()

	for k ,v in pairs(items) do
		
		if IsValid(items[k].panel) then

			items[k].panel:Remove()
			items[k].modelView:Remove()

		end

	end

	if IsValid(Line) then

		Line:Remove()

	end

	IsUnboxingItems = true

	GenerateItems(data)

	isSpinning = true
	Speed = math.random(10000 , 15000)
	EndPoint = (280 * 3) + (math.random(20,250))

end

local prevItemValue = 0



function SpinItems()

	Speed = Lerp(0.4*FrameTime() , Speed , EndPoint )

	if math.floor(Speed / (280 + 10)) ~= prevItemValue then
		
		LocalPlayer():EmitSound("unboxing/next_item.wav")

	end

	for k ,v in pairs(items) do
		
		v.panel:SetPos(v.xPos + Speed , 10)

	end



	if Speed < EndPoint  + 100 then
		
		isSpinning = false

		LocalPlayer():ChatPrint(items[prevItemValue].panel.item.itemName)

		net.Start("FinishedUnbox")
			net.WriteInt(math.floor(Speed / (280 + 10)) , 16)
		net.SendToServer()

		surface.PlaySound("buttons/lever6.wav")

		IsUnboxingItems = false
			
	end

	local tempSpinPos = 76561198064956670

	prevItemValue = math.floor(Speed / (280 + 10))


end

function spinUpdate()

	if isSpinning then
		
		SpinItems()

	end


end


hook.Add("Think" , "Spin The Items" , spinUpdate)

hook.Add("OnPlayerChat" , "testshit" , function(ply , text)

	if ply == LocalPlayer() then
			
		if string.lower(text) == "!unbox" or string.lower(text) == "/unbox" then
			
			OpenStore()

		end


	end


end)


net.Receive("UnboxUpdate" , function(len)

	local keys = net.ReadInt(16)
	local crates = net.ReadInt(16)

	LocalPlayer().unboxing = {}
	LocalPlayer().unboxing.keys = keys
	LocalPlayer().unboxing.crates = crates


end)

net.Receive("SomeoneFound" , function()

	local name = net.ReadString()
	local item = net.ReadString()
	local color = net.ReadColor()

	chat.AddText(Color(255,255,255) , "Player " , Color(40,255,60) , name , Color(255,255,255) , " Unboxed " , color , item , "!")


end)

net.Receive("SomeoneGiftFound" , function()

	local name = net.ReadString()
	local receiver = net.ReadString()
	local item = net.ReadString()
	local color = net.ReadColor()

	chat.AddText(Color(255,255,255) , "Player " , Color(40,255,60) , name , Color(255,255,255) , " Unboxed " , color , item , Color(255,255,255) , " And Gifted It To " , Color(40,255,60) ,  receiver)


end)

local hasInited = false



net.Receive("SomeoneGiftedCrate" , function()

	local sender = net.ReadString()
	local receiver = net.ReadEntity()

	chat.AddText(Color(255,255,255) , "Player " , Color(40,255,60) , sender , Color(255,255,255) , " Gifted A Crate To " , Color(120,120,255),  receiver:Nick().."!")


end)

net.Receive("SomeoneGiftedKey" , function()

	local sender = net.ReadString()
	local receiver = net.ReadEntity()

	chat.AddText(Color(255,255,255) , "Player " , Color(40,255,60) , sender , Color(255,255,255) , " Gifted A Key To " , Color(120,120,255),  receiver:Nick().."!")


end)