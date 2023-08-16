::missionName <- null
::rerollMutators <- true

//on mutator -> non mutator = end

function OnGameEvent_mvm_reset_stats(params) {
	local objResource = Entities.FindByName(null, "tf_objective_resource")
	if(rerollMutators && NetProps.GetPropInt(objResource, "m_nMannVsMachineWaveCount") == 1) {
		//this should ignore wave jumping and wave fails
		rollMutators()
	}
	rerollMutators = true
}

function OnGameEvent_mvm_wave_failed(params) {
	rerollMutators = false
}

//Used by Divine Seal
function OnGameEvent_player_hurt(params) {

}
	
function OnGameEvent_player_spawn(params) {
	local player = GetPlayerFromUserID(params.userid)
	
	if(activeMutators.find("allOutOffense") != null) { //might want a cleaner way of showing this?
		if(IsPlayerABot(player)) {
			//use entfire to ensure bot stuff is applied
			EntFireByHandle(player, "RunScriptCode", "allOutOffense(activator)", -1, player, null)
		}
	}
}

function OnGameEvent_player_death(params) {

	//if(activateMutators.find(
}

function OnGameEvent_mvm_wave_complete(params) {
	if(activateMutators.find("allOrNothing") != null) {
		mutatorParams.totalAllOrNothingCurrency = mutatorParams.totalAllOrNothingCurrency + mutatorParams.waveAllOrNothingCurrency
	}
}

__CollectGameEventCallbacks(this)