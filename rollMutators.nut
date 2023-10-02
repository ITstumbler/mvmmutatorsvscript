foreach(a,b in Constants){foreach(k,v in b){if(!(k in getroottable())){getroottable()[k]<-v;}}} //takes all constant keyvals and puts them in global

::mutators <- {} //namespace for easier dumping later

mutators.maxPlayers <- MaxClients().tointeger()
mutators.objResource <- Entities.FindByClassname(null, "tf_objective_resource")
mutators.players <- {}

//way to force bots to taunt by ficool
mutators.tauntSandvich <- Entities.CreateByClassname("tf_weapon_lunchbox")
NetProps.SetPropInt(mutators.tauntSandvich, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", 42)
NetProps.SetPropBool(mutators.tauntSandvich, "m_AttributeManager.m_Item.m_bInitialized", true)
mutators.tauntSandvich.DispatchSpawn()

//maybe rename
mutators.genericMutators <- ["aggressiveMercs", "healthyFighters", "agileLegionaires", "stockedUp", "bloodlust", "heavyBomb", "antisupport", 
	"americanHealthcare", "regenerativeFactor", "guerillaWarfare", "critWeakness", "energySaving", "hatchGuard", "juggernaut",
		"ourBenefactors", "allOrNothing", "offensiveFocus", "allOutOffense", "acceleratedDevelopment", "terrifyingTitans", 
		"rushdown", "deathWatch", "reinforcedMedics", "deepWounds", "protectTheCarrier", "septicTank", "tripleTrouble", "inflammableSkin"]

mutators.meleeMutators <- ["honorboost", "robotsOfSteel"]

mutators.statusMutators <- ["sharpenedSteel", "purifyingEmblem"]

mutators.healthMutators <- ["dwarfism", "armoredGiants", "steelPlating", "magicCoating", "superGiants"]

mutators.regenMutators <- ["divineSeal", "selfRepair"]

mutators.tankMutators <- ["extraLoad", "hyperTanks"]

mutators.spawnMutators <- ["sabotagedCircuits", "forcefulHeadstart"]

//Retribution retired for the time being
//::deathMutators <- ["retribution", "lastWhirr"]
mutators.deathMutators <- ["lastWhirr"]

mutators.classMutators <- ["marathon", "freedomania", "inferno", "pandemonium", "ironCurtain", "texasRangers", "germanTechnology",
	"australiaRules", "chateauBackstab"]
	
mutators.mutatorCategories <- [mutators.genericMutators, mutators.meleeMutators, mutators.statusMutators,
	mutators.healthMutators, mutators.regenMutators, mutators.tankMutators, mutators.spawnMutators,
	mutators.classMutators]

//this could maybe be an enum
mutators.descriptions <- {
	"aggressiveMercs": {description = "\x0700de5cAggressive Mercs\x07FBECCB: \x0747f08dPlayers deal 1.25x damage", points = -3000}
	"healthyFighters": {description = "\x0700de5cHealthy Fighters\x07FBECCB: \x0747f08dPlayers gain +75 max health", points = -3000}
	"agileLegionaires": {description = "\x0700de5cAgile Legionaires\x07FBECCB: \x0747f08dPlayers gain a speed boost", points = -1500}
	"stockedUp": {description = "\x0700de5cStocked Up\x07FBECCB: \x0747f08dPlayers gain 3x ammo capacity", points = -1000}
	"bloodlust": {description = "\x0700de5cBloodlust\x07FBECCB: \x0747f08dPlayers gain 1 second of critical hits on kill", points = -2000}
	"honorboost": {description = "\x0700de5cHonorboost\x07FBECCB: \x0747f08dPlayers deal 1.5x fire and melee damage", points = -1500}
	"heavyBomb": {description = "\x0700de5cHeavy Bomb\x07FBECCB: \x0747f08dBomb carriers move 20% slower", points = -1250}
	"antisupport": {description = "\x0700de5cAntisupport\x07FBECCB: \x0747f08dSniper and Spy Robots move 30% slower and deal 30% less damage", points = -1500}
	//"americanHealthcare": {description = "\x0700de5cAmerican Healthcare: Medicbots drop an additional $50 on death", points = -2500}
	"sharpenedSteel": {description = "\x0700de5cSharpened Steel\x07FBECCB: \x0747f08dAll player weapons bleed robots on hit", points = -1000}
	"regenerativeFactor": {description = "\x0700de5cRegenerative Factor\x07FBECCB: \x0747f08dPlayers gain 4 health regen", points = -1750}
	"guerillaWarfare": {description = "\x0700de5cGuerilla Warfare\x07FBECCB: \x0747f08dPlayers are cloaked. Cloak is removed for 5 seconds upon firing a weapon", points = -2500}
	"dwarfism": {description = "\x0700de5cDwarfism\x07FBECCB: \x0747f08dNon-boss giant robots have 25% less health", points = -2000}
	"extraLoad": {description = "\x0700de5cExtra Load\x07FBECCB: \x0747f08dTanks move 25% slower", points = -1500}
	"critWeakness": {description = "\x0700de5cCrit Weakness\x07FBECCB: \x0747f08dNon-tank robots take 1.5x damage from crits", points = -2500}
	"energySaving": {description = "\x0700de5cEnergy Saving\x07FBECCB: \x0747f08dNon-tank robots move 10% slower", points = -1500}
	"hatchGuard": {description = "\x0700de5cHatch Guard\x07FBECCB: \x0747f08d4 friendly mini-sentries help protect hatch", points = -1750}
	"juggernaut": {description = "\x0700de5cJuggernaut\x07FBECCB: \x0747f08dPlayers gain Reflect powerup. Players do not gain its max health increase", points = -2000}
	"ourBenefactors": {description = "\x0700de5cOur Benefactors\x07FBECCB: \x0747f08dStart with an additional $800", points = -3000}
	"sabotagedCircuits": {description = "\x0700de5cSabotaged Circuits\x07FBECCB: \x0747f08dRobots are stunned for 1 second upon exiting spawn", points = -1500}
	"marathon": {description = "\x07f3f705Marathon\x07FBECCB: \x07fcff65Scout players and robots gain 1.5x damage and +50 max health", points = 0}
	"freedomania": {description = "\x07f3f705Freedomania\x07FBECCB: \x07fcff65Soldier players and robots gain 35% faster firing/reload speed", points = 0}
	"inferno": {description = "\x07f3f705Inferno\x07FBECCB: \x07fcff65Pyro players and robots gain extra flamethrower range and 1.5x damage", points = 0}
	"pandemonium": {description = "\x07f3f705Pandemonium\x07FBECCB: \x07fcff65Demoman players and robots gain 60% faster reload speed and 1.5x melee damage", points = 0}
	"ironCurtain": {description = "\x07f3f705Iron Curtain\x07FBECCB: \x07fcff65Heavy players and robots gain +200 max health and knockback immunity", points = 0}
	"texasRangers": {description = "\x07f3f705Texas Rangers\x07FBECCB: \x07fcff65Engineer players and robots gain 2x building health and upgrade rate", points = 0}
	"germanTechnology": {description = "\x07f3f705German Technology\x07FBECCB: \x07fcff65Medic players and robots gain 1.5x uber rate and +4s uber duration", points = 0}
	"australiaRules": {description = "\x07f3f705Australia Rules\x07FBECCB: \x07fcff65Sniper players and robots gain 1.5x damage", points = 0}
	"chateauBackstab": {description = "\x07f3f705Chateau Backstab\x07FBECCB: \x07fcff65Spy players and robots gain 65% damage resistance and 30% faster attack speed", points = 0}
	"armoredGiants": {description = "\x07f3f705Armored Giants\x07FBECCB: \x07fcff65Non-boss giant robots gain +30% max health and move 20% slower", points = 0}
	"allOrNothing": {description = "\x07f3f705All or Nothing\x07FBECCB: \x07fcff65Robots drop twice as much credits, but players pay $400 per death", points = 0}
	"offensiveFocus": {description = "\x07f3f705Offensive Focus\x07FBECCB: \x07fcff65Players and robots do 1.25x damage", points = 0}
	"robotsOfSteel": {description = "\x07f3f705Robots of Steel\x07FBECCB: \x07fcff65Robots take 40% less damage from ranged sources but 100% more damage from melee", points = 0}
	"steelPlating": {description = "\x07f70505Steel Plating\x07FBECCB: \x07ff4d4dRobots gain +50 max health", points = 1750}
	"magicCoating": {description = "\x07f70505Magic Coating\x07FBECCB: \x07ff4d4dNon-boss robots gain +25% max health", points = 2500}
	"divineSeal": {description = "\x07f70505Divine Seal\x07FBECCB: \x07ff4d4dNon-boss robots recover all health when not damaged for 5 seconds", points = 2000}
	"allOutOffense": {description = "\x07f70505All-Out Offense\x07FBECCB: \x07ff4d4dRobots gain crits and -50% max health. Robots with innate crits gain 2x damage instead", points = 1000}
	"acceleratedDevelopment": {description = "\x07f70505Accelerated Development\x07FBECCB: \x07ff4d4dRobots gain bomb buffs very quickly. Giants can also get bomb buffs", points = 3000}
	"lastWhirr": {description = "\x07f70505Last Whirr\x07FBECCB: \x07ff4d4dRobots explode on death, dealing 25 damage to all nearby players", points = 2500}
	"forcefulHeadstart": {description = "\x07f70505Forceful Headstart\x07FBECCB: \x07ff4d4dRobots gain 3 seconds of uber upon exiting spawn", points = 1500}
	"selfRepair": {description = "\x07f70505Self-Repair\x07FBECCB: \x07ff4d4dRobots gain 25 health regen", points = 1500}
	"terrifyingTitans": {description = "\x07f70505Terrifying Titans\x07FBECCB: \x07ff4d4dGiant robots deal 1.25x damage", points = 2250}
	"rushdown": {description = "\x07f70505Rushdown\x07FBECCB: \x07ff4d4dAll small robots are permanently boosted by Concheror effects", points = 3000}
	"deathWatch": {description = "\x07f70505Death Watch\x07FBECCB: \x07ff4d4dPlayers lose 5 health per second", points = 2500}
	"hyperTanks": {description = "\x07f70505Hyper Tanks\x07FBECCB: \x07ff4d4dTanks move +33% faster", points = 1500}
	"superGiants": {description = "\x07f70505Super Giants\x07FBECCB: \x07ff4d4dNon-boss giant robots gain +50% max health", points = 3000}
	"reinforcedMedics": {description = "\x07f70505Reinforced Medics\x07FBECCB: \x07ff4d4dMedic robots activate uber earlier and have 2x max health", points = 2000}
	"deepWounds": {description = "\x07f70505Deep Wounds\x07FBECCB: \x07ff4d4dAll player healing is 50% less effective", points = 2500}
	"protectTheCarrier": {description = "\x07f70505Protect the Carrier\x07FBECCB: \x07ff4d4dBomb carriers gain King powerup", points = 1000}
	"septicTank": {description = "\x07f70505Septic Tank\x07FBECCB: \x07ff4d4dTanks jarate and set nearby players on fire upon destruction", points = 500}
	"tripleTrouble": {description = "\x07f70505Triple Trouble\x07FBECCB: \x07ff4d4dRobots gain two additional bombs", points = 1000}
	"inflammableSkin": {description = "\x07f70505Inflammable Skin\x07FBECCB: \x07ff4d4dBurning players are Marked for Death", points = 1000}
	"purifyingEmblem": {description = "\x07f70505Purifying Emblem\x07FBECCB: \x07ff4d4dRobots are immune to all status effects", points = 2500}
}

//list of params for various mutators
mutators.mutatorParams <- {
	septicTank_radius = 0
	acceleratedDevelopment_multiplier = 0.5
	sabotagedCircuits_duration = 1
	forcefulHeadstart_duration = 3
	//septicTankRadius = 0
	//acceleratedDevelopmentMultiplier = 0.5
	allOrNothingPenalty = 400
	totalAllOrNothingCurrency = 0
	waveAllOrNothingCurrency = 0
	lastWhirrRadius = 146
	lastWhirrDmg = 25
	lastWhirrReductionDistance = 2.88 //for rockets, splash dmg goes down by 1% for every 2.88hu of distance
}

mutators.convarsToReset <- { //unsurprisingly these persist through rounds
	"tf_mvm_bot_flag_carrier_interval_to_1st_upgrade": Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade")
	"tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade": Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade")
	"tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade": Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade")
}

mutators.activeMutators <- []

IncludeScript("mvmmutatorsvscript/commonListeners.nut")
IncludeScript("mvmmutatorsvscript/nonPlayerMutatorFunctions.nut")

function mutators::initPlayer(player) {
	player.ValidateScriptScope()
	local scope = player.GetScriptScope()
	
	IncludeScript("mvmmutatorsvscript/playerMutatorFunctions.nut", scope)
}

function mutators::rollMutators(mutator1 = null, mutator2 = null, mutator3 = null) {
	local choiceArray = []
	choiceArray.extend(mutatorCategories)
	activeMutators = []
	
	for(local i = 1; i <= maxPlayers; i++) {
		local player = PlayerInstanceFromIndex(i)
		if(player == null) continue
		//if(IsPlayerABot(player)) continue
		//may need to change this depending on mutators
		
		if(!IsPlayerABot(player)) {
			players[i] <- player
			
			initPlayer(player)
		}
		else {
			player.ValidateScriptScope()
			local scope = player.GetScriptScope()
	
			IncludeScript("mvmmutatorsvscript/botMutatorFunctions.nut", scope)
		}
	}
	
	if(mutator1 != null) { //force mutators
		activeMutators.append(mutator1)
		if(mutator2 != null) {
			activeMutators.append(mutator2)
		}
		if(mutator3 != null) {
			activeMutators.append(mutator3)
		}
	}
	else { //roll mutators
		for(local i = 0; i < RandomInt(1, 3); i++) {
			local arrayVal = RandomInt(0, choiceArray.len() - 1)
			local mutatorArray = choiceArray[arrayVal]
			local mutator = mutatorArray[RandomInt(0, mutatorArray.len() - 1)]
			
			while(mutator in activeMutators) { //keep rerolling till we get a new one for generic mutators
				mutator = mutatorArray[RandomInt(0, mutatorArray.len() - 1)]
			}
			activeMutators.append(mutator)
			
			if(arrayVal != 0) { //if a nongeneric mutator, remove
				choiceArray.remove(arrayVal)
			}
		}
	}
	
	ClientPrint(null, 3, "The mission's mutators are:")
	foreach(mutator in activeMutators) {
		ClientPrint(null, 3, descriptions[mutator].description)
	}
	
	for (local i = 1; i <= maxPlayers ; i++) {
		local player = PlayerInstanceFromIndex(i)
		if(player == null) continue
		//if(IsPlayerABot(player)) continue
		
		local scope = player.GetScriptScope()
		
		foreach(mutator in activeMutators) {
			if(mutator in scope) {
				scope.thinkFunctions[mutator] <- scope[mutator] //string, function 
			}
		}
		AddThinkToEnt(player, "think")
	}
	//to do: need to run one time non player functions somehow (make a specific array of them?)
}

//reset to default, dump everything
function mutators::cleanup() {


}