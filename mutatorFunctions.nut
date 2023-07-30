::tripleBombs <- function() {
	if(Entities.FindByName(null, "mutatorBomb1") != null) {
		return;
	}
	
	local mutatorBomb1 = SpawnEntityFromTable("item_teamflag", {
		name = "mutatorBomb1"
		//flag_icon = "/hud/objectives_flagpanel_carried"
		flag_model = "models/props_td/atom_bomb.mdl"
		gametype = 1
		returntime = 60000
		teamnum = 3
		returnbetweenwaves = 1
		origin = Entities.FindByClassname(null, "item_teamflag").GetOrigin()
	})
	
	local mutatorBomb2 = SpawnEntityFromTable("item_teamflag", {
		name = "mutatorBomb2"
		//flag_icon = "/hud/objectives_flagpanel_carried"
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

	if(!bot.HasBotAttribute(MINIBOSS)) {
		return
	}
	
	NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 0)
	NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
	NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() + 5)
	printl(NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime"))
}