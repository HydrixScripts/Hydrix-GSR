Config = {}

-- Time in seconds before GSR residue is automatically cleaned off
Config.GSRAutoClean = 60

-- Distance in meters for testing GSR on other players
Config.GSRTestDistance = 5.0

-- Chat command for forcing a GSR clean for all players (requires permission check)
Config.ForceCleanCommand = 'forcecleangs'

-- Restrict access to the force clean command to players with the permission above
Config.RestrictForceClean = true

-- Prefix for all GSR notifications
Config.NotificationPrefix = '^5[Sloth_GSR]^7 '

-- Debug mode (prints extra information to console)
Config.Debug = false
Perms = {
    restricted = true, -- Would you like to restrict the forceclean to a ace perm?
    forceperm = 'qbcore.god', -- Ace perm to be able to force clean
}
Logging = {
    enabled = true, -- Enable logging of forceclean
    webhook = '' -- Discord webhook URL
}


Config = {
    NotifySubject = true, -- Set this to false if you want the person being tested to get a chat notification that they are being tested
    EnableCleanGSR = true, -- Set this to false if you don't want people to be able to clean GSR off them
    GSRAutoClean = 900, -- (IN SECONDS) Amount Of Time Before GSR Auto Cleans [Default Is 15 Minutes]
    GSRTestDistance = 3, -- Maximum Distance That You Can Be To Test For GSR
    TestGSR = "gsr", -- Command To Test For GSR
    CleanGSR = "cleangsr", -- Command To Clean GSR
}

-- Table to store GSR data
GSRTab = {}
