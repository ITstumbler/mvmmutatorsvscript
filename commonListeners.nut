mutators.missionName <- NetProps.GetPropString(mutators.objResource, "m_iszMvMPopfileName")

//runs before waveinit, so if we changed to a mutator mission it'll regen
function mutators::OnGameEvent_recalculate_holidays(params) {
	if(GetRoundState() == GR_STATE_PREROUND && missionName != NetProps.GetPropString(objResource, "m_iszMvMPopfileName")) {
		cleanup()
		delete ::mutators
	}

	// if(activeMutators.find("protectTheCarrier") != null) {
	// 	EntFire("bomb_shield_prop", "kill")
	// }

	if(GetRoundState() != GR_STATE_PREROUND) return

	foreach(mutator in activeMutators) {
		if(mutator in mutators) {
			mutators[mutator]()
		}
	}
}

function mutators::OnGameEvent_mvm_mission_complete(params) {
	cleanup()
	delete ::mutators
}

function mutators::OnGameEvent_mvm_wave_failed(params) {
	if(activeMutators.find("allOrNothing") != null) {

	}
	waveFailed = true
	if(activeMutators.find("protectTheCarrier") != null) {
		EntFire("bomb_shield_prop", "kill")
	}
}

function mutators::OnGameEvent_mvm_wave_complete(params) {
	if(activeMutators.find("hatchGuard") != null) {
		hatchGuard(true)
	}
	
	if(activeMutators.find("allOrNothing") != null) {
		mutatorParams.allOrNothing_totalCurrency = mutatorParams.allOrNothing_totalCurrency 
			+ mutatorParams.allOrNothing_waveCurrency
	}
	if(activeMutators.find("protectTheCarrier") != null) {
		EntFire("bomb_shield_prop", "kill")
	}
}

//Used by Divine Seal
function mutators::OnGameEvent_player_hurt(params) {
	if(activeMutators.find("divineSeal") != null) {
		local player = GetPlayerFromUserID(params.userid)
		//threshold prob should be a var
		//ent_fire !self runscriptcode "IncludeScript(`mvmmutatorsvscript/botMutatorFunctions.nut`)"
		if(IsPlayerABot(player) && player.GetMaxHealth() >= mutatorParams.divineSeal_minimumHealth && !player.HasBotAttribute(USE_BOSS_HEALTH_BAR)) {
			player.GetScriptScope().divineSealHealTimer = Time() + mutatorParams.divineSeal_healingDuration
			player.GetScriptScope().divineSealParticleTimer = Time() + mutatorParams.divineSeal_particleDisplayDelay
			player.GetScriptScope().divineSealCurrentlyHealing = true
			player.GetScriptScope().divineSealCurrentlyParticling = true
			EntFireByHandle(player, "DispatchEffect", "ParticleEffectStop", -1, player, player)
		}
	}
}
	
