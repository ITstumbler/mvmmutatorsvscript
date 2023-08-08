//anything that doesn't need to be in player scope

::tripleBombs <- function() {
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

::sabotagedCircuits <- function() {
	local bluRespawn = null;
	
	//may need to check if this exists already
	while(bluRespawn = Entities.FindByClassname(bluRespawn, "func_respawnroom")) {
		if(bluRespawn.GetTeam() != TF_TEAM_BLUE) {
			continue;
		}
		EntityOutputs.AddOutput(bluRespawn, "OnEndTouch", "!activator", "RunScriptCode", "self.AddCondEx(71, 1, null)", 0, -1)
	}
}

::forcefulHeadstart <- function() {
	local bluRespawn = null;
	
	//make sure uber doesn't conflict with 51
	while(bluRespawn = Entities.FindByClassname(bluRespawn, "func_respawnroom")) {
		if(bluRespawn.GetTeam() != TF_TEAM_BLUE) {
			continue;
		}
		EntityOutputs.AddOutput(bluRespawn, "OnEndTouch", "!activator", "RunScriptCode", "self.AddCondEx(5, 3, null)", 0, -1)
	}
}

::acceleratedDevelopment <- function() {
	local flag = null

	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade", 5 * mutatorParams.acceleratedDevelopmentMultiplier)
	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade", 15 * mutatorParams.acceleratedDevelopmentMultiplier)
	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade", 15 * mutatorParams.acceleratedDevelopmentMultiplier)
	
	while(flag = Entities.FindByClassname(flag, "item_teamflag")) {
		EntityOutputs.AddOutput(flag, "OnPickup1", "!activator", "RunScriptCode", "acceleratedDevelopmentAddBuffs(self)", 0, -1)
	}
}

::acceleratedDevelopmentAddBuffs <- function(bot) {
	local objResource = Entities.FindByClassname(null, "tf_objective_resource")
	local lvl1 = Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade")
	
	if(!bot.HasBotAttribute(MINIBOSS)) {
		return
	}
	
	NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 0)
	NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
	NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() + lvl1)
	printl(Timer())
	printl(NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime"))
	
	objResource.ValidateScriptScope()
	objResource.GetScriptScope().Think <- function() {
		printl(NetProps.GetPropInt(self, "m_nFlagCarrierUpgradeLevel"))
		local nextUpgradeInterval = null;
		switch(NetProps.GetPropInt(self, "m_nFlagCarrierUpgradeLevel")) {
			case 0:
				if(Time() > NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")) {
					nextUpgradeInterval = Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade")
					
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 1)
					NetProps.SetPropFloat(self, "m_flMvMNextBombUpgradeTime", Time() + nextUpgradeInterval)
				}
				break;
			case 1:
				if(Time() > NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")) {
					nextUpgradeInterval = Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade")
					
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 2)
					NetProps.SetPropFloat(self, "m_flMvMNextBombUpgradeTime", Time() + nextUpgradeInterval)
				}
				break;
			case 2:
				if(Time() > NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime")) {
				
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 3)
				}
				break;
			default:
				break;
		}
	}
	AddThinkToEnt(objResource, "Think")
}

//and you need to store the total variable of extra cash collected in previous waves, this wave in global variables
//remove current wave cash upon wave fail and regive cash collected in previous waves