//bot specific functions 
local scope = self.GetScriptScope()

scope.thinkFunctions <- {}
scope.divineSealCurrentlyHealing <- false
scope.divineSealTimer <- -1
scope.protectTheCarrierInRadius <- false
scope.protectTheCarrierIsBombCarrier <- false

function think() {
	foreach(key, func in thinkFunctions) {
		func()
	}
}

function divineSeal() {
	//printl("divine sealing rn")
	if(Time() >= divineSealTimer && divineSealCurrentlyHealing) {
		divineSealCurrentlyHealing = false
		self.SetHealth(self.GetMaxHealth())
	}
}

function applyHeavyBombDebuff() {
	if(mutators.activeMutators.find("energySaving") != null) {
		self.AddCustomAttribute("CARD: move speed bonus", mutators.mutatorParams.heavyBomb_speedMultiplier * mutators.mutatorParams.energySaving_speedMultiplier, -1)
	}
	else {
		self.AddCustomAttribute("CARD: move speed bonus", mutators.mutatorParams.heavyBomb_speedMultiplier, -1)
	}
}

function protectTheCarrierBombPickup() {
	scope.protectTheCarrierIsBombCarrier = true
	local carrierOrigin = self.GetOrigin()
	carrierOrigin = carrierOrigin + (self.HasBotAttribute(MINIBOSS) ? Vector(0,0,72) : Vector(0,0,40))
	//NetProps.SetPropString(self, "m_iName", self.GetEntityIndex().tostring())

	local bomb_shield_prop = SpawnEntityFromTable("prop_dynamic", {
		targetname = "bomb_shield_prop"
		origin = carrierOrigin
		disableshadows = 1
		model = "models/mutators/bomb_shield.mdl"
		modelscale = mutators.mutatorParams.protectTheCarrier_modelScale
		lightingorigin = "bright_lighting_info"
	})

    //EntFireByHandle(bomb_shield_prop, "SetParent", self.GetEntityIndex().tostring(), -1, bomb_shield_prop, null)
	//bomb_shield_prop.SetModelScale(mutators.mutatorParams.protectTheCarrier_modelScale, 0.0)
	//EntFireByHandle(bomb_shield_prop, "DisableShadows", 0, -1, bomb_shield_prop, null)
	//EntFireByHandle(bomb_shield_prop, "SetParentAttachment", "flag", 0.03, bomb_shield_prop, null)

	thinkFunctions["protectTheCarrierThink"] <- protectTheCarrierThink
}