function mutators::OnGameEvent_player_spawn(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	if(!IsPlayerABot(player) && !(player.GetEntityIndex() in players)) { //if player is not in table
		players[player.GetEntityIndex()] <- player
		
		initPlayer(player)
		AddThinkToEnt(player, "think")
	}

	if(!waveFailed && GetRoundState() == GR_STATE_PREROUND && NetProps.GetPropInt(objResource, "m_nMannVsMachineWaveCount") == 1) return

	if(activeMutators.find("dwarfism") == null && activeMutators.find("armoredGiants") == null && activeMutators.find("steelPlating") == null 
		&& activeMutators.find("magicCoating") == null && activeMutators.find("superGiants") == null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, 1, true)", -1, player, null)
		}
	}

	if(activeMutators.find("aggressiveMercs") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg penalty vs players`, "+mutatorParams.aggressiveMercs_damageMultiplier+")", -1, player, null)
		}
	}

	if(activeMutators.find("healthyFighters") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `max health additive bonus`, "+mutatorParams.healthyFighters_extraHealth+")", -1, player, null)
		}
	}

	if(activeMutators.find("agileLegionnaires") != null) {
		//Todo: fix typo (it's "Legionnaires")
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: move speed bonus`, "+mutatorParams.agileLegionnaires_speedMultiplier+")", -1, player, null)
		}
	}

	if(activeMutators.find("stockedUp") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden primary max ammo bonus`, "+mutatorParams.stockedUp_ammoMultiplier+")", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden secondary max ammo penalty`, "+mutatorParams.stockedUp_ammoMultiplier+")", -1, player, null)
			//EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `maxammo metal increased`, 3)", -1, player, null)
		}
	}

	if(activeMutators.find("bloodlust") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `critboost on kill`, "+mutatorParams.bloostlust_critOnKillDuration+")", -1, player, null)
		}
	}

	if(activeMutators.find("honorboost") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.honorboost_damageMultiplier+", null, `melee`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.honorboost_damageMultiplier+", null, `tf_weapon_flamethrower`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.honorboost_damageMultiplier+", null, `tf_weapon_rocketlauncher_fireball`)", -1, player, null)
		}
	}

	if(activeMutators.find("antisupport") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `mult_player_movespeed_active`, "+mutatorParams.antisupport_speedMultiplier+", 2)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `mult_player_movespeed_active`, "+mutatorParams.antisupport_speedMultiplier+", 8)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage penalty`, "+mutatorParams.antisupport_damageMultiplier+", 2)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage penalty`, "+mutatorParams.antisupport_damageMultiplier+", 8)", -1, player, null)
		}
	}

	if(activeMutators.find("sharpenedSteel") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `bleeding duration`, "+mutatorParams.sharpenedSteel_bleedDuration+")", -1, player, null)
		}
	}

	if(activeMutators.find("regenerativeFactor") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `SET BONUS: health regen set bonus`, "+mutatorParams.regenerativeFactor_healthRegen+")", -1, player, null)
		}
	}

	if(activeMutators.find("dwarfism") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, "+mutatorParams.dwarfism_healthMultiplier+", true, `nonBossGiants`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHpInverse(activator, `nonBossGiants`)", -1, player, null)
		}
	}

	if(activeMutators.find("critWeakness") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg taken from crit increased`, "+mutatorParams.critWeakness_critDamageMultiplier+")", -1, player, null)
		}
	}

	if(activeMutators.find("energySaving") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: move speed bonus`, "+mutatorParams.energySaving_speedMultiplier+")", -1, player, null)
		}
	}

	if(activeMutators.find("juggernaut") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `killstreak tier`, 1)", -1, player, null)
			player.GetScriptScope().juggernautKillstreak = 0
		}
	}

	if(activeMutators.find("offensiveFocus") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.offensiveFocus_damageMultiplier+")", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `engy sentry damage bonus`, "+mutatorParams.offensiveFocus_damageMultiplier+")", -1, player, null)
	}

	if(activeMutators.find("robotsOfSteel") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg from ranged reduced`, "+mutatorParams.robotsOfSteel_rangedDmgMultiplier+")", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg from melee increased`, "+mutatorParams.robotsOfSteel_meleeDmgMultiplier+")", -1, player, null)
		}
	}

	if(activeMutators.find("marathon") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.marathon_damageMultiplier+", 1)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden maxhealth non buffed`, "+mutatorParams.marathon_extraHealth+", 1)", -1, player, null)
	}

	if(activeMutators.find("freedomania") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `fire rate bonus`, "+mutatorParams.freedomania_fireRateMultiplier+", 3)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `Reload time decreased`, "+mutatorParams.freedomania_reloadSpeedMultiplier+", 3)", -1, player, null)
	}

	if(activeMutators.find("inferno") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.inferno_damageMultiplier+", 7)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `flame_drag`, "+mutatorParams.inferno_flameDrag+", 7)", -1, player, null)
	}

	if(activeMutators.find("pandemonium") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `Reload time decreased`, "+mutatorParams.pandemonium_reloadSpeedMultiplier+", 4)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage bonus HIDDEN`, "+mutatorParams.pandemonium_meleeDamageMultiplier+", 4, `melee`)", -1, player, null)
	}

	if(activeMutators.find("ironCurtain") != null && player.GetPlayerClass() == TF_CLASS_HEAVYWEAPONS) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage force increase hidden`, "+mutatorParams.ironCurtain_knockbackMultiplier+", 6)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `airblast vulnerability multiplier`, "+mutatorParams.ironCurtain_knockbackMultiplier+", 6)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `airblast vertical vulnerability multiplier`, "+mutatorParams.ironCurtain_knockbackMultiplier+", 6)", -1, player, null)
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden maxhealth non buffed`, "+mutatorParams.ironCurtain_extraHealth+", 6)", -1, player, null)
		}
	}

	if(activeMutators.find("texasRangers") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `engy building health bonus`, "+mutatorParams.texasRangers_buildingHpMultiplier+", 9)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `engy sentry damage bonus`, "+mutatorParams.texasRangers_sentryDamageMultiplier+", 9)", -1, player, null)
	}

	if(activeMutators.find("germanTechnology") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `ubercharge rate bonus`, "+mutatorParams.germanTechnology_uberRateMultiplier+", 5)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `uber duration bonus`, "+mutatorParams.germanTechnology_extraUberDuration+", 5)", -1, player, null)
	}

	if(activeMutators.find("australianRules") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, "+mutatorParams.australianRules_damageMultiplier+", 2)", -1, player, null)
	}

	if(activeMutators.find("chateauBackstab") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg taken increased`, "+mutatorParams.chateauBackstab_dmgTakenMultiplier+", 8)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `fire rate bonus`, "+mutatorParams.chateauBackstab_fireRateMultiplier+", 8)", -1, player, null)
	}

	if(activeMutators.find("armoredGiants") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, "+mutatorParams.armoredGiants_healthMultiplier+", true, `nonBossGiants`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHpInverse(activator, `nonBossGiants`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `move speed penalty`, "+mutatorParams.armoredGiants_speedMultiplier+", null, null, `nonBossGiants`)", -1, player, null)
		}
	}

	if(activeMutators.find("steelPlating") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, "+mutatorParams.steelPlating_extraHealth+", false)", -1, player, null)
		}
	}

	if(activeMutators.find("magicCoating") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, "+mutatorParams.magicCoating_healthMultiplier+", true, `nonBoss`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHpInverse(activator, `nonBoss`)", -1, player, null)
		}
	}

	if(activeMutators.find("selfRepair") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `health drain`, "+mutatorParams.selfRepair_healthRegen+")", -1, player, null)
		}
	}

	if(activeMutators.find("terrifyingTitans") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg penalty vs players`, "+mutatorParams.terrifyingTitans_damageMultiplier+", null, null, `allGiants`)", -1, player, null)
		}
	}

	if(activeMutators.find("rushdown") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addConditionOnSpawn(activator, "+mutatorParams.rushdown_conditionNumber+", null, `nonGiants`)", -1, player, null)
		}
	}
	
	if(activeMutators.find("deathWatch") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `health drain`, "+mutatorParams.deathWatch_healthDrain+")", -1, player, null)
		}
	}

	if(activeMutators.find("superGiants") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, "+mutatorParams.superGiants_healthMultiplier+", true, `nonBossGiants`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHpInverse(activator, `nonBossGiants`)", -1, player, null)
		}
	}
	
	if(activeMutators.find("reinforcedMedics") != null) {
		if(IsPlayerABot(player)) {
			//Delay to ensure it fires after max hp adjustments
			EntFireByHandle(player, "RunScriptCode", "mutators.reinforcedMedics(activator)", 1, player, null)
		}
	}

	if(activeMutators.find("deepWounds") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `healing received penalty`, "+mutatorParams.deepWounds_healingMultiplier+")", -1, player, null)
		}
	}
	
	if(activeMutators.find("allOutOffense") != null) { //might want a cleaner way of showing this?
		if(IsPlayerABot(player)) {
			//use entfire to ensure bot stuff is applied
			EntFireByHandle(player, "RunScriptCode", "mutators.allOutOffense(activator)", -1, player, null)
		}
	}

	if(activeMutators.find("purifyingEmblem") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage force increase hidden`, 0.01)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `airblast vulnerability multiplier hidden`, 0.01)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `airblast vertical vulnerability multiplier`, 0.01)", -1, player, null)
		}
		else {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `slow enemy on hit`, 0, null, 41)", -1, player, null)
		}
	}
}

