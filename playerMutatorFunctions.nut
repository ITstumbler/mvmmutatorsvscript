//due to scoping issues, these need to be within player scopes
local scope = self.GetScriptScope()
scope.allOrNothingTotalPenalty <- 0
scope.allOrNothingWavePenalty <- 0

function guerillaWarfare() {
	//printl("guerilla")
	if(!self.InCond(TF_COND_STEALTHED_USER_BUFF)) {
		self.GetScriptScope().count <- 0
		delete self.GetScriptScope().funcs["guerillaWarfare"]
		self.GetScriptScope().funcs["guerillaWarfareOff"] <- guerillaWarfareOff
	}
}

function guerillaWarfareOff() {
	const COUNTER = 50 //this assumes the main think runs at the default speed of .1s
	
	//printl("guerillaoff")
	//printl(self.GetScriptScope().count)
	if(NetProps.GetPropInt(self, "m_nButtons") & IN_ATTACK1) { //attacking, reset the counter
		self.GetScriptScope().count = 0
	}
	else if(self.GetScriptScope().count >= 50) {
		self.AddCondEx(TF_COND_STEALTHED_USER_BUFF, -1, null)
		delete self.GetScriptScope().funcs["guerillaWarfareOff"]
		self.GetScriptScope().funcs["guerillaWarfare"] <- guerillaWarfare
	}
	else {
		self.GetScriptScope().count++
	}
}

//name so it doesn't automatically get added to think
//does setup for the main think
function acceleratedDevelopmentHasBomb() {
	if(!self.HasBotAttribute(MINIBOSS)) {
		return
	}
	
	NetProps.SetPropString(self, "m_iName", self.GetEntityIndex().tostring())
	
	//once again this assume the default think of .1
	scope.upgradeTime <- Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade") / 0.1
	printl(upgradeTime)
	
	local targetName = UniqueString()
	local particleAttachment = SpawnEntityFromTable("info_target", {targetname = targetName})
	EntFire(targetName, "SetParent", self.GetEntityIndex().tostring(), -1)
	EntFire(targetName, "SetParentAttachment", "head", -1)
	
	scope.particleTarget <- particleAttachment
	scope.buffTimer <- null
	
	NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 0)
	NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
	NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() 
		+ Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_1st_upgrade"))
	
	scope.thinkFunctions["acceleratedDevelopmentThink"] <- scope["acceleratedDevelopmentThink"]
}

function acceleratedDevelopmentThink() {
	local navTile = self.GetLastKnownArea()
	
	if(navTile != null && navTile.HasAttributeTF(TF_NAV_SPAWN_ROOM_BLUE)) {
		//procrastinate ticking the timer
		//this may need reworked considering how this normally works
		printl("in spawnroom, haven't started timer")
		NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
		NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() 
			+ upgradeTime * 0.1)
		return;
	}
	
	//printl(Time())
	printl(NetProps.GetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime"))
	printl(NetProps.GetPropFloat(objResource, "m_flMvMNextBombUpgradeTime"))
	
	//if dead, stop this func
	if(NetProps.GetPropInt(self, "m_lifeState") != 0) {
		delete funcs["acceleratedDevelopmentThink"]
		delete buffTimer
		particleTarget.Kill()
		return;
	}
	
	if(upgradeTime <= 0) { //enough time has passed, time to upgrade
		local upgradeLevel = NetProps.GetPropInt(objResource, "m_nFlagCarrierUpgradeLevel")
		if(upgradeLevel < 3) {
			EntFire("tf_gamerules", "PlayVO", "MVM.Warning", -1)
		
			switch(upgradeLevel) {
				case 0:
					local nextUpgradeInterval = Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_2nd_upgrade")
					upgradeTime = nextUpgradeInterval / 0.1
					
					NetProps.SetPropEntity(tauntSandvich, "m_hOwner", self);
					tauntSandvich.PrimaryAttack();
					
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 1)
					NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
					NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() + nextUpgradeInterval)
					foreach(i, player in players) {
						EntFireByHandle(player, "SpeakResponseConcept", "TLK_MVM_BOMB_CARRIER_UPGRADE1", -1, null, null)
					}
					DispatchParticleEffect("mvm_levelup1", particleTarget.GetOrigin(), Vector(0, 0, 0))
					buffTimer = 10
					break;
				case 1:
					local nextUpgradeInterval = Convars.GetFloat("tf_mvm_bot_flag_carrier_interval_to_3rd_upgrade")
					upgradeTime = nextUpgradeInterval / 0.1
					
					NetProps.SetPropEntity(tauntSandvich, "m_hOwner", self);
					tauntSandvich.PrimaryAttack();
					
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 2)
					NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", Time())
					NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", Time() + nextUpgradeInterval)
					foreach(i, player in players) {
						EntFireByHandle(player, "SpeakResponseConcept", "TLK_MVM_BOMB_CARRIER_UPGRADE2", -1, null, null)
					}
					DispatchParticleEffect("mvm_levelup2", particleTarget.GetOrigin(), Vector(0, 0, 0))
					self.AddCustomAttribute("CARD: health regen", Convars.GetFloat("tf_mvm_bot_flag_carrier_health_regen"), -1)
					break;
				case 2:
					NetProps.SetPropEntity(tauntSandvich, "m_hOwner", self);
					tauntSandvich.PrimaryAttack();
				
					NetProps.SetPropInt(objResource, "m_nFlagCarrierUpgradeLevel", 3)
					NetProps.SetPropFloat(objResource, "m_flMvMBaseBombUpgradeTime", -1)
					NetProps.SetPropFloat(objResource, "m_flMvMNextBombUpgradeTime", -1)
					foreach(i, player in players) {
						EntFireByHandle(player, "SpeakResponseConcept", "TLK_MVM_BOMB_CARRIER_UPGRADE3", -1, null, null)
					}
					DispatchParticleEffect("mvm_levelup3", particleTarget.GetOrigin(), Vector(0, 0, 0))
					self.AddCond(TF_COND_CRITBOOSTED)
					break;
				default:
					break;
			}
		}
	}
	else {
		upgradeTime--
	}
	
	if(buffTimer != null) {
		if(buffTimer <= 0) {
			local player = null
			while(player = Entities.FindByClassnameWithin(player, "player", self.GetOrigin(), 450)) {
				if(player.GetTeam() == TF_TEAM_BLUE) {
					player.AddCondEx(TF_COND_DEFENSEBUFF_NO_CRIT_BLOCK, 1.1, null)
				}
			}
			buffTimer = 10
		}
		else {
			buffTimer--
		}
	}
}