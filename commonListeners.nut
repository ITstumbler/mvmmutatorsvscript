mutators.missionName <- NetProps.GetPropString(mutators.objResource, "m_iszMvMPopfileName")

//runs before waveinit, so if we changed to a mutator mission it'll regen
function mutators::OnGameEvent_recalculate_holidays(params) {
	if(GetRoundState() == GR_STATE_PREROUND && missionName != NetProps.GetPropString(objResource, "m_iszMvMPopfileName")) {
		cleanup()
		delete ::mutators
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
}

function mutators::OnGameEvent_mvm_wave_complete(params) {
	if(activeMutators.find("allOrNothing") != null) {
		mutatorParams.totalAllOrNothingCurrency = mutatorParams.totalAllOrNothingCurrency 
			+ mutatorParams.waveAllOrNothingCurrency
	}
}

//Used by Divine Seal
function mutators::OnGameEvent_player_hurt(params) {
	if(activeMutators.find("divineSeal") != null) {
		local player = GetPlayerFromUserID(params.userid)
		//threshold prob should be a var
		//ent_fire !self runscriptcode "IncludeScript(`mvmmutatorsvscript/botMutatorFunctions.nut`)"
		if(IsPlayerABot(player) && player.GetMaxHealth() > 300 && !player.HasBotAttribute(USE_BOSS_HEALTH_BAR)) {
			player.GetScriptScope().divineSealTimer = Time() + 5
			player.GetScriptScope().divineSealCurrentlyHealing = true
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

	if(activeMutators.find("dwarfism") == null && activeMutators.find("armoredGiants") == null && activeMutators.find("steelPlating") == null && activeMutators.find("magicCoating") == null && activeMutators.find("superGiants") == null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, 1, true)", -1, player, null)
		}
	}

	if(activeMutators.find("aggressiveMercs") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg penalty vs players`, 1.25)", -1, player, null)
		}
	}

	if(activeMutators.find("healthyFighters") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `max health additive bonus`, 75)", -1, player, null)
		}
	}

	if(activeMutators.find("agileLegionnaires") != null) {
		//Todo: fix typo (it's "Legionnaires")
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: move speed bonus`, 1.2)", -1, player, null)
		}
	}

	if(activeMutators.find("stockedUp") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden primary max ammo bonus`, 3)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden secondary max ammo penalty`, 3)", -1, player, null)
			//EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `maxammo metal increased`, 3)", -1, player, null)
		}
	}

	if(activeMutators.find("bloodlust") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `critboost on kill`, 1)", -1, player, null)
		}
	}

	if(activeMutators.find("honorboost") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.5, null, `melee`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.5, null, `tf_weapon_flamethrower`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.5, null, `tf_weapon_rocketlauncher_fireball`)", -1, player, null)
		}
	}

	if(activeMutators.find("sharpenedSteel") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `bleeding duration`, 5)", -1, player, null)
		}
	}

	if(activeMutators.find("regenerativeFactor") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `SET BONUS: health regen set bonus`, 4)", -1, player, null)
		}
	}

	if(activeMutators.find("dwarfism") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHp(activator, 0.75, true, `nonBossGiants`)", -1, player, null)
			EntFireByHandle(player, "RunScriptCode", "mutators.adjustMaxHpInverse(activator, `nonBossGiants`)", -1, player, null)
		}
	}

	if(activeMutators.find("critWeakness") != null) {
		if(IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg taken from crit increased`, 1.5)", -1, player, null)
		}
	}

	if(activeMutators.find("offensiveFocus") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.25)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `engy sentry damage bonus`, 1.25)", -1, player, null)
	}

	if(activeMutators.find("marathon") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.5, 1)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden maxhealth non buffed`, 50, 1)", -1, player, null)
	}

	if(activeMutators.find("freedomania") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `fire rate bonus`, 0.65, 3)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `Reload time decreased`, 0.65, 3)", -1, player, null)
	}

	if(activeMutators.find("inferno") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.5, 7)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `flame_drag`, -2.5, 7)", -1, player, null)
	}

	if(activeMutators.find("pandemonium") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `Reload time decreased`, 0.4, 4)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage bonus HIDDEN`, 1.5, 4, `melee`)", -1, player, null)
	}

	if(activeMutators.find("ironCurtain") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `damage force reduction`, 0.01, 6)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `airblast vulnerability multiplier`, 0.01, 6)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `airblast vertical vulnerability multiplier`, 0.01, 6)", -1, player, null)
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `hidden maxhealth non buffed`, 200, 6)", -1, player, null)
		}
	}

	if(activeMutators.find("texasRangers") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `engy building health bonus`, 1.5, 9)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `engy sentry damage bonus`, 1.25, 9)", -1, player, null)
	}

	if(activeMutators.find("germanTechnology") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `ubercharge rate bonus`, 1.5, 5)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `uber duration bonus`, 4, 5)", -1, player, null)
	}

	if(activeMutators.find("australianRules") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `CARD: damage bonus`, 1.5, 2)", -1, player, null)
	}

	if(activeMutators.find("chateauBackstab") != null) {
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `dmg taken increased`, 0.35, 8)", -1, player, null)
		EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `fire rate bonus`, 0.7, 8)", -1, player, null)
	}

	if(activeMutators.find("deathWatch") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `health drain`, -5)", -1, player, null)
		}
	}

	if(activeMutators.find("deepWounds") != null) {
		if(!IsPlayerABot(player)) {
			EntFireByHandle(player, "RunScriptCode", "mutators.addAttributeOnSpawn(activator, `healing received penalty`, 0.5)", -1, player, null)
		}
	}
	
	if(activeMutators.find("allOutOffense") != null) { //might want a cleaner way of showing this?
		if(IsPlayerABot(player)) {
			//use entfire to ensure bot stuff is applied
			EntFireByHandle(player, "RunScriptCode", "mutators.allOutOffense(activator)", -1, player, null)
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
				- mutatorParams.allOrNothingPenalty
			player.RemoveCurrency(mutatorParams.allOrNothingPenalty)
		}
	}
	
	if(activeMutators.find("lastWhirr") != null) {
		if(player.GetTeam() == TF_TEAM_BLUE) {
			local victim = null
			
			while(victim = Entities.FindByClassnameWithin(victim, "player", player.GetCenter(), mutatorParams.lastWhirrRadius)) {
				if(victim.GetTeam() == TF_TEAM_RED) {
					local distance = (victim.GetCenter() - player.GetCenter()).Length()
					local shouldDamage = true
					printl("distance " + distance)
					DebugDrawCircle(player.GetCenter(), Vector(255, 0, 0), 127, mutatorParams.lastWhirrRadius, true, 1)
					
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
						local splash = distance / mutatorParams.lastWhirrReductionDistance
						local damage = mutatorParams.lastWhirrDmg * (1 - splash / 100)
						printl("damage " + damage)
						
						victim.TakeDamageEx(player, null, null, Vector(0, 0, 0), player.GetOrigin(), damage, DMG_BLAST)
					}
				}
			}
		}
	}
}

__CollectGameEventCallbacks(mutators)