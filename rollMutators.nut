if("mutators" in getroottable()) {
	return
}

foreach(a,b in Constants){foreach(k,v in b){if(!(k in getroottable())){getroottable()[k]<-v;}}} //takes all constant keyvals and puts them in global

::mutators <- {} //namespace for easier dumping later

mutators.maxPlayers <- MaxClients().tointeger()
mutators.objResource <- Entities.FindByClassname(null, "tf_objective_resource")
mutators.players <- {}
mutators.waveFailed <- false
mutators.buttonReset <- false
mutators.doorOpen <- false
mutators.playersOpeningDoor <- 0

// if(mutators.waveFailed) {
// 	mutators.waveFailed = false
// 	return
// }

//maybe rename
mutators.genericMutators <- ["aggressiveMercs", "healthyFighters", "agileLegionnaires", "stockedUp", "bloodlust", "heavyBomb", "antisupport",
	"regenerativeFactor", "guerillaWarfare", "critWeakness", "energySaving", "hatchGuard", "juggernaut",
	"ourBenefactors", "allOrNothing", "offensiveFocus", "allOutOffense", "acceleratedDevelopment", "terrifyingTitans",
	"rushdown", "deathWatch", "reinforcedMedics", "deepWounds", "protectTheCarrier", "septicTank", "tripleTrouble", "inflammableSkin"]
//"americanHealthcare",

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
	"australianRules", "chateauBackstab"]

mutators.mutatorCategories <- [mutators.genericMutators, mutators.meleeMutators, mutators.statusMutators,
	mutators.healthMutators, mutators.regenMutators, mutators.tankMutators, mutators.spawnMutators,
	mutators.classMutators]