function protectTheCarrierThink() {
	//Particle names:
	//mutator_bomb_shield_glow
	//mutator_bomb_shield_giant_glow

	if(NetProps.GetPropInt(self, "m_lifeState") != 0) {
		delete thinkFunctions["protectTheCarrierThink"]
		//bomb_shield_prop.Kill()
		return
	}

	local carrierOrigin = self.GetOrigin()

	local bomb_shield_prop = Entities.FindByName(null, "bomb_shield_prop")

	if(bomb_shield_prop != null) {
		local propGoalOrigin = carrierOrigin + (self.HasBotAttribute(MINIBOSS) ? Vector(0,0,72) : Vector(0,0,40))
		bomb_shield_prop.SetAbsOrigin(propGoalOrigin)
	}

	for(local i = 1; i <= mutators.maxPlayers; i++) {
		local nearbyBot = PlayerInstanceFromIndex(i)
		if(nearbyBot == null) continue
		if(!IsPlayerABot(nearbyBot)) continue
		if(nearbyBot.GetTeam() != 3) continue

		local nearbyBotOrigin = nearbyBot.GetOrigin()
		local distanceX = pow(nearbyBotOrigin.x - carrierOrigin.x, 2)
		local distanceY = pow(nearbyBotOrigin.y - carrierOrigin.y, 2)
		local distanceZ = pow(nearbyBotOrigin.z - carrierOrigin.z, 2)
		local rootedDistanceSum = pow(distanceX + distanceY + distanceZ, 0.5)

		local nearbyBotScope = nearbyBot.GetScriptScope()

		if(nearbyBotScope.protectTheCarrierInRadius == false && rootedDistanceSum <= mutators.mutatorParams.protectTheCarrier_radius) {
			if(mutators.activeMutators.find("selfRepair") != null) {
				nearbyBot.AddCustomAttribute("health drain", mutators.mutatorParams.protectTheCarrier_healthRegen + mutators.mutatorParams.selfRepair_healthRegen, -1)
			}
			else {
				nearbyBot.AddCustomAttribute("health drain", mutators.mutatorParams.protectTheCarrier_healthRegen, -1)
			}
			
			if(nearbyBot.GetPlayerClass() == TF_CLASS_SPY && mutators.activeMutators.find("chateauBackstab") != null) {
				nearbyBot.AddCustomAttribute("dmg taken increased", mutators.mutatorParams.protectTheCarrier_dmgReduction * mutators.mutatorParams.chateauBackstab_dmgTakenMultiplier, -1)
			}
			else {
				nearbyBot.AddCustomAttribute("dmg taken increased", mutators.mutatorParams.protectTheCarrier_dmgReduction, -1)
			}

			local particleName = null
			NetProps.SetPropString(nearbyBot, "m_iName", nearbyBot.entindex().tostring())
			particleName = nearbyBot.IsMiniBoss() ? "mutator_bomb_shield_giant_glow" : "mutator_bomb_shield_glow"
			
			local particle = SpawnEntityGroupFromTable({ //apparently need to use this for parentname
				a = {
					info_particle_system = {
						targetname = "protectTheCarrier_particle_" + nearbyBot.entindex()
						effect_name = particleName
						start_active = true
						origin = nearbyBot.GetOrigin()
						parentname = nearbyBot.GetName()
					}
				}
			})
			nearbyBotScope.protectTheCarrierInRadius = true
		}

		if(nearbyBotScope.protectTheCarrierInRadius == true && rootedDistanceSum > mutators.mutatorParams.protectTheCarrier_radius) {
			if(mutators.activeMutators.find("selfRepair") != null) {
				nearbyBot.AddCustomAttribute("health drain", mutators.mutatorParams.selfRepair_healthRegen, -1)
			}
			else {
				nearbyBot.RemoveCustomAttribute("health drain")
			}
			if(nearbyBot.GetPlayerClass() == TF_CLASS_SPY && mutators.activeMutators.find("chateauBackstab") != null) {
				nearbyBot.AddCustomAttribute("dmg taken increased", mutators.mutatorParams.chateauBackstab_dmgTakenMultiplier, -1)
			}
			else {
				nearbyBot.RemoveCustomAttribute("dmg taken increased")
			}
			nearbyBotScope.protectTheCarrierInRadius = false

			local nearbyBotEntIndex = nearbyBot.entindex().tostring()
			nearbyBotEntIndex = "protectTheCarrier_particle_" + nearbyBotEntIndex
			local bomb_shield_particle = Entities.FindByName(null, nearbyBotEntIndex)
			if(bomb_shield_particle) {
				bomb_shield_particle.Kill()
			}
		}
	}

	return -1
}

//does setup for the main think
function acceleratedDevelopmentHasBomb() {
	if(!self.HasBotAttribute(MINIBOSS)) {
		return
	}
	
	NetProps.SetPropString(self, "m_iName", self.GetEntityIndex().tostring())
	
	local targetName = UniqueString()
	local particleAttachment = SpawnEntityFromTable("info_target", {targetname = targetName})
	EntFire(targetName, "SetParent", self.GetEntityIndex().tostring(), -1)
	EntFire(targetName, "SetParentAttachment", "head", -1)
	
	particleTarget <- particleAttachment
	buffTimer <- null
	
	NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 0)
	NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
	NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() 
		+ Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade"))
	
	upgradeTime <- NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")
	
	thinkFunctions["acceleratedDevelopmentThink"] <- acceleratedDevelopmentThink
}

