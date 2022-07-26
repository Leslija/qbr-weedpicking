Config = {}
Config.Collecting = {
    [1] = {
        ChanceToGetItem = 50,
        MaxItems = 30,
        ItemIn = 'wet_bud',
        ItemOut = 'dry_bud',
        Input = 5,
        Output = 1,
        Type = 'none',
        Duration = 7500,
        Dict = 'mech_pickup@treasure@rock_pile',
        Anim = 'pickup',
        Tool = 'none',
        Items = { 'wet_bud', 'wet_bud', 'wet_bud', 'wet_bud', 'wet_bud'},

        ----------------------------------------------------
        -- Process Wet Bud into Dry Bud
        Process = vector3(-5514.256, -2945.202, -1.976998),
        -- Pick Wet Bud Location
        Collect = vector3(1085.6975, -2724.771, 64.659927),
        ----------------------------------------------------

        -- Blips Info
        Csprite = 3392265860,
        Psprite = 1078668923,
        showBlip = true,
    },
    [2] = {
        ChanceToGetItem = 50,
        MaxItems = 30,
        ItemIn = 'dry_bud',
        ItemOut = 'weed_jar',
        Input = 5,
        Output = 1,
        Type = 'none',
        Duration = 7500,
        Dict = 'mech_pickup@treasure@rock_pile',
        Anim = 'pickup',
        Tool = 'none',
        Items = { 'wet_bud', 'wet_bud', 'wet_bud', 'wet_bud', 'wet_bud'},

        ----------------------------------------------------
        -- Process Dry Bud into Weed Jar
        Process = vector3(-5515.334, -3039.13, -2.387692),
        -- Unused
        Collect = vector3(1085.6975, -2724.771, 64.659927),
        ----------------------------------------------------

        -- Blips Info
        Csprite = 3392265860,
        Psprite = 1078668923,
        showBlip = true,
    },
    [3] = {
        ChanceToGetItem = 50,
        MaxItems = 30,
        ItemIn = 'weed_jar',
        ItemOut = 'joint',
        Input = 1,
        Output = 1,
        Type = 'none',
        Duration = 7500,
        Dict = 'mech_pickup@treasure@rock_pile',
        Anim = 'pickup',
        Tool = 'none',
        Items = { 'wet_bud', 'wet_bud', 'wet_bud', 'wet_bud', 'wet_bud'},

        ----------------------------------------------------
        -- Process Weed Jar into Joint
        Process = vector3(-5484.121, -2932.045, -0.402331),
        -- Unused
        Collect = vector3(1085.6975, -2724.771, 64.659927),
        ----------------------------------------------------

        -- Blips Info
        Csprite = 3392265860,
        Psprite = 1078668923,
        showBlip = true,
    },
}

-----------------------------------
-- Locations to Gather Wet Weed --
-----------------------------------
Config.GatherLocations = {
    { coords = vector3(324.80096, -2833.318, 94.130012), heading = 76.583999 },
    { coords = vector3(-2105.977, -3826.42, -18.0613), heading = 342.75576 },
    { coords = vector3(-2114.574, -3826.078, -17.9216), heading = 40.319446 },
    { coords = vector3(-2124.05, -3835.548, -17.92827), heading = 81.644523 },
    { coords = vector3(-2134.51, -3844.597, -17.9096), heading = 103.02643 },
    { coords = vector3(-2144.659, -3870.442, -18.1302), heading = 149.13034 },
    { coords = vector3(-2159.852, -3883.226, -18.13013), heading = 79.508117 },
    { coords = vector3(-2163.527, -3889.725, -18.13029), heading = 193.12399 },
}
