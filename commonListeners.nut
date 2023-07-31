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

__CollectGameEventCallbacks(this)