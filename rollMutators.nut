//maybe rename
::genericMutators <- ["aggressiveMercs", "healthyFighters", "agileLegionaires", "stockedUp", "bloodlust", "heavyBomb", "antisupport", 
	"americanHealthcare", "regenerativeFactor", "guerillaWarfare", "critWeakness", "energySaving", "hatchGuard", "juggernaut",
		"ourBenefactors", "allOrNothing", "offensiveFocus", "allOutOffense", "acceleratedDevelopment", "terrifyingTitans", 
		"rushdown", "deathWatch", "reinforcedMedics", "deepWounds", "protectTheCarrier", "septicTank", "tripleTrouble", "inflammableSkin"]


::meleeMutators <- ["honorboost", "robotsOfSteel"]

::statusMutators <- ["sharpenedSteel", "purifyingEmblem"]

::healthMutators <- ["dwarfism", "armoredGiants", "steelPlating", "magicCoating", "superGiants"]

::regenMutators <- ["divineSeal", "selfRepair"]

::tankMutators <- ["extraLoad", "hyperTanks"]

::spawnMutators <- ["sabotagedCircuits", "forcefulHeadstart"]

//Retribution retired for the time being
//::deathMutators <- ["retribution", "lastWhirr"]

::classMutators <- ["marathon", "freedomania", "inferno", "pandemonium", "ironCurtain", "texasRangers", "germanTechnology",
	"australiaRules", "chateauBackstab"]
	
::mutatorCategories <- [genericMutators, meleeMutators, statusMutators, healthMutators, regenMutators, tankMutators, spawnMutators,
classMutators]

//this could maybe be an enum
::descriptions <- {
	"aggressiveMercs": "Aggressive Mercs: Players deal 1.25x damage"
	"healthyFighters": "Healthy Fighters: Players gain +75 max health"
	"agileLegionaires": "Agile Legionaires: Players gain a speed boost"
	"stockedUp": "Stocked Up: Players gain 3x ammo capacity"
	"bloodlust": "Bloodlust: Players gain 1 second of critical hits on kill"
	"honorboost": "Honorboost: Players deal 1.5x fire and melee damage"
	"heavyBomb": "Heavy Bomb: Bomb carriers move 20% slower"
	"antisupport": "Antisupport: Sniper and Spy Robots move 30% slower and deal 30% less damage"
	"americanHealthcare": "American Healthcare: Medicbots drop an additional $50 on death"
	"sharpenedSteel": "Sharpened Steel: All player weapons bleed robots on hit"
	"regenerativeFactor": "Regenerative Factor: Players gain 4 health regen"
	"guerillaWarfare": "Guerilla Warfare: Players are cloaked. Cloak is removed for 5 seconds upon firing a weapon"
	"dwarfism": "Dwarfism: Non-boss giant robots have 25% less health"
	"extraLoad": "Extra Load: Tanks move 25% slower"
	"critWeakness": "Crit Weakness: Non-tank robots take 1.5x damage from crits"
	"energySaving": "Energy Saving: Non-tank robots move 10% slower"
	"hatchGuard": "Hatch Guard: 4 friendly mini-sentries help protect hatch"
	"juggernaut": "Juggernaut: Players gain Reflect powerup. Players do not gain its max health increase"
	"ourBenefactors": "Our Benefactors: Start with an additional $800"
	"sabotagedCircuits": "Sabotaged Circuits: Robots are stunned for 1 second upon exiting spawn"
	"marathon": "Marathon: Scout players and robots gain 1.5x damage and +50 max health"
	"freedomania": "Freedomania: Soldier players and robots gain 35% faster firing/reload speed"
	"inferno": "Inferno: Pyro players and robots gain extra flamethrower range and 1.5x damage"
	"pandemonium": "Pandemonium: Demoman players and robots gain 60% faster reload speed and 1.5x melee damage"
	"ironCurtain": "Iron Curtain: Heavy players and robots gain +200 max health and knockback immunity"
	"texasRangers": "Texas Rangers: Engineer players and robots gain 2x building health and upgrade rate"
	"germanTechnology": "German Technology: Medic players and robots gain 1.5x uber rate and +4s uber duration"
	"australiaRules": "Australia Rules: Sniper players and robots gain 1.5x damage"
	"chateauBackstab": "Chateau Backstab: Spy players and robots gain 65% damage resistance and 30% faster attack speed"
	"armoredGiants": "Armored Giants: Non-boss giant robots gain +30% max health and move 20% slower"
	"allOrNothing": "All or Nothing: Robots drop twice as much credits, but players pay $400 per death"
	"offensiveFocus": "Offensive Focus: Players and robots do 1.25x damage"
	"robotsOfSteel": "Robots of Steel: Robots take 40% less damage from ranged sources but 100% more damage from melee"
	"steelPlating": "Steel Plating: Robots gain +50 max health"
	"magicCoating": "Magic Coating: Non-boss robots gain +25% max health"
	"divineSeal": "Divine Seal: Non-boss robots recover all health when not damaged for 5 seconds"
	"allOutOffense": "All-Out Offense: Robots gain crits and -50% max health. Robots with innate crits gain 2x damage instead"
	"acceleratedDevelopment": "Accelerated Development: Robots gain bomb buffs very quickly. Giants can also get bomb buffs"
	//"lastWhirr": "Last Whirr: Robots explode on death, dealing 25 damage to all nearby players"
	"forcefulHeadstart": "Forceful Headstart: Robots gain 3 seconds of uber upon exiting spawn"
	"selfRepair": "Self-Repair: Robots gain 25 health regen"
	"terrifyingTitans": "Terrifying Titans: Giant robots deal 1.25x damage"
	"rushdown": "Rushdown: All small robots are permanently boosted by Concheror effects"
	"deathWatch": "Death Watch: Players lose 5 health per second"
	"hyperTanks": "Hyper Tanks: Tanks move +33% faster"
	"superGiants": "Super Giants: Non-boss giant robots gain +50% max health"
	"reinforcedMedics": "Reinforced Medics: Medic robots activate uber earlier and have 2x max health"
	"deepWounds": "Deep Wounds: All player healing is 50% less effective"
	"protectTheCarrier": "Protect the Carrier: Bomb carriers gain King powerup"
	"septicTank": "Septic Tank: Tanks jarate and set nearby players on fire upon destruction"
	"tripleTrouble": "Triple Trouble: Robots gain two additional bombs"
	"inflammableSkin": "Inflammable Skin: Burning players are Marked for Death"
	"purifyingEmblem": "Purifying Emblem: Robots are immune to all status effects"
}
	
::activeMutators <- []
	
::rollMutators <- function() {
	local choiceArray = []
	choiceArray.extend(mutatorCategories)
	
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
	
	//set custom color?
	ClientPrint(null, 3, "The mission's mutators are:")
	foreach(mutator in activeMutators) {
		ClientPrint(null, 3, descriptions[mutator])
	}
}