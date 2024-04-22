//anything that doesn't need to be in player scope

function mutators::tripleTrouble() {
	if(Entities.FindByName(null, "mutatorBomb1") != null) {
		return;
	}
	
	local mutatorBomb1 = SpawnEntityFromTable("item_teamflag", {
		name = "mutatorBomb1"
		flag_model = "models/props_td/atom_bomb.mdl"
		gametype = 1
		returntime = 60000
		teamnum = 3
		returnbetweenwaves = 1
		origin = Entities.FindByClassname(null, "item_teamflag").GetOrigin()
	})
	
	local mutatorBomb2 = SpawnEntityFromTable("item_teamflag", {
		name = "mutatorBomb2"
		flag_model = "models/props_td/atom_bomb.mdl"
		gametype = 1
		returntime = 60000
		teamnum = 3
		returnbetweenwaves = 1
		origin = Entities.FindByClassname(null, "item_teamflag").GetOrigin()
	})
}

function mutators::sabotagedCircuits() {
	local bluRespawn = null;
	
	//may need to check if this exists already
	while(bluRespawn = Entities.FindByClassname(bluRespawn, "func_respawnroom")) {
		if(bluRespawn.GetTeam() != TF_TEAM_BLUE) {
			continue;
		}
		EntityOutputs.AddOutput(bluRespawn, "OnEndTouch", "!activator", "RunScriptCode", "self.AddCondEx(71, "+mutators.mutatorParams.sabotagedCircuits_duration+", null)", 0, -1)
	}
}

function mutators::forcefulHeadstart() {
	ClientPrint(null,3,"Henlo")
	local bluRespawn = null;
	
	//make sure uber doesn't conflict with 51
	while(bluRespawn = Entities.FindByClassname(bluRespawn, "func_respawnroom")) {
		if(bluRespawn.GetTeam() != TF_TEAM_BLUE) {
			continue;
		}
		EntityOutputs.AddOutput(bluRespawn, "OnEndTouch", "!activator", "RunScriptCode", "self.AddCondEx(52, "+mutators.mutatorParams.forcefulHeadstart_duration+", null)", 0, -1)
	}
}

function mutators::allOutOffense(bot) {
	if(bot.HasBotAttribute(ALWAYS_CRIT)) {
		bot.AddCustomAttribute("damage penalty", mutatorParams.allOutOffense_damageMultiplier, -1)
	}
	else {
		bot.AddBotAttribute(ALWAYS_CRIT)
		// bot.SetHealth(bot.GetMaxHealth() / 2)
		// bot.AddCustomAttribute("max health additive bonus", -(bot.GetMaxHealth() / 2), -1)
		
		//printl(bot.GetMaxHealth())
	}
	//adjustMaxHp(bot, 0.5, true)
}

function mutators::reinforcedMedics(bot) {
	if(bot.GetPlayerClass() != TF_CLASS_MEDIC) return
	if(bot.IsMiniBoss()) {
		bot.AddCustomAttribute("bot medic uber health threshold", mutatorParams.reinforcedMedics_giantUberDeploy, -1)
	}
	else {
		local medicUberThreshold = bot.GetMaxHealth()
		medicUberThreshold--
		bot.AddCustomAttribute("bot medic uber health threshold", medicUberThreshold, -1)
	}
}

function mutators::adjustMaxHp(bot, hpNum, isMultiplier = false, botCheck = null) {
	if(botCheck == "nonGiants" && bot.IsMiniBoss()) return
	if(botCheck == "nonBoss" && bot.HasBotAttribute(USE_BOSS_HEALTH_BAR)) return
	if(botCheck == "nonBossGiants" && (!bot.IsMiniBoss() || bot.HasBotAttribute(USE_BOSS_HEALTH_BAR))) return
	if(botCheck == "allGiants" && !bot.IsMiniBoss()) return
	local newMaxHp = bot.GetMaxHealth()
	
	if(activeMutators.find("reinforcedMedics") != null && bot.GetPlayerClass() == TF_CLASS_MEDIC) newMaxHp = newMaxHp * mutatorParams.reinforcedMedics_healthMultiplier

	if(isMultiplier) {
		newMaxHp = newMaxHp * hpNum
	}
	else {
		newMaxHp = newMaxHp + hpNum
	}
	
	if(activeMutators.find("allOutOffense") != null) newMaxHp = newMaxHp * allOutOffense_healthMultiplier
	if(activeMutators.find("ironCurtain") != null && bot.GetPlayerClass() == TF_CLASS_HEAVYWEAPONS) newMaxHp += mutatorParams.ironCurtain_extraHealth
	
	
	bot.AddCustomAttribute("max health additive bonus", -(bot.GetMaxHealth() - newMaxHp), -1)
	bot.SetHealth(newMaxHp)
}

