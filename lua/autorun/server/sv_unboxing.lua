AddCSLuaFile("unboxing_subconfig.lua")
AddCSLuaFile("unboxing_config.lua")

include("unboxing_config.lua")
local meta = FindMetaTable("Player")

util.AddNetworkString("InitSpin")
util.AddNetworkString("BuyKey")
util.AddNetworkString("BuyCrate")
util.AddNetworkString("OpenCrate")
util.AddNetworkString("FinishedUnbox")
util.AddNetworkString("GiftCrate")
util.AddNetworkString("GiftKey")
util.AddNetworkString("SomeoneGiftedCrate")
util.AddNetworkString("SomeoneGiftedKey")
util.AddNetworkString("OpenGiftCrate")
util.AddNetworkString("GetSpawnUpdateUnbox")

util.AddNetworkString("SomeoneFound")
util.AddNetworkString("SomeoneGiftFound")

util.AddNetworkString("UnboxUpdate")


net.Receive("GiftCrate" , function(len , ply)

	local target = net.ReadEntity()

	if ply:RemoveCrates(1) then

		if IsValid(target) then
			
			target:AddCrates(1)
			target:ChatPrint( "You received a crate from "..ply:Nick())

			for k , v in pairs(player.GetAll()) do

				net.Start("SomeoneGiftedCrate")
					net.WriteString(ply:Nick())
					net.WriteEntity(target)
				net.Send(v)

			end

		end

	end

end)

net.Receive("GiftKey" , function(len , ply)

	local target = net.ReadEntity()

	if ply:RemoveKeys(1) then

		if IsValid(target) then
			
			target:AddKeys(1)
			target:SendHint( "You received a key from "..ply:Nick() , 3)

			for k , v in pairs(player.GetAll()) do

				net.Start("SomeoneGiftedKey")
					net.WriteString(ply:Nick())
					net.WriteEntity(target)
				net.Send(v)

			end

		end

	end

end)

net.Receive("FinishedUnbox" , function(len , ply)

	local index = net.ReadInt(16)

	local isGift = ply.unboxing.isGift

	local randomTarget = player.GetAll()[math.random(1,table.Count(player.GetAll()))]

	if ply.unboxing.currentlyWaiting == true then
		
		item= ply.unboxing.items[index]

		if item.Type == "MONEY" then
			
			if isGift then

				randomTarget:addMoney(item.moneyAmount)

				ply.unboxing.currentlyWaiting = false

			else

				ply:addMoney(item.moneyAmount)

				ply.unboxing.currentlyWaiting = false

			end

				

		end

		if item.Type == "POINTS" then
			
			if isGift then

				randomTarget:PS_GivePoints(item.PointAmount)

				ply.unboxing.currentlyWaiting = false

			else

				ply:PS_GivePoints(item.PointAmount)

				ply.unboxing.currentlyWaiting = false

			end


		end

		if item.Type == "PITEM" then
			
			if isGift then

				randomTarget:PS_GiveItem(item.itemClassName)

				ply.unboxing.currentlyWaiting = false

			else

				ply:PS_GiveItem(item.itemClassName)

				ply.unboxing.currentlyWaiting = false

			end


		end

		if item.Type == "TRAIL" then
			
			if isGift then

				randomTarget:PS_GiveItem(item.itemClassName)

				ply.unboxing.currentlyWaiting = false

			else

				ply:PS_GiveItem(item.itemClassName)

				ply.unboxing.currentlyWaiting = false

			end


		end


		if item.Type == "HEALTH" then
	
			if isGift then

				randomTarget:SetHealth(ply:Health() + item.healAmount)

				if randomTarget:Health() > 100 then 

					randomTarget:SetHealth(100)

				end

			else

				ply:SetHealth(ply:Health() + item.healAmount)

				if ply:Health() > 100 then 

					ply:SetHealth(100)

				end

			end

			ply.unboxing.currentlyWaiting = false

		end

		if item.Type == "WEAPON" then
	
			if isGift then

				randomTarget:Give(item.weaponName)

			else

				ply:Give(item.weaponName)

			end

			ply.unboxing.currentlyWaiting = false

		end

		if item.Type == "ENTITIY" then
			
			if isGift then

				trace = randomTarget:GetEyeTrace()

	    			posToSpawn = Vector(0,0,0)

				if trace.HitPos:Distance(randomTarget:GetPos()) > 200 then
					
					posToSpawn = (randomTarget:GetPos() + Vector(0,0,50)) + (randomTarget:GetAimVector() * 100 )

				else

					posToSpawn = trace.HitPos

				end

				local temp = ents.Create(item.entityName)
				temp:SetPos(posToSpawn)
				temp:Spawn()

			else

				trace = ply:GetEyeTrace()

	    			posToSpawn = Vector(0,0,0)

				if trace.HitPos:Distance(ply:GetPos()) > 200 then
					
					posToSpawn = (ply:GetPos() + Vector(0,0,50)) + (ply:GetAimVector() * 100 )

				else

					posToSpawn = trace.HitPos

				end

				local temp = ents.Create(item.entityName)
				temp:SetPos(posToSpawn)
				temp:Spawn()


			end

			ply.unboxing.currentlyWaiting = false


		end


		for k , v in pairs(player.GetAll()) do

			if isGift then

				net.Start("SomeoneGiftFound")

					net.WriteString(ply:Nick())
					net.WriteString(randomTarget:Nick())
					net.WriteString(item.itemName)
					net.WriteColor(item.itemColor)

				net.Send(v)

			else

				net.Start("SomeoneFound")
					net.WriteString(ply:Nick())
					net.WriteString(item.itemName)
					net.WriteColor(item.itemColor)
				net.Send(v)

			end

		end

	end

end)

