//due to scoping issues, these need to be within player scopes
local scope = self.GetScriptScope()
scope.allOrNothingTotalPenalty <- 0
scope.allOrNothingWavePenalty <- 0

scope.thinkFunctions <- {}

function think() {
	foreach(key, func in thinkFunctions) {
		func()
	}
}

function guerillaWarfare() {
	//printl("guerilla")
	if(!self.InCond(TF_COND_STEALTHED_USER_BUFF)) {
		guerillaTimer <- Time() + mutators.mutatorParams.guerillaWarfare_delay
		delete thinkFunctions["guerillaWarfare"]
		thinkFunctions["guerillaWarfareOff"] <- guerillaWarfareOff
	}
}

function guerillaWarfareOff() {
	//printl("guerillaoff")
	if(NetProps.GetPropInt(self, "m_nButtons") & IN_ATTACK) { //attacking, reset the counter
		guerillaTimer = Time() + mutators.mutatorParams.guerillaWarfare_delay
	}
	else if(Time() >= guerillaTimer) {
		self.AddCondEx(TF_COND_STEALTHED_USER_BUFF, -1, null)
		delete thinkFunctions["guerillaWarfareOff"]
		thinkFunctions["guerillaWarfare"] <- guerillaWarfare
	}
}