//name so it doesn't automatically get added to think
function acceleratedDevelopmentThink() {
	local navTile = self.GetLastKnownArea()
	
	if(navTile != null && navTile.HasAttributeTF(TF_NAV_SPAWN_ROOM_BLUE)) {
		//procrastinate ticking the timer
		//this may need reworked considering how this normally works
		printl("in spawnroom, haven't started timer")
		NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
		NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() 
			+ Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade"))
		upgradeTime = NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")
		return;
	}
	
	printl(Time())
	//printl(NetProps.GetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime"))
	printl(NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime"))
	//printl(NetProps.GetPropInt(objResource, "m_nFlagCarrierUpgradeLevel"))
	
	//if dead, stop this func
	if(NetProps.GetPropInt(self, "m_lifeState") != 0) {
		delete thinkFunctions["acceleratedDevelopmentThink"]
		delete buffTimer
		particleTarget.Kill()
		return;
	}
	
	//ent_fire player runscriptcode "AddThinkToEnt(self, `think`)"
	
	if(Time() >= upgradeTime) { //enough time has passed, time to upgrade
		local upgradeLevel = NetProps.GetPropInt(objResource, "m_nFlagCarrierUpgradeLevel")
		if(upgradeLevel < 3) {
			EntFire("tf_gamerules", "PlayVO", "MVM.Warning", -1)
		
			switch(upgradeLevel) {
				case 0:				
					self.Taunt(TAUNT_BASE_WEAPON, null)
					
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 1)
					NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
					NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() 
						+ Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade"))
					
					upgradeTime = NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")
					
					foreach(i, player in players) {
						EntFireByHandle(player, "AddContext", "ConceptMvMBombCarrierUpgrade1:1", -1, null, null)
						//the concept rules handle the chance
						EntFireByHandle(player, "SpeakResponseConcept", "TLK_MVM_BOMB_CARRIER_UPGRADE1", -1, null, null)
					}
					DispatchParticleEffect("mvm_levelup1", particleTarget.GetOrigin(), Vector(0, 0, 0))
					buffTimer = Time()
					break;
				case 1:
					self.Taunt(TAUNT_BASE_WEAPON, null)
					
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 2)
					NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
					NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() 
						+ Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade"))
					
					upgradeTime = NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")
					
					foreach(i, player in players) {
						EntFireByHandle(player, "AddContext", "ConceptMvMBombCarrierUpgrade2:1", -1, null, null)
						EntFireByHandle(player, "SpeakResponseConcept", "TLK_MVM_BOMB_CARRIER_UPGRADE2", -1, null, null)
					}
					DispatchParticleEffect("mvm_levelup2", particleTarget.GetOrigin(), Vector(0, 0, 0))
					self.AddCustomAttribute("CARD: health regen", Convars.GetFloat("tf_mvm_bot_flag_carrier_health_regen"), -1)
					break;
				case 2:
					self.Taunt(TAUNT_BASE_WEAPON, null)
				
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 3)
					NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", -1)
					NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", -1)
					foreach(i, player in players) {
						EntFireByHandle(player, "AddContext", "ConceptMvMBombCarrierUpgrade3:1", -1, null, null)
						EntFireByHandle(player, "SpeakResponseConcept", "TLK_MVM_BOMB_CARRIER_UPGRADE3", -1, null, null)
					}
					DispatchParticleEffect("mvm_levelup3", particleTarget.GetOrigin(), Vector(0, 0, 0))
					self.AddCond(TF_COND_CRITBOOSTED)
					break;
				default:
					break;
			}
		}
	}
	
	if(buffTimer != null) {
		if(Time() >= buffTimer) {
			local player = null
			while(player = Entities.FindByClassnameWithin(player, "player", self.GetOrigin(), 450)) {
				if(player.GetTeam() == TF_TEAM_BLUE) {
					player.AddCondEx(TF_COND_DEFENSEBUFF_NO_CRIT_BLOCK, 1.1, null)
				}
			}
			buffTimer = Time() + 1.1
		}
	}
}