function OnGameEvent_mvm_reset_stats(params) {
	local objResource = Entities.FindByName(null, "tf_objective_resource")
	if(NetProps.GetPropInt(objResource, "m_nMannVsMachineWaveCount") == 1) {
		//this currently allows rerolls at wave fail w1 / wave jump w1
		//alternative option is listening to a vote event + mission complete
		rollMutators()
	}
}