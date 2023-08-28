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
		EntityOutputs.AddOutput(bluRespawn, "OnEndTouch", "!activator", "RunScriptCode", "self.AddCondEx(71, "+mutatorParams.sabotagedCircuits_duration+", null)", 0, -1)
	}
}

::forcefulHeadstart <- function() {
	local bluRespawn = null;
	
	//make sure uber doesn't conflict with 51
	while(bluRespawn = Entities.FindByClassname(bluRespawn, "func_respawnroom")) {
		if(bluRespawn.GetTeam() != TF_TEAM_BLUE) {
			continue;
		}
		EntityOutputs.AddOutput(bluRespawn, "OnEndTouch", "!activator", "RunScriptCode", "self.AddCondEx(5, "+mutatorParams.forcefulHeadstart_duration+", null)", 0, -1)
	}
}

::allOutOffense <- function(bot) {
	if(bot.HasBotAttribute(ALWAYS_CRIT)) {
		bot.AddCustomAttribute("CARD: damage bonus", 2, -1)
	}
	else {
		bot.AddBotAttribute(ALWAYS_CRIT)
		bot.SetHealth(bot.GetMaxHealth() / 2)
		bot.SetMaxHealth(bot.GetMaxHealth() / 2)
		//NetProps.SetPropInt(bot, "m_iMaxHealth", bot.GetMaxHealth() / 2)
		
		printl(bot.GetMaxHealth())
	}
}

::allOrNothing <- function() {
	
}

::acceleratedDevelopment <- function() {
	local flag = null

	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade", 5 * mutatorParams.acceleratedDevelopment_multiplier)
	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade", 15 * mutatorParams.acceleratedDevelopment_multiplier)
	Convars.SetValue("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade", 15 * mutatorParams.acceleratedDevelopment_multiplier)
	
	while(flag = Entities.FindByClassname(flag, "item_teamflag")) {
		EntityOutputs.AddOutput(flag, "OnPickup1", "!activator", "RunScriptCode", "acceleratedDevelopmentHasBomb()", 0, -1)
	}
}

//and you need to store the total variable of extra cash collected in previous waves, this wave in global variables
//remove current wave cash upon wave fail and regive cash collected in previous waves