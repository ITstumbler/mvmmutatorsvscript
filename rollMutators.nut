foreach(a,b in Constants){foreach(k,v in b){if(!(k in getroottable())){getroottable()[k]<-v;}}} //takes all constant keyvals and puts them in global
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
	"aggressiveMercs": {description = "\x0700de5cAggressive Mercs: Players deal 1.25x damage", points = -3000}
	"healthyFighters": {description = "\x0700de5cHealthy Fighters: Players gain +75 max health", points = -3000}
	"agileLegionaires": {description = "\x0700de5cAgile Legionaires: Players gain a speed boost", points = -1500}
	"stockedUp": {description = "\x0700de5cStocked Up: Players gain 3x ammo capacity", points = -1000}
	"bloodlust": {description = "\x0700de5cBloodlust: Players gain 1 second of critical hits on kill", points = -2000}
	"honorboost": {description = "\x0700de5cHonorboost: Players deal 1.5x fire and melee damage", points = -1500}
	"heavyBomb": {description = "\x0700de5cHeavy Bomb: Bomb carriers move 20% slower", points = -1250}
	"antisupport": {description = "\x0700de5cAntisupport: Sniper and Spy Robots move 30% slower and deal 30% less damage", points = -1500}
	"americanHealthcare": {description = "\x0700de5cAmerican Healthcare: Medicbots drop an additional $50 on death", points = -2500}
	"sharpenedSteel": {description = "\x0700de5cSharpened Steel: All player weapons bleed robots on hit", points = -1000}
	"regenerativeFactor": {description = "\x0700de5cRegenerative Factor: Players gain 4 health regen", points = -1750}
	"guerillaWarfare": {description = "\x0700de5cGuerilla Warfare: Players are cloaked. Cloak is removed for 5 seconds upon firing a weapon", points = -2500}
	"dwarfism": {description = "\x0700de5cDwarfism: Non-boss giant robots have 25% less health", points = -2000}
	"extraLoad": {description = "\x0700de5cExtra Load: Tanks move 25% slower", points = -1500}
	"critWeakness": {description = "\x0700de5cCrit Weakness: Non-tank robots take 1.5x damage from crits", points = -2500}
	"energySaving": {description = "\x0700de5cEnergy Saving: Non-tank robots move 10% slower", points = -1500}
	"hatchGuard": {description = "\x0700de5cHatch Guard: 4 friendly mini-sentries help protect hatch", points = -1750}
	"juggernaut": {description = "\x0700de5cJuggernaut: Players gain Reflect powerup. Players do not gain its max health increase", points = -2000}
	"ourBenefactors": {description = "\x0700de5cOur Benefactors: Start with an additional $800", points = -3000}
	"sabotagedCircuits": {description = "\x0700de5cSabotaged Circuits: Robots are stunned for 1 second upon exiting spawn", points = -1500}
	"marathon": {description = "\x07f3f705Marathon: Scout players and robots gain 1.5x damage and +50 max health", points = 0}
	"freedomania": {description = "\x07f3f705Freedomania: Soldier players and robots gain 35% faster firing/reload speed", points = 0}
	"inferno": {description = "\x07f3f705Inferno: Pyro players and robots gain extra flamethrower range and 1.5x damage", points = 0}
	"pandemonium": {description = "\x07f3f705Pandemonium: Demoman players and robots gain 60% faster reload speed and 1.5x melee damage", points = 0}
	"ironCurtain": {description = "\x07f3f705Iron Curtain: Heavy players and robots gain +200 max health and knockback immunity", points = 0}
	"texasRangers": {description = "\x07f3f705Texas Rangers: Engineer players and robots gain 2x building health and upgrade rate", points = 0}
	"germanTechnology": {description = "\x07f3f705German Technology: Medic players and robots gain 1.5x uber rate and +4s uber duration", points = 0}
	"australiaRules": {description = "\x07f3f705Australia Rules: Sniper players and robots gain 1.5x damage", points = 0}
	"chateauBackstab": {description = "\x07f3f705Chateau Backstab: Spy players and robots gain 65% damage resistance and 30% faster attack speed", points = 0}
	"armoredGiants": {description = "\x07f3f705Armored Giants: Non-boss giant robots gain +30% max health and move 20% slower", points = 0}
	"allOrNothing": {description = "\x07f3f705All or Nothing: Robots drop twice as much credits, but players pay $400 per death", points = 0}
	"offensiveFocus": {description = "\x07f3f705Offensive Focus: Players and robots do 1.25x damage", points = 0}
	"robotsOfSteel": {description = "\x07f3f705Robots of Steel: Robots take 40% less damage from ranged sources but 100% more damage from melee", points = 0}
	"steelPlating": {description = "\x07f70505Steel Plating: Robots gain +50 max health", points = 1750}
	"magicCoating": {description = "\x07f70505Magic Coating: Non-boss robots gain +25% max health", points = 2500}
	"divineSeal": {description = "\x07f70505Divine Seal: Non-boss robots recover all health when not damaged for 5 seconds", points = 2000}
	"allOutOffense": {description = "\x07f70505All-Out Offense: Robots gain crits and -50% max health. Robots with innate crits gain 2x damage instead", points = 1000}
	"acceleratedDevelopment": {description = "\x07f70505Accelerated Development: Robots gain bomb buffs very quickly. Giants can also get bomb buffs", points = 3000}
	//"lastWhirr": "Last Whirr: Robots explode on death, dealing 25 damage to all nearby players"
	"forcefulHeadstart": {description = "\x07f70505Forceful Headstart: Robots gain 3 seconds of uber upon exiting spawn", points = 1500}
	"selfRepair": {description = "\x07f70505Self-Repair: Robots gain 25 health regen", points = 1500}
	"terrifyingTitans": {description = "\x07f70505Terrifying Titans: Giant robots deal 1.25x damage", points = 2250}
	"rushdown": {description = "\x07f70505Rushdown: All small robots are permanently boosted by Concheror effects", points = 3000}
	"deathWatch": {description = "\x07f70505Death Watch: Players lose 5 health per second", points = 2500}
	"hyperTanks": {description = "\x07f70505Hyper Tanks: Tanks move +33% faster", points = 1500}
	"superGiants": {description = "\x07f70505Super Giants: Non-boss giant robots gain +50% max health", points = 3000}
	"reinforcedMedics": {description = "\x07f70505Reinforced Medics: Medic robots activate uber earlier and have 2x max health", points = 2000}
	"deepWounds": {description = "\x07f70505Deep Wounds: All player healing is 50% less effective", points = 2500}
	"protectTheCarrier": {description = "\x07f70505Protect the Carrier: Bomb carriers gain King powerup", points = 1000}
	"septicTank": {description = "\x07f70505Septic Tank: Tanks jarate and set nearby players on fire upon destruction", points = 500}
	"tripleTrouble": {description = "\x07f70505Triple Trouble: Robots gain two additional bombs", points = 1000}
	"inflammableSkin": {description = "\x07f70505Inflammable Skin: Burning players are Marked for Death", points = 1000}
	"purifyingEmblem": {description = "\x07f70505Purifying Emblem: Robots are immune to all status effects", points = 2500}
}

//list of params for various mutators
::mutatorParams <- {
	septicTank_radius = 0
	acceleratedDevelopment_multiplier = 0.5
	sabotagedCircuits_duration = 1
	forcefulHeadstart_duration = 3
}

::activeMutators <- []
	
::rollMutators <- function() {
	local choiceArray = []
	choiceArray.extend(mutatorCategories)
	activeMutators = []
	
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
	
	ClientPrint(null, 3, "The mission's mutators are:")
	foreach(mutator in activeMutators) {
		ClientPrint(null, 3, descriptions[mutator].description)
	}
}