//this could maybe be an enum
mutators.descriptions <- {
	"aggressiveMercs": {description = "\x0700de5cAggressive Mercs\x07FBECCB: \x0747f08dPlayers deal 1.25x damage", points = -3000}
	"healthyFighters": {description = "\x0700de5cHealthy Fighters\x07FBECCB: \x0747f08dPlayers gain +75 max health", points = -3000}
	"agileLegionnaires": {description = "\x0700de5cAgile Legionaires\x07FBECCB: \x0747f08dPlayers gain a speed boost", points = -1500}
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
	"juggernaut": {description = "\x0700de5cJuggernaut\x07FBECCB: \x0747f08dPlayers gain bonus damage with every kill. Bonus damage is lost on death", points = -3000}
	"ourBenefactors": {description = "\x0700de5cOur Benefactors\x07FBECCB: \x0747f08dStart with an additional $800", points = -3000}
	"sabotagedCircuits": {description = "\x0700de5cSabotaged Circuits\x07FBECCB: \x0747f08dRobots are stunned for 1 second upon exiting spawn", points = -1500}
	"marathon": {description = "\x07f3f705Marathon\x07FBECCB: \x07fcff65Scout players and robots gain 1.5x damage and +50 max health", points = 0}
	"freedomania": {description = "\x07f3f705Freedomania\x07FBECCB: \x07fcff65Soldier players and robots gain 35% faster firing/reload speed", points = 0}
	"inferno": {description = "\x07f3f705Inferno\x07FBECCB: \x07fcff65Pyro players and robots gain extra flamethrower range and 1.5x damage", points = 0}
	"pandemonium": {description = "\x07f3f705Pandemonium\x07FBECCB: \x07fcff65Demoman players and robots gain 60% faster reload speed and 1.5x melee damage", points = 0}
	"ironCurtain": {description = "\x07f3f705Iron Curtain\x07FBECCB: \x07fcff65Heavy players and robots gain +200 max health and knockback immunity", points = 0}
	"texasRangers": {description = "\x07f3f705Texas Rangers\x07FBECCB: \x07fcff65Engineer players and robots gain 1.5x building health and 1.25x sentry damage", points = 0}
	"germanTechnology": {description = "\x07f3f705German Technology\x07FBECCB: \x07fcff65Medic players and robots gain 1.5x uber rate and +4s uber duration", points = 0}
	"australianRules": {description = "\x07f3f705Australia Rules\x07FBECCB: \x07fcff65Sniper players and robots gain 1.5x damage", points = 0}
	"chateauBackstab": {description = "\x07f3f705Chateau Backstab\x07FBECCB: \x07fcff65Spy players and robots gain 65% damage resistance and 30% faster attack speed", points = 0}
	"armoredGiants": {description = "\x07f3f705Armored Giants\x07FBECCB: \x07fcff65Non-boss giant robots gain +30% max health and move 20% slower", points = 0}
	"allOrNothing": {description = "\x07f3f705All or Nothing\x07FBECCB: \x07fcff65Robots drop twice as much credits, but players pay $400 per death", points = 0}
	"offensiveFocus": {description = "\x07f3f705Offensive Focus\x07FBECCB: \x07fcff65Players and robots do 1.25x damage", points = 0}
	"robotsOfSteel": {description = "\x07f3f705Robots of Steel\x07FBECCB: \x07fcff65Robots take 40% less damage from ranged sources but 100% more damage from melee", points = 0}
	"steelPlating": {description = "\x07f70505Steel Plating\x07FBECCB: \x07ff4d4dRobots gain +100 max health", points = 2250}
	"magicCoating": {description = "\x07f70505Magic Coating\x07FBECCB: \x07ff4d4dNon-boss robots gain +25% max health", points = 2500}
	"divineSeal": {description = "\x07f70505Divine Seal\x07FBECCB: \x07ff4d4dNon-boss robots recover all health when not damaged for 5 seconds", points = 2500}
	"allOutOffense": {description = "\x07f70505All-Out Offense\x07FBECCB: \x07ff4d4dRobots gain crits and -50% max health. Robots with innate crits gain 2x damage instead", points = 1000}
	"acceleratedDevelopment": {description = "\x07f70505Accelerated Development\x07FBECCB: \x07ff4d4dRobots gain bomb buffs very quickly. Giants can also get bomb buffs", points = 3000}
	"lastWhirr": {description = "\x07f70505Last Whirr\x07FBECCB: \x07ff4d4dRobots explode on death, dealing damage to all nearby players", points = 2500}
	"forcefulHeadstart": {description = "\x07f70505Forceful Headstart\x07FBECCB: \x07ff4d4dRobots gain 3 seconds of uber upon exiting spawn", points = 1500}
	"selfRepair": {description = "\x07f70505Self-Repair\x07FBECCB: \x07ff4d4dRobots gain 25 health regen", points = 1500}
	"terrifyingTitans": {description = "\x07f70505Terrifying Titans\x07FBECCB: \x07ff4d4dGiant robots deal 1.25x damage", points = 2250}
	"rushdown": {description = "\x07f70505Rushdown\x07FBECCB: \x07ff4d4dAll small robots are permanently boosted by Concheror effects", points = 3000}
	"deathWatch": {description = "\x07f70505Death Watch\x07FBECCB: \x07ff4d4dPlayers lose 5 health per second", points = 2500}
	"hyperTanks": {description = "\x07f70505Hyper Tanks\x07FBECCB: \x07ff4d4dTanks move +33% faster", points = 1500}
	"superGiants": {description = "\x07f70505Super Giants\x07FBECCB: \x07ff4d4dNon-boss giant robots gain +50% max health", points = 3000}
	"reinforcedMedics": {description = "\x07f70505Reinforced Medics\x07FBECCB: \x07ff4d4dMedic robots activate uber earlier and have 2x max health", points = 2000}
	"deepWounds": {description = "\x07f70505Deep Wounds\x07FBECCB: \x07ff4d4dAll player healing is 50% less effective", points = 2500}
	"protectTheCarrier": {description = "\x07f70505Protect the Carrier\x07FBECCB: \x07ff4d4dBomb carriers and robots near it receive significant damage protection and healing", points = 3000}
	"septicTank": {description = "\x07f70505Septic Tank\x07FBECCB: \x07ff4d4dTanks jarate and set nearby players on fire upon destruction", points = 500}
	"tripleTrouble": {description = "\x07f70505Triple Trouble\x07FBECCB: \x07ff4d4dRobots gain two additional bombs", points = 1000}
	"inflammableSkin": {description = "\x07f70505Inflammable Skin\x07FBECCB: \x07ff4d4dBurning players are Marked for Death", points = 1000}
	"purifyingEmblem": {description = "\x07f70505Purifying Emblem\x07FBECCB: \x07ff4d4dRobots are immune to all status effects", points = 2500}
}

