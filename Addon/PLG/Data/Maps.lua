--------------------------------------------------------------------
-- PLG Data
--------------------------------------------------------------------

PLG.DB.UIMapIDs = {
    -- [areaID] = { "zone", UIMapID }
    [1]    = { "Dun Morogh", 1426 },
    [3]    = { "Badlands", 1418 },
    [4]    = { "Blasted Lands", 1419 },
    [8]    = { "Swamp of Sorrows", 1435 },
    [10]   = { "Duskwood", 1431 },
    [11]   = { "Wetlands", 1437 },
    [12]   = { "Elwynn Forest", 1429 },
    [14]   = { "Durotar", 1411 },
    [15]   = { "Dustwallow Marsh", 1445 },
    [16]   = { "Azshara", 1447 },
    [17]   = { "The Barrens", 1413 },
    [28]   = { "Western Plaguelands", 1422 },
    [33]   = { "Stranglethorn Vale", 1434 },
    [36]   = { "Alterac Mountains", 1416 },
    [38]   = { "Loch Modan", 1432 },
    [40]   = { "Westfall", 1436 },
    [41]   = { "Deadwind Pass", 1430 },
    [44]   = { "Redridge Mountains", 1433 },
    [45]   = { "Arathi Highlands", 1417 },
    [46]   = { "Burning Steppes", 1428 },
    [47]   = { "The Hinterlands", 1425 },
    [51]   = { "Searing Gorge", 1427 },
    [85]   = { "Tirisfal Glades", 1420 },
    [130]  = { "Silverpine Forest", 1421 },
    [139]  = { "Eastern Plaguelands", 1423 },
    [141]  = { "Teldrassil", 1438 },
    [148]  = { "Darkshore", 1439 },
    [206]  = { "Westfall", 1436 },
    [215]  = { "Mulgore", 1412 },
    [267]  = { "Hillsbrad Foothills", 1424 },
    [331]  = { "Ashenvale", 1440 },
    [357]  = { "Feralas", 1444 },
    [361]  = { "Felwood", 1448 },
    [400]  = { "Thousand Needles", 1441 },
    [405]  = { "Desolace", 1443 },
    [406]  = { "Stonetalon Mountains", 1442 },
    [440]  = { "Tanaris", 1446 },
    [490]  = { "Un'Goro Crater", 1449 },
    [493]  = { "Moonglade", 1450 },
    [618]  = { "Winterspring", 1452 },
    [1377] = { "Silithus", 1451 },
    [1497] = { "Undercity", 1458 },
    [1519] = { "Stormwind City", 1453 },
    [1537] = { "Ironforge", 1455 },
    [1637] = { "Orgrimmar", 1454 },
    [1638] = { "Thunder Bluff", 1456 },
    [1657] = { "Darnassus", 1457 },
    [2597] = { "Alterac Valley", 1459 },
}

function PLG:GetNameFromAreaID(areaID)
    return select(1,PLG.DB.UIMapIDs[areaID])
end

function PLG:GetMapIDFromAreaID(areaID)
    return select(2,PLG.DB.UIMapIDs[areaID])
end