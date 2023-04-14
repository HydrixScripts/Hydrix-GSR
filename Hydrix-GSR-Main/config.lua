Config = {
    Config = {}

    -- Time in seconds before GSR residue is automatically cleaned off
    Config.GSRAutoClean = 60
    
    -- Distance in meters for testing GSR on other players
    Config.GSRTestDistance = 5.0
    
    -- Chat command for testing GSR on other players
    Config.TestGSRCommand = 'testgsr'
    
    -- Chat command for manually cleaning off GSR residue
    Config.CleanGSRCommand = 'cleargsr'
    
    -- Chat command for forcing a GSR clean for all players (requires permission check)
    Config.ForceCleanCommand = 'forcecleangs'
    
    -- Permission required to use the force clean command
    Config.ForceCleanPermission = 'gsr.forceclean'
    
    -- Restrict access to the force clean command to players with the permission above
    Config.RestrictForceClean = true
    
    -- Prefix for all GSR notifications
    Config.NotificationPrefix = '^5[Sloth_GSR]^7 '
    
    -- Debug mode (prints extra information to console)
    Config.Debug = false
    Perms = {
        restricted = true, -- Would you like to restrict the forceclean to a ace perm?
        forceperm = 'GSR:ForceClean', -- Ace perm to be able to force clean
    },
    Logging = {
        enabled = true, -- Enable logging of forceclean
        webhook = 'https://discord.com/api/webhooks/981008260771512400/no_mHnWnW19_R01gPMLM_RJzluX5eqgXevcWTNnKc0W4yWC6-lWZP5wLcx-APH_I8Hlw' -- Discord webhook URL
    },
}
