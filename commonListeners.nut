mutators.missionName <- NetProps.GetPropString(objResource, "m_iszMvMPopfileName")

//runs before waveinit, so if we changed to a mutator mission it'll regen
function mutators::OnGameEvent_recalculate_holidays(params) {
	if(GetRoundState() == GR_STATE_PREROUND && missionName != NetProps.GetPropString(objResource, "m_iszMvMPopfileName")) {
		cleanup()
		delete ::mutators
	)
}

function mutators::OnGameEvent_mvm_mission_complete(params) {
	cleanup()
	delete ::mutators
}

function mutators::OnGameEvent_mvm_wave_failed(params) {
	if(activeMutators.find("allOrNothing") != null) {

	}
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
	
	if(activeMutators.find("allOutOffense") != null) { //might want a cleaner way of showing this?
		if(IsPlayerABot(player)) {
			//use entfire to ensure bot stuff is applied
			EntFireByHandle(player, "RunScriptCode", "allOutOffense(activator)", -1, player, null)
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