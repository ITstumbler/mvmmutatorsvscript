//due to scoping issues, these need to be within player scopes

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
	if(self.GetScriptScope().count > 50) {
		self.AddCondEx(TF_COND_STEALTHED_USER_BUFF, -1, null)
		delete self.GetScriptScope().funcs["guerillaWarfareOff"]
		self.GetScriptScope().funcs["guerillaWarfare"] <- guerillaWarfare
	}
	else {
		self.GetScriptScope().count++
	}
}