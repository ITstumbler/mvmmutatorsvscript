//due to scoping issues, these need to be within player scopes
local scope = self.GetScriptScope()
scope.allOrNothingTotalPenalty = 0
scope.allOrNothingWavePenalty = 0

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
	else if(self.GetScriptScope().count > 50) {
		self.AddCondEx(TF_COND_STEALTHED_USER_BUFF, -1, null)
		delete self.GetScriptScope().funcs["guerillaWarfareOff"]
		self.GetScriptScope().funcs["guerillaWarfare"] <- guerillaWarfare
	}
	else {
		self.GetScriptScope().count++
	}
}