//list of params for various mutators
mutators.mutatorParams <- {
	aggressiveMercs_damageMultiplier 	= 1.25
	healthyFighters_extraHealth			= 75
	agileLegionnaires_speedMultiplier	= 1.2
	stockedUp_ammoMultiplier			= 3
	bloostlust_critOnKillDuration		= 1
	honorboost_damageMultiplier			= 1.5
	antisupport_damageMultiplier		= 0.7
	antisupport_speedMultiplier			= 0.7
	sharpenedSteel_bleedDuration		= 5
	regenerativeFactor_healthRegen		= 4
	dwarfism_healthMultiplier			= 0.75
	critWeakness_critDamageMultiplier	= 1.5
	energySaving_speedMultiplier		= 0.9
	heavyBomb_speedMultiplier			= 0.8
	extraLoad_speedMultiplier			= 0.75
	juggernaut_damageMultiplierPerKill	= 0.005
	juggernaut_killCap					= 200
	ourBenefactors_bonusMoney			= 800
	offensiveFocus_damageMultiplier		= 1.25
	robotsOfSteel_rangedDmgMultiplier	= 0.6
	robotsOfSteel_meleeDmgMultiplier	= 2
	marathon_damageMultiplier			= 1.5
	marathon_extraHealth				= 50
	freedomania_fireRateMultiplier		= 0.65
	freedomania_reloadSpeedMultiplier	= 0.65
	inferno_damageMultiplier			= 1.5
	inferno_flameDrag					= -2.5
	pandemonium_reloadSpeedMultiplier	= 0.4
	pandemonium_meleeDamageMultiplier	= 1.5
	ironCurtain_knockbackMultiplier		= 0.01
	ironCurtain_extraHealth				= 200
	texasRangers_buildingHpMultiplier	= 1.5
	texasRangers_sentryDamageMultiplier	= 1.25
	germanTechnology_uberRateMultiplier	= 1.5
	germanTechnology_extraUberDuration	= 4
	australianRules_damageMultiplier	= 1.5
	chateauBackstab_dmgTakenMultiplier	= 0.35
	chateauBackstab_fireRateMultiplier	= 0.7
	armoredGiants_healthMultiplier		= 1.3
	armoredGiants_speedMultiplier		= 0.8
	steelPlating_extraHealth			= 100
	magicCoating_healthMultiplier		= 1.25
	selfRepair_healthRegen				= 25
	terrifyingTitans_damageMultiplier	= 1.25
	rushdown_conditionNumber			= 29
	deathWatch_healthDrain				= -5
	superGiants_healthMultiplier		= 1.5
	deepWounds_healingMultiplier		= 0.5
	allOutOffense_healthMultiplier		= 0.5
	allOutOffense_damageMultiplier		= 2
	hatchGuard_miniSentry_1_origin 		= Vector(-131,115,72)
	hatchGuard_miniSentry_2_origin 		= Vector(131,115,72)
	hatchGuard_miniSentry_3_origin 		= Vector(-131,-149,72)
	hatchGuard_miniSentry_4_origin 		= Vector(131,-149,72)
	hatchGuard_miniSentry_1_angles	 	= "0 315 0"
	hatchGuard_miniSentry_2_angles	 	= "0 225 0"
	hatchGuard_miniSentry_3_angles 		= "0 315 0"
	hatchGuard_miniSentry_4_angles 		= "0 225 0"
	reinforcedMedics_healthMultiplier	= 2
	reinforcedMedics_giantUberDeploy	= 75
	divineSeal_minimumHealth			= 500
	divineSeal_healingDuration			= 5
	divineSeal_particleDisplayDelay		= 1.5
	guerillaWarfare_delay				= 5
	septicTank_radius 					= 512
	hyperTanks_speedMultiplier			= 1.333
	acceleratedDevelopment_multiplier 	= 0.5
	sabotagedCircuits_duration			= 1
	forcefulHeadstart_duration 			= 3
	//V Multiply by 50 to get radius, cba with floats and integers V
	protectTheCarrier_modelScale		= 2.56
	protectTheCarrier_radius			= 128
	protectTheCarrier_dmgReduction		= 0.6
	protectTheCarrier_healthRegen		= 25
	inflammableSkin_condition			= 30
	//septicTank_radius 					= 0
	//acceleratedDevelopment_multiplier 	= 0.5
	allOrNothing_penalty 				= 400
	allOrNothing_totalCurrency 			= 0
	allOrNothing_waveCurrency 			= 0
	lastWhirr_radius 					= 146
	lastWhirr_dmg 						= 30
	lastWhirr_reductionDistance 		= 2.88 //for rockets, splash dmg goes down by 1% for every 2.88hu of distance
	//Constant conditions display a continuous minor particle effect when players try to inflict them
	//Afterburn is separate because afterburn sucks
	//Big conditions display a big flashy cleansing particle when players try to inflict them
	//Stun (condition 15) should be here but it doesn't work lma
	purifyingEmblem_noParticlesConds	= [118] //Flamethrower healing debuff
	purifyingEmblem_constantConds		= [15, 22, 25] //stun, burning, bleeding
	purifyingEmblem_bigConds			= [24, 27, 30, 50, 123] //Jarate'd, milked, marked-for-death, sapped, gas passer
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

function mutators::initMutators(mutator1 = null, mutator2 = null, mutator3 = null) {
	for(local i = 1; i <= maxPlayers; i++) {
		local player = PlayerInstanceFromIndex(i)
		if(player == null) continue

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

	rollMutators(mutator1, mutator2, mutator3)
}

function mutators::rollMutators(mutator1 = null, mutator2 = null, mutator3 = null, score = null, beEasier = false) {
	local mutatorsMapped = {}
	local choiceArray = []
	foreach(category in mutatorCategories) {
		foreach(mutator in category) {
			mutatorsMapped.mutator <- category
			choiceArray.extend(category)
		}
	}
	//choiceArray.extend(mutatorCategories)
	activeMutators = []

	//mutator1 = "acceleratedDevelopment"

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
		local goodSet = false

		while(!goodSet) {
			local usedCategories = []
			local newScore = 0
			
			for(local i = 0; i < RandomInt(1, 3); i++) {
				local mutator = choiceArray[RandomInt(0, choiceArray.len() - 1)]
				
				if(mutatorsMapped.mutator != genericMutators) {
					while(mutatorsMapped.mutator in usedCategories) {
						mutator = choiceArray[RandomInt(0, choiceArray.len() - 1)]
						//could possibly remove stuff to speed up search
					}
				}
				else {
					while(mutator in activeMutators) { //prevent genericmutators doubles
						mutator = genericMutators[RandomInt(0, genericMutators.len() -1)]
					}				
				}
				
				activeMutators.append(mutator)
				usedCategories.append(mutatorsMapped.mutator)
				newScore += descriptions[mutator].points
				//local mutatorArray = choiceArray[arrayVal]
				//local mutator = mutatorArray[RandomInt(0, mutatorArray.len() - 1)]
				
				/*
				while(mutator in activeMutators) { //keep rerolling till we get a new one for generic mutators
					mutator = mutatorArray[RandomInt(0, mutatorArray.len() - 1)]
				}
				activeMutators.append(mutator)

				if(arrayVal != 0) { //if a nongeneric mutator, remove
					choiceArray.remove(arrayVal)
				}
				*/
			}

			if(score != null) {
				if(beEasier && newScore < score) {
					goodSet = true
				}
				else if(!beEasier && newScore > score) {
					goodset = true
				}
			}
			else {
				goodSet = true
			}
		}
	}

	finalizeMutators()
}

function mutators::finalizeMutators() {
	ClientPrint(null, 3, "The mission's mutators are:")
	foreach(mutator in activeMutators) {
		ClientPrint(null, 3, descriptions[mutator].description)
	}

	local playerManager = Entities.FindByClassname(null, "tf_player_manager")
	for(local i = 1; i <= maxPlayers; i++) {
		local player = PlayerInstanceFromIndex(i)
		if(player == null) continue

		local scope = player.GetScriptScope()

		foreach(mutator in activeMutators) {
			if(mutator in scope) {
				scope.thinkFunctions[mutator] <- scope[mutator] //string, function
			}
		}
		AddThinkToEnt(player, "think")

		if(player.GetTeam() != 2) continue

		local spawn = {
			userid = NetProps.GetPropIntArray(playerManager, "m_iUserID", player.GetEntityIndex()),
			team = player.GetTeam(),
			["class"] = player.GetPlayerClass()
		}

		FireGameEvent("player_spawn", spawn)
	}

	foreach(mutator in activeMutators) {
		if(mutator in mutators) {
			mutators[mutator]()
		}
	}
	waveFailed = false
}

//reset to default, dump everything
function mutators::cleanup() {
	foreach(convar, val in convarsToReset) {
		Convars.SetValue(convar, val)
	}
}

function mutators::preButtonFuncsCleanup() {
	for(local i = 1; i <= maxPlayers; i++) {
		local player = PlayerInstanceFromIndex(i)
		if(player == null) continue

		local scope = player.GetScriptScope()

		scope.thinkFunctions = {}
		AddThinkToEnt(player, null)
	}

	//TODO: need to clean up outputs and the like as well
}

function mutators::changeDifficulty(beEasier) {
	local currentScore = 0

	preButtonFuncsCleanup()

	foreach(mutator in activeMutators) {
		currentScore += descriptions[mutator].points
	}

	rollMutators(null, null, null, currentScore, beEasier)
}

function mutators::reRandomize() {
	preButtonFuncsCleanup()
	rollMutators()
}

function mutators::changeSlot(slot) {
	local mutator1 = null
	local mutator2 = null
	local mutator3 = null

	local oldMutator = null

	switch(activeMutators.len()) {
		case 3:
			mutator3 = activeMutators[2]
		case 2:
			mutator2 = activeMutators[1]
		case 1:
			mutator1 = activeMutators[0]
			break
	}
	switch(slot) {
		case 1:
			oldMutator = mutator1
			break;
		case 2:
			oldMutator = mutator2
			break;
		case 3:
			oldMutator = mutator3
			break;
	}

	//remove player sided from scope
	if(oldMutator != null) {
		for(local i = 1; i <= maxPlayers; i++) {
			local player = PlayerInstanceFromIndex(i)
			if(player == null) continue

			local scope = player.GetScriptScope()

			if(oldMutator in scope) {
				delete scope.thinkFunctions[oldMutator]
			}
		}
	}

	local choiceArray = []
	choiceArray.extend(mutatorCategories)

	foreach(category in choiceArray) {
		if(category == genericMutators) continue

		local remove = false

		//this sucks
		if(mutator1 != oldMutator && mutator1 in category) {
			remove = true
		}
		else if(mutator2 != oldMutator && mutator2 in category) {
			remove = true
		}
		else if(mutator3 != oldMutator && mutator3 in category) {
			remove = true
		}

		if(remove) {
			choiceArray.remove(choiceArray.find(category))
		}
	}

	//this is copy pasted from rollMutators, maybe should do something about that
	local arrayVal = RandomInt(0, choiceArray.len() - 1)
	local mutatorArray = choiceArray[arrayVal]
	local mutator = mutatorArray[RandomInt(0, mutatorArray.len() - 1)]

	while(mutator in activeMutators) { //keep rerolling till we get a new one for generic mutators
		mutator = mutatorArray[RandomInt(0, mutatorArray.len() - 1)]
	}
	activeMutators.append(mutator)

	finalizeMutators()
}

function mutators::buttonPress(mutator) {
	if(!buttonReset) {
		preButtonFuncsCleanup()
		activeMutators = []
	}
	buttonReset = true

	if(activeMutators.len() < 3) {

	}


}