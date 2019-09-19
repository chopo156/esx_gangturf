Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 255, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 25.0, Type = 3    -- default circle type, low draw distance due to indoors area
}

Config.GangNumberRequired = 0
Config.TimerBeforeNewRob    = 1800 -- The cooldown timer on a Turf after robbery was completed / canceled, in seconds

Config.MaxDistance    = 20   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveSocietyMoney = true -- give black money? If disabled it will give cash instead

Turfs = {
	["vanilla_unicorn"] = {
		position = { x = 93.48, y = -1292.12, z = 29.27 },
		reward = math.random(25000, 50000),
		nameOfTurf = "Gang Turf (Vanilla Unicorn)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0,
		isClaimed = "none"
	},
	["yellow_jack"] = {
		position = { x = 1994.20, y = 3046.72, z = 47.22 },
		reward = math.random(25000, 50000),
		nameOfTurf = "Gang Turf (Yellow Jack)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0,
		isClaimed = "none"
	},
	["tequila"] = {
		position = { x = -562.56, y = 283.94, z = 85.38 },
		reward = math.random(25000, 50000),
		nameOfTurf = "Gang Turf (Tequi-La)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0,
		isClaimed = "none"
	}
}
