mutators.missionName <- null
mutators.rerollMutators <- true

//on mutator -> non mutator = end

function OnGameEvent_mvm_reset_stats(params) {
	if(mutators.rerollMutators && NetProps.GetPropInt(objResource, "m_nMannVsMachineWaveCount") == 1) {
		//this should ignore wave jumping and wave fails
		mutators.rollMutators()
	}
	mutators.rerollMutators = true
}

function OnGameEvent_mvm_wave_failed(params) {
	mutators.rerollMutators = false
}

//Used by Divine Seal
function OnGameEvent_player_hurt(params) {

}
	
function OnGameEvent_player_spawn(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	if(!(player.GetEntityIndex() in mutators.players)) { //if player is not in table
		mutators.players[player.GetEntityIndex()] <- player
		
		mutators.initPlayer(player)
		AddThinkToEnt(player, "think")
	}
	
	if(mutators.activeMutators.find("allOutOffense") != null) { //might want a cleaner way of showing this?
		if(IsPlayerABot(player)) {
			//use entfire to ensure bot stuff is applied
			EntFireByHandle(player, "RunScriptCode", "allOutOffense(activator)", -1, player, null)
		}
	}
}

function OnGameEvent_player_disconnect(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	delete mutators.players[player.GetEntityIndex()]
}

function OnGameEvent_player_death(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	//if(activeMutators.find(
	
	if(mutators.activeMutators.find("lastWhirr") != null) {
		if(player.GetTeam() == TF_TEAM_BLUE) {
			local victim = null
			
			while(victim = Entities.FindByClassnameWithin(victim, "player", player.GetCenter(), mutators.mutatorParams.lastWhirrRadius)) {
				if(victim.GetTeam() == TF_TEAM_RED) {
					local distance = (victim.GetCenter() - player.GetCenter()).Length()
					local shouldDamage = true
					printl("distance " + distance)
					DebugDrawCircle(player.GetCenter(), Vector(255, 0, 0), 127, mutators.mutatorParams.lastWhirrRadius, true, 1)
					
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
						local splash = distance / mutators.mutatorParams.lastWhirrReductionDistance
						local damage = mutators.mutatorParams.lastWhirrDmg * (1 - splash / 100)
						printl("damage " + damage)
						
						victim.TakeDamageEx(player, null, null, Vector(0, 0, 0), player.GetOrigin(), damage, DMG_BLAST)
					}
				}
			}
		}
	}
}

function OnGameEvent_mvm_wave_complete(params) {
	if(mutators.activeMutators.find("allOrNothing") != null) {
		mutators.mutatorParams.totalAllOrNothingCurrency = mutators.mutatorParams.totalAllOrNothingCurrency + mutators.mutatorParams.waveAllOrNothingCurrency
	}
}

__CollectGameEventCallbacks(this)