function meta:OpenCrate(isGift)

	if self.unboxing.crates > 0 and self.unboxing.keys > 0 then

		if isGift then

			self.unboxing.isGift = true

		else

			self.unboxing.isGift = false

		end

		self:RemoveKeys(1)
		self:RemoveCrates(1)

		self.unboxing.currentlyWaiting = true


		self:SendSpin()

	end

end

net.Receive("OpenCrate" , function(len , ply)

	ply:OpenCrate(false)


end)

net.Receive("OpenGiftCrate" , function(len , ply)

	ply:OpenCrate(true)


end)



function meta:SaveKeys()

	self:SetPData("KEYS" , self.unboxing.keys)

end


function meta:LoadKeys()

	local data = tonumber(self:GetPData("KEYS" , -1))

	return data

end


function meta:AddKeys(amount)

	self.unboxing.keys = self.unboxing.keys + amount

	self:SaveKeys()
	self:SaveCrates()

	self:SendUnboxUpdate()

end

function meta:RemoveKeys(amount)

	if self.unboxing.keys - amount >= 0 then
		
		self.unboxing.keys = self.unboxing.keys - amount

	else

		return false

	end

	self:SaveKeys()
	self:SaveCrates()

	self:SendUnboxUpdate()

	return true

end


function meta:SaveCrates()

	self:SetPData("CRATES" , self.unboxing.crates)

end


function meta:LoadCrates()

	local data = tonumber(self:GetPData("CRATES" , -1))

	return data

end

function meta:AddCrates(amount)

	self.unboxing.crates = self.unboxing.crates + amount

	self:SaveKeys()
	self:SaveCrates()

	self:SendUnboxUpdate()

end

function meta:RemoveCrates(amount)

	if self.unboxing.crates - amount >= 0 then
		
		self.unboxing.crates = self.unboxing.crates - amount

	else

		return false

	end

	self:SaveKeys()
	self:SaveCrates()

	self:SendUnboxUpdate()

	return true

end

function meta:SendUnboxUpdate()

	net.Start("UnboxUpdate")
		net.WriteInt(self.unboxing.keys , 16)
		net.WriteInt(self.unboxing.crates , 16)
	net.Send(self)

end


function meta:box_initPlayer()

	self.unboxing = {}

	local crates = self:LoadCrates()

	if crates == -1 then
		
		self.unboxing.crates = 0

	else

		self.unboxing.crates = crates

	end

	local keys = self:LoadKeys()

	if keys == -1 then
		
		self.unboxing.keys = 0

	else

		self.unboxing.keys = keys

	end

	self:SaveKeys()
	self:SaveCrates()

	self.CrateTimer = CurTime() + (UnboxingConfig.CrateTimer * 60)
	self.KeyTimer = CurTime() + (UnboxingConfig.KeyTimer * 60)


end

net.Receive("GetSpawnUpdateUnbox" , function(len , ply)

	ply:SendUnboxUpdate()

end)

function meta:GenerateSpinList()
	
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

function meta:SendSpin()

	local items = self:GenerateSpinList()

	self.unboxing.items = items

	net.Start("InitSpin")
		net.WriteTable(items)
	net.Send(self)

end