function mutators::adjustMaxHpInverse(bot, botCheck = null) {
	if(botCheck == "nonGiants" && bot.IsMiniBoss()) return
	if(botCheck == "nonBoss" && !bot.HasBotAttribute(USE_BOSS_HEALTH_BAR)) return
	if(botCheck == "nonBossGiants" && (bot.IsMiniBoss() && !bot.HasBotAttribute(USE_BOSS_HEALTH_BAR))) return
	if(botCheck == "allGiants" && bot.IsMiniBoss()) return
	
	local newMaxHp = bot.GetMaxHealth()

	if(activeMutators.find("reinforcedMedics") != null && bot.GetPlayerClass() == TF_CLASS_MEDIC) newMaxHp = newMaxHp * mutatorParams.reinforcedMedics_healthMultiplier
	
	if(activeMutators.find("allOutOffense") != null) newMaxHp = newMaxHp * allOutOffense_healthMultiplier
	if(activeMutators.find("ironCurtain" && bot.GetPlayerClass() == TF_CLASS_HEAVYWEAPONS) != null) newMaxHp += mutatorParams.ironCurtain_extraHealth
	
	
	bot.AddCustomAttribute("max health additive bonus", -(bot.GetMaxHealth() - newMaxHp), -1)
	bot.SetHealth(newMaxHp)
}

