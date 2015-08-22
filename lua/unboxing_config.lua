--THIS NOW HAS POINTSHOP SUPPORT (PS1)
--BE SURE TO READ THE CONFIG AGAIN TO KNOW TO USE IT WITH POINTSHOP
--ALSO IF YOU ARE NTO USING POINTSHOP THEN MAKE SURE YOU REMOVE THE POINTSHOP EXAMPLES

include("unboxing_subconfig.lua")

--THE CONFIG BEGINS HERE! 

UnboxingConfig.UsePointInsteadOfCash  = false --If this is true, Then user will pay with pointshop points rather than DarkRP cash

UnboxingConfig.KeyPrice = 5
UnboxingConfig.CratePrice = 5

UnboxingConfig.ShouldGiveRandomCrates = true --Should it give the user a free crate every X amount of time.
UnboxingConfig.CrateTimer = 15 --This is how often it will give them a free crate if the above is set to true. (This is in minutes)

UnboxingConfig.ShouldGiveRandomKeys = false --Same except for keys, I Would recommend this being off.
UnboxingConfig.KeyTimer = 60 --This is how often it will give them a free crate if the above is set to true. (This is in minutes)

UnboxingConfig.GroupsThatCanGiveKeysAndCrates = { --This is the groups that have permission to give free keys and crates to user (Including them selfs)
	"Owner",
	"superadmin",
	"Super Admin",
	"Other Groups like so..."
}

--Here is where you add items.
--To add an items they go as follows

--addWeaponItem(itemName , weaponName, itemModel, itemChance, itemColor)
--addEntityItem(itemName , entityName, itemModel, itemChance, itemColor)
--addMoneyItem(itemName , amount , itemChance , itemColor)
--addHealthItem(itemName , amount , itemChance , itemColor)
--addPointShopPoints(itemName , pointAmount , itemChance, itemColor)
--addPointShopItem(itemName , itemClassName , itemModel, itemChance, itemColor)
--addPointShopTrail(itemName , trailClassName, itemChance, itemColor)

--Just use these below (See example)



addPointShopPoints("100 Points" , 100 , 1300, Color(255,211,73))
addPointShopItem("Cone Hat!" , "conehat", "models/props_c17/FurnitureWashingmachine001a.mdl", 8000, Color(192,70 , 130))
addPointShopTrail("TRAIL" , "smoke", 50000, Color(192,70 , 130))



addEntityItem("MONEY PRINTER" , "money_printer" , "models/props_c17/consolebox01a.mdl" , 800, Color(192,70 , 130))


addHealthItem("50% HEAL" , 50 , 700 , Color(43,90,240))
addHealthItem("100% HEAL" , 100 , 550, Color(43,90,240))

addWeaponItem("RPG" , "weapon_rpg", "models/weapons/w_rocket_launcher.mdl", 600,Color(192,70 , 130))

addMoneyItem("100 DOLLARS" , 100 , 1000, Color(43,90,240))
addMoneyItem("500 DOLLARS" , 500 , 800,Color(43,90,240))
addMoneyItem("5000 DOLLARS" , 5000 ,  600,Color(192,70 , 130))
addMoneyItem("25000 DOLLARS" , 25000 , 400,Color(192,70 , 130))
addMoneyItem("250000 DOLLARS" , 250000 , 12,Color(255,60,60))
addMoneyItem("500000 DOLLARS" , 500000 , 7,Color(255,60,60))
addMoneyItem("1000000 DOLLARS" , 1000000 , 2,Color(255,211,73))

--IF YOU NEED ANY MORE HELP THEN FEEL FREE TO CONTACT ME ON STEAM OR OPEN A SUPPORT TICKET

--[[

   ***     ***                   ***     ***                   ***     ***
 **   ** **   **               **   ** **   **               **   ** **   **
*       *       *             *       *       *             *       *       *
*               *             *               *             *               *
 *     LOVE    *               *     LOVE    *               *     LOVE    *
  **         **   ***     ***   **         **   ***     ***   **         **
    **     **   **   ** **   **   **     **   **   ** **   **   **     **
      ** **    *       *       *    ** **    *       *       *    ** **
        *      *               *      *      *               *      *
                *     LOVE    *               *     LOVE    *
   ***     ***   **         **   ***     ***   **         **   ***     ***
 **   ** **   **   **     **   **   ** **   **   **     **   **   ** **   **
*       *       *    ** **    *       *       *    ** **    *       *       *
*               *      *      *               *      *      *               *
 *     LOVE    *               *     LOVE    *               *     LOVE    *
  **         **   ***     ***   **         **   ***     ***   **         **
    **     **   **   ** **   **   **     **   **   ** **   **   **     **
      ** **    *       *       *    ** **    *       *       *    ** **
        *      *               *      *      *               *      *
                *     LOVE    *               *     LOVE    *
                 **         **                 **         **
                   **     **                     **     **
                     ** **                         ** **
                       *                             *


]]--