net.Receive("BuyKey" , function(len , ply)

	if UnboxingConfig.UsePointInsteadOfCash then

		if ply:PS_HasPoints(UnboxingConfig.KeyPrice) then
			
			ply:PS_TakePoints(UnboxingConfig.KeyPrice)

			ply:AddKeys(1)

		end

	else

		if ply:canAfford(UnboxingConfig.KeyPrice) then
			
			ply:addMoney(UnboxingConfig.KeyPrice * -1)

			ply:AddKeys(1)

		end


	end


end)

net.Receive("BuyCrate" , function(len , ply)

	if UnboxingConfig.UsePointInsteadOfCash then

		if ply:PS_HasPoints(UnboxingConfig.CratePrice) then
			
			ply:PS_TakePoints(UnboxingConfig.CratePrice)

			ply:AddCrates(1)

		end

	else

		if ply:canAfford(UnboxingConfig.CratePrice) then
			
			ply:addMoney(UnboxingConfig.CratePrice * -1)

			ply:AddCrates(1)

		end


	end


end)


hook.Add("PlayerInitialSpawn" , "SetUpKeysAndCrates" , function(ply)

 	ply:box_initPlayer()

end)

local CheckTimer = 0

hook.Add("Think" , "GivePlayersKeyAndCrates" , function()

	if CurTime() > CheckTimer then
		
		CheckTimer = CurTime() + 4

		for k , v in pairs(player.GetAll()) do
			
			if UnboxingConfig.ShouldGiveRandomCrates and  v.CrateTimer < CurTime() then
				
				v.CrateTimer = CurTime() + (UnboxingConfig.CrateTimer * 60)

				v:AddCrates(1)
				v:ChatPrint("You have received 1 free crate!")

			end

			if UnboxingConfig.ShouldGiveRandomKeys and v.KeyTimer < CurTime() then
				
				v.KeyTimer = CurTime() + (UnboxingConfig.KeyTimer * 60)

				v:AddKeys(1)
				v:ChatPrint("You have received 1 free key!")

			end


		end

	end


end)

--For admin to give keys and crates to players


hook.Add("PlayerSay" , "GiveStuff:)" , function(ply , text)

	--First we will check if the player is admin

	local isRank = false
 
	for k , v in pairs(UnboxingConfig.GroupsThatCanGiveKeysAndCrates) do
		
		if ply:GetUserGroup() == v then
			
			isRank = true

		end

	end

	if isRank then
	
			local data = string.Explode( " " , text , false)

			if string.lower(data[1]) == "!givekeys" then
				
				local amount = tonumber(data[2])

				if amount ~= nil then
					
					local trace = ply:GetEyeTrace()

					local ent = trace.Entity

					if ent:IsPlayer() then
						
						ent:AddKeys(amount)
						ent:SendHint("An admin gave you "..amount.." keys." , 0)

						ply:ChatPrint("Gave "..amount.." keys to player ("..ent:Nick()..")")

					end

				else

					ply:ChatPrint("Incorrect usage! Please user !givekeys <amount> while looking at a player.")

				end

			end

			if string.lower(data[1]) == "!givecrates" then
				
				local amount = tonumber(data[2])

				if amount ~= nil then
					
					local trace = ply:GetEyeTrace()

					local ent = trace.Entity

					if ent:IsPlayer() then
						
						ent:AddCrates(amount)
						ent:SendHint("An admin gave you "..amount.." crates." , 0)

						ply:ChatPrint("Gave "..amount.." crates to player ("..ent:Nick()..")")

					end

				else

					ply:ChatPrint("Incorrect usage! Please user !givecrates <amount> while looking at a player.")

				end

			end

	end


end)




resource.AddSingleFile( "sound/unboxing/next_item.wav" )
resource.AddSingleFile( "sound/unboxing/next_item.wav" )
resource.AddSingleFile( "sound/unboxing/next_item1.wav" )
resource.AddSingleFile( "sound/unboxing/next_item1.wav" )
resource.AddSingleFile( "resource/fonts/Nexa Bold.ttf" )
resource.AddSingleFile( "materials/unboxing/glass.png" )
resource.AddSingleFile( "materials/unboxing/glass_2.png" )
resource.AddSingleFile( "materials/unboxing/icon_crate.png" )
resource.AddSingleFile( "materials/unboxing/icon_key.png" )
resource.AddSingleFile( "materials/unboxing/icon_padlock.png" )
resource.AddSingleFile( "materials/unboxing/points.png" )
resource.AddSingleFile( "materials/unboxing/trail.png" )