function mutators::addAttributeOnSpawn(player, attribute, value, classCheck=null, weaponRestriction=null, botCheck=null) {
	if(botCheck == "nonGiants" && player.IsMiniBoss()) return
	if(botCheck == "nonBoss" && player.HasBotAttribute(USE_BOSS_HEALTH_BAR)) return
	if(botCheck == "nonBossGiants" && (!player.IsMiniBoss() || player.HasBotAttribute(USE_BOSS_HEALTH_BAR))) return
	if(botCheck == "allGiants" && !player.IsMiniBoss()) return
	if(classCheck != null && player.GetPlayerClass() != classCheck) return
	if(weaponRestriction != null) {
		for (local i = 0; i < 8; i++)
		{
			local weapon = NetProps.GetPropEntityArray(player, "m_hMyWeapons", i)
			
			if (weapon == null) continue
			//ClientPrint(null,3,""+NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex"))
			if (weapon.IsMeleeWeapon() && weaponRestriction == "melee") weapon.AddAttribute(attribute, value, -1)
			if (weapon.GetClassname() == weaponRestriction) weapon.AddAttribute(attribute, value, -1)
			if (NetProps.GetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex") == weaponRestriction) weapon.AddAttribute(attribute, value, -1)
		}
	}
	else {
		player.AddCustomAttribute(attribute, value, -1)
		player.Regenerate(true)
	}
}

function mutators::addConditionOnSpawn(player, condition, classCheck=null, botCheck=null) {
	if(botCheck == "nonGiants" && player.IsMiniBoss()) return
	if(botCheck == "nonBoss" && player.HasBotAttribute(USE_BOSS_HEALTH_BAR)) return
	if(botCheck == "nonBossGiants" && (!player.IsMiniBoss() || player.HasBotAttribute(USE_BOSS_HEALTH_BAR))) return
	if(botCheck == "allGiants" && !player.IsMiniBoss()) return
	if(classCheck != null && player.GetPlayerClass() != classCheck) return
	player.AddCond(condition)
}

function mutators::ourBenefactors() {
	ClientPrint(null,3,"Man holy shit")
	foreach(i, player in players) {
		EntFireByHandle(player, "RunScriptCode", "mutators.ourBenefactorsAddMoney(activator)", 0.5, player, null)
	}
}

function mutators::ourBenefactorsAddMoney(player) {
	player.AddCurrency(mutatorParams.ourBenefactors_bonusMoney)
}

function mutators::allOrNothing() {
	local mvmStats = Entities.FindByClassname(null, "tf_mann_vs_machine_stats")
	
	mvmStats.ValidateScriptScope()
	local scope = mvmStats.GetScriptScope()
	
	if(mvmStats.GetScriptThinkFunc() == null || mvmStats.GetScriptThinkFunc() == "") {
		return
	}

	scope.think <- function() {
		local acquiredMoney = NetProps.GetPropInt(self, "m_currentWaveStat.nCreditsAcquired")
		local currentMoney = mutators.mutatorParams.allOrNothing_waveCurrency
		
		if(acquiredMoney > currentMoney) {
			local newMoney = acquiredMoney - currentMoney
			
			foreach(index, player in players) {
				player.AddCurrency(newMoney)
			}
			mutators.mutatorParams.allOrNothing_waveCurrency += newMoney
		}
	}
	AddThinkToEnt(mvmStats, "think")
}

function mutators::hatchGuard(reset=false) {
	if(reset) {
		local hatchGuard_miniSentry = null
		while(hatchGuard_miniSentry = Entities.FindByName(hatchGuard_miniSentry, "hatchGuard_miniSentry")) {
			hatchGuard_miniSentry.Kill()
		}
	}
	spawnHatchGuardSentry(mutatorParams.hatchGuard_miniSentry_1_origin, mutatorParams.hatchGuard_miniSentry_1_angles)
	spawnHatchGuardSentry(mutatorParams.hatchGuard_miniSentry_2_origin, mutatorParams.hatchGuard_miniSentry_2_angles)
	spawnHatchGuardSentry(mutatorParams.hatchGuard_miniSentry_3_origin, mutatorParams.hatchGuard_miniSentry_3_angles)
	spawnHatchGuardSentry(mutatorParams.hatchGuard_miniSentry_4_origin, mutatorParams.hatchGuard_miniSentry_4_angles)
}

function mutators::heavyBomb() {
	local flag = null
	while(flag = Entities.FindByClassname(flag, "item_teamflag")) {
		EntityOutputs.AddOutput(flag, "OnPickup1", "!activator", "RunScriptCode", "applyHeavyBombDebuff()", 0, -1)
	}
}

function mutators::spawnHatchGuardSentry(originParam,anglesParam) {
	local miniSentry = SpawnEntityFromTable("obj_sentrygun", {
		targetname = "hatchGuard_miniSentry"
		origin = originParam
		angles = anglesParam
		Skin = 2
		teamnum = 2
		flags = 8
	})
	NetProps.SetPropBool(miniSentry, "m_bMiniBuilding", true)
	miniSentry.SetModelScale(0.75, 0.0)
	miniSentry.SetSkin(miniSentry.GetSkin() + 2)
}

function mutators::extraLoad() {
	initializeTankSpeedAdjustor()
}

function mutators::hyperTanks() {
	initializeTankSpeedAdjustor()
}

function mutators::initializeTankSpeedAdjustor() {
	local path_left = Entities.FindByName(null, "boss_path_left_1")
	EntityOutputs.AddOutput(path_left, "OnPass", "!activator", "RunScriptCode", "mutators.adjustTankSpeed()", 0, -1)
	local path_middle = Entities.FindByName(null, "boss_path_middle_1")
	EntityOutputs.AddOutput(path_middle, "OnPass", "!activator", "RunScriptCode", "mutators.adjustTankSpeed()", 0, -1)
	local path_right = Entities.FindByName(null, "boss_path_right_1")
	EntityOutputs.AddOutput(path_right, "OnPass", "!activator", "RunScriptCode", "mutators.adjustTankSpeed()", 0, -1)
}

function mutators::divineSeal() {
	local divineSeal_healWarningParticles = SpawnEntityFromTable("trigger_particle",
	{
		targetname = "divineSeal_healWarningParticles"
		particle_name = "divineSeal_healWarning",
		attachment_type = 6,
		spawnflags = 1
	})
	local divineSeal_healBoomParticles = SpawnEntityFromTable("trigger_particle",
	{
		targetname = "divineSeal_healBoomParticles"
		particle_name = "divineSeal_healBoom",
		attachment_type = 6,
		spawnflags = 1
	})
}


function mutators::septicTank() {
	local path_left = Entities.FindByName(null, "boss_path_left_1")
	EntityOutputs.AddOutput(path_left, "OnPass", "!activator", "RunScriptCode", "mutators.addSepticTankOutput()", 0, -1)
	local path_middle = Entities.FindByName(null, "boss_path_middle_1")
	EntityOutputs.AddOutput(path_middle, "OnPass", "!activator", "RunScriptCode", "mutators.addSepticTankOutput()", 0, -1)
	local path_right = Entities.FindByName(null, "boss_path_right_1")
	EntityOutputs.AddOutput(path_right, "OnPass", "!activator", "RunScriptCode", "mutators.addSepticTankOutput()", 0, -1)
}

function mutators::addSepticTankOutput() {
	EntityOutputs.AddOutput(activator, "OnKilled", "!self", "RunScriptCode", "mutators.septicTankExplode()", 0, -1)
}

function mutators::septicTankExplode() {
	ClientPrint(null,3,"JARATE!")
	local tankOrigin = activator.GetOrigin()
	ClientPrint(null,3,"Haha "+tankOrigin)
}

function mutators::adjustTankSpeed() {
	local tankSpeedMultiplier = 1
	if (mutators.activeMutators.find("extraLoad") != null) {
		tankSpeedMultiplier = mutators.mutatorParams.extraLoad_speedMultiplier
	}
	else if (mutators.activeMutators.find("hyperTanks") != null) {
		tankSpeedMultiplier = mutators.mutatorParams.hyperTanks_speedMultiplier
	}
	local speed = activator.GetLocomotionInterface().GetDesiredSpeed() * tankSpeedMultiplier;
	EntFireByHandle(activator, "SetSpeed", speed.tostring(), 0, null, null)
}

function mutators::protectTheCarrier() {
	local flag = null
	EntFire("bomb_shield_prop","kill")
	while(flag = Entities.FindByClassname(flag, "item_teamflag")) {
		EntityOutputs.AddOutput(flag, "OnPickup1", "!activator", "RunScriptCode", "protectTheCarrierBombPickup()", 0, -1)
	}
}

function mutators::acceleratedDevelopment() {
	local flag = null

	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade", 5 * mutatorParams.acceleratedDevelopment_multiplier)
	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade", 15 * mutatorParams.acceleratedDevelopment_multiplier)
	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade", 15 * mutatorParams.acceleratedDevelopment_multiplier)
	
	while(flag = Entities.FindByClassname(flag, "item_teamflag")) {
		EntityOutputs.AddOutput(flag, "OnPickup1", "!activator", "RunScriptCode", "acceleratedDevelopmentHasBomb()", 0, -1)
	}
}

//and you need to store the total variable of extra cash collected in previous waves, this wave in global variables
//remove current wave cash upon wave fail and regive cash collected in previous waves

function mutators::purifyingEmblem() {
	local purifyingEmblem_constantParticles = SpawnEntityFromTable("trigger_particle",
	{
		targetname = "purifyingEmblem_constantParticles"
		particle_name = "purifyingEmblem_constantStatusDenied",
		attachment_type = 6,
		spawnflags = 1
	})
	local purifyingEmblem_bigParticles = SpawnEntityFromTable("trigger_particle",
	{
		targetname = "purifyingEmblem_bigParticles"
		particle_name = "purifyingEmblem_bigStatusDenied",
		attachment_type = 6,
		spawnflags = 1
	})
}