function mutators::OnGameEvent_player_disconnect(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	delete players[player.GetEntityIndex()]
}

function mutators::OnGameEvent_player_death(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	if(activeMutators.find("allOrNothing") != null) {
		if(player.GetTeam() == TF_TEAM_RED) {
			player.GetScriptScope().allOrNothingWavePenalty = player.GetScriptScope().allOrNothingWavePenalty 
				- mutatorParams.allOrNothing_penalty
			player.RemoveCurrency(mutatorParams.allOrNothing_penalty)
		}
	}

	if(activeMutators.find("protectTheCarrier") != null) {
		if(player.GetScriptScope().protectTheCarrierIsBombCarrier == true) {
			EntFire("bomb_shield_prop", "kill")
			player.GetScriptScope().protectTheCarrierIsBombCarrier = false
		}
		local protectTheCarrierParticle = Entities.FindByName(null, "protectTheCarrier_particle_" + player.entindex())
		if(protectTheCarrierParticle) {
			protectTheCarrierParticle.Kill()
		}
	}

	if(activeMutators.find("juggernaut") != null) {
		if(IsPlayerABot(player)) {
			local killer = GetPlayerFromUserID(params.attacker)
			if(killer.GetScriptScope().juggernautKillstreak < mutatorParams.juggernaut_killCap) killer.GetScriptScope().juggernautKillstreak += 1

			local damageMultiplier = 1
			if(activeMutators.find("aggressiveMercs") != null) damageMultiplier = mutatorParams.aggressiveMercs_damageMultiplier
			// ClientPrint(null,3,"Base damage multiplier is " + damageMultiplier)
			// ClientPrint(null,3,"Damage multiplier per kill is " + mutatorParams.juggernaut_damageMultiplierPerKill)
			// ClientPrint(null,3,"Killstreak is " + killer.GetScriptScope().juggernautKillstreak)
			// ClientPrint(null,3,"Everything multiplied is " + (damageMultiplier * (mutatorParams.juggernaut_damageMultiplierPerKill * killer.GetScriptScope().juggernautKillstreak)))
			damageMultiplier = damageMultiplier + (damageMultiplier * (mutatorParams.juggernaut_damageMultiplierPerKill * killer.GetScriptScope().juggernautKillstreak))

			killer.AddCustomAttribute("dmg penalty vs players", damageMultiplier, -1)
		}
	}
	
	if(activeMutators.find("lastWhirr") != null) {
		if(player.GetTeam() == TF_TEAM_BLUE) {
			local victim = null
			
			/*
			local particle = SpawnEntityGroupFromTable({ //apparently need to use this for parentname
				a = {
					info_particle_system = {
						targetname = "lastWhirr_particle_" + player.entindex()
						effect_name = "ExplosionCore_MidAir"
						start_active = true
						origin = player.GetCenter()
					}
				}
			})
			EntFireByHandle(particle, "Kill", "", 0.2, particle, particle)
			*/
			
			DispatchParticleEffect("ExplosionCore_MidAir", player.GetCenter(), QAngle(0, 0, 0))
			
			while(victim = Entities.FindByClassnameWithin(victim, "player", player.GetCenter(), mutatorParams.lastWhirr_radius)) {
				if(victim.GetTeam() == TF_TEAM_RED) {
					local distance = (victim.GetCenter() - player.GetCenter()).Length()

					local shouldDamage = true
					printl("distance " + distance)
					//DebugDrawCircle(player.GetCenter(), Vector(255, 0, 0), 127, mutatorParams.lastWhirr_radius, true, 1)
					
					local traceTable = {
						start = player.GetCenter()
						end = victim.GetCenter()
					}
					TraceLineEx(traceTable)
					
					if(traceTable.hit && traceTable.enthit != victim) {
						//not los, don't damage them
						shouldDamage = false
					}
					
					if(shouldDamage) {
						local splash = distance / mutatorParams.lastWhirr_reductionDistance
						local damage = mutatorParams.lastWhirr_dmg * (1 - splash / 100)
						printl("damage " + damage)
						
						victim.TakeDamageEx(player, null, null, Vector(0, 0, 0), player.GetOrigin(), damage, DMG_BLAST)
					}
				}
			}
		}
	}

	if(activeMutators.find("purifyingEmblem") != null || activeMutators.find("divineSeal") != null) {
		EntFireByHandle(player, "DispatchEffect", "ParticleEffectStop", -1, player, player)
	}
}

__CollectGameEventCallbacks(mutators)