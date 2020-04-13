--------------------------------------------------------------------
-- PLG Data
--------------------------------------------------------------------

-- recipeID is always ItemID.  
-- UseSpellID tells the addon to lookup the data for ItemID and request server data for spellID.
PLG.DB.Guide = {
	["Alchemy"] = { -- tested and updated 6/24/15
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {118,0,1,nil},
		[55]  = {858,0,0,nil},
		[85]  = {2459,0,0,858},
		[90]  = {3383,0,0,2459},
		[110] = {929,0,0,nil},
		[135] = {3385,0,0,nil},
		[145] = {3390,0,0,nil},
		[155] = {1710,0,0,45621},
		[175] = {3827,0,0,1710},
		[180] = {3825,0,0,3827},
		[185] = {8949,0,0,3825},
		[205] = {8951,0,0,nil},
		[215] = {3928,0,0,nil},
		[239] = {9149,0,1,nil},
		[240] = {9179,0,0,nil},
		[250] = {9233,0,0,3928},
		[270] = {13447,0,0,nil},
		[285] = {13446,0,0,nil},
		[300] = {75525,0,0,nil},
		[305] = {28100,0,0,28102},
		[315] = {22825,0,0,nil},
		[325] = {32067,0,0,34440},
		[335] = {22829,0,0,32067},
		[340] = {22832,0,0,nil},
		[350] = {39671,0,0,nil},
		[360] = {40067,0,0,nil},
		[365] = {40070,0,0,nil},
		[375] = {40195,0,0,nil},
		[380] = {40081,0,0,40195},
		[385] = {40073,0,0,nil},
		[395] = {39666,0,0,nil},
		[405] = {40093,0,0,nil},
		[415] = {33448,0,0,41163},
		[422] = {33448,0,0,109123},
		[425] = {67415,0,0,nil},
		[450] = {58084,0,0,nil},
		[455] = {58142,0,0,nil},
		[460] = {58091,0,0,nil},
		[465] = {58092,0,0,nil},
		[475] = {58093,0,0,nil},
		[480] = {58094,0,0,57192},
		[490] = {58146,0,0,nil},
		[495] = {57191,0,0,nil},
		[500] = {76094,0,0,76097},
		[520] = {51950,0,0,76094},
		[530] = {76075,0,0,109123},
		[545] = {76089,0,0,109123},
		[575] = {76098,0,0,109123},
		[600] = {109148,0,1,118700},
		[650] = {109148,0,1,108996},
		--{},
	}, 
	["Blacksmithing"] = { 
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {2862,0,0,nil},
		[30]  = {3470,0,1,nil},
		[65]  = {2851,0,0,nil},
		[75]  = {3478,0,0,nil},
		[90]  = {2857,0,0,nil},
		[110] = {3480,0,0,nil},
		[125] = {3486,0,1,nil},
		[140] = {3480,0,0,nil},
		[145] = {2868,0,0,19667},
		[155] = {3842,0,0,nil},
		[165] = {3835,0,0,nil},
		[190] = {6040,0,0,nil},
		[200] = {7964,0,0,nil},
		[210] = {7919,0,0,nil},
		[225] = {7924,0,0,7920},
		[235] = {7931,0,0,nil},
		[250] = {12404,0,0,nil},
		[260] = {12408,0,0,nil},
		[275] = {12425,0,0,nil},
		[290] = {12409,0,0,12410},
		[300] = {28420,0,0,nil},
		[305] = {23484,0,0,nil},
		[315] = {23491,0,0,nil},
		[320] = {23487,0,0,nil},
		[325] = {23559,0,0,nil},
		[330] = {23489,0,0,nil},
		[335] = {23503,0,0,nil},
		[340] = {23575,0,0,nil},
		[350] = {39088,0,0,nil},
		[360] = {40668,0,0,nil},
		[370] = {39086,0,0,nil},
		[375] = {41975,0,0,nil},
		[380] = {40949,0,0,nil},
		[385] = {40950,0,0,nil},
		[390] = {41243,0,0,41117},
		[395] = {43860,0,0,nil},
		[400] = {40955,0,0,nil},
		[405] = {41128,0,0,nil},
		[415] = {41114,0,0,nil},
		[420] = {41976,0,0,nil},
		[425] = {65365,0,1,nil},
		[455] = {54852,0,0,nil},
		[459] = {55034,0,0,nil},
		[462] = {55027,0,0,55035},
		[470] = {55246,0,0,nil},
		[475] = {55053,0,0,nil},
		[480] = {55038,0,0,nil},
		[489] = {55045,0,0,nil},
		[494] = {55039,0,0,55023},
		[500] = {82960,0,0,nil},
		[501] = {82908,0,0,nil},
		[526] = {82910,0,0,82906},
		[532] = {82909,0,0,nil},
		[544] = {82961,0,0,nil},
		[549] = {82962,0,0,nil},
		[559] = {82903,0,0,82905},
		[569] = {82904,0,0,nil},
		[575] = {82950,0,0,82949},
		[600] = {118720,0,1,116428},
		[650] = {116428,0,0,116654},
	},
	["Cooking"] = { -- tested and updated 6/4/15
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {2679,0,0,nil},
		[30]  = {2680,0,0,nil},
		[50]  = {5525,0,0,nil},
		[90]  = {2683,0,0,nil},
		[115] = {2683,0,0,6657},
		[130] = {3665,0,0,nil},
		[170] = {3727,0,0,3665},
		[175] = {12210,0,0,nil},
		[225] = {12218,0,0,nil},
		[250] = {35565,0,0,nil},
		[285] = {20452,0,0,nil},
		[300] = {27655,0,0,nil},
		[325] = {27660,0,0,nil},
		[350] = {34747,0,0,nil},
		[365] = {34752,0,0,nil},
		[375] = {39520,0,0,81408},
		[390] = {39520,0,0,81413},
		[400] = {42995,0,0,43001},
		[415] = {62790,0,0,nil},
		[431] = {62676,0,0,62790},
		[435] = {62676,0,0,81410},
		[450] = {62651,0,0,62654},
		[465] = {62651,0,0,81411},
		[475] = {62660,0,0,62659},
		[490] = {62660,0,0,81409},
		[495] = {62660,0,0,81414},
		[500] = {62663,0,0,62668},
		[520] = {86069,0,0,nil},
		[530] = {74642,0,0,nil},
		[550] = {74645,0,0,nil},
		[576] = {87226,0,0,nil},
		[600] = {111439,0,1,111438},
		[650] = {111447,0,0,111438},
		[675] = {111458,0,0,122346},
	},
	["Enchanting"] = { 
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {6218,0,0,nil},
		[2]   = {38679,0,0,nil},
		[90]  = {38771,0,0,nil},
		[100] = {11288,0,0,nil},
		[110] = {38789,0,0,nil},
		[135] = {38793,0,0,nil},
		[155] = {38797,0,0,38809},
		[185] = {38817,0,0,nil},
		[220] = {38825,0,0,nil},
		[225] = {38827,0,0,nil},
		[230] = {38830,0,0,nil},
		[235] = {38833,0,0,nil},
		[240] = {45628,0,0,nil},
		[250] = {20747,0,0,nil},
		[260] = {38852,0,0,nil},
		[265] = {38861,0,0,nil},
		[300] = {38938,0,0,nil},
		[310] = {38897,0,0,nil},
		[320] = {38934,0,0,38928},
		[330] = {38945,0,0,nil},
		[335] = {38949,0,0,nil},
		[340] = {22522,0,0,nil},
		[350] = {44456,0,0,nil},
		[375] = {38971,0,0,38960},
		[390] = {89738,0,0,38986},
		[396] = {89738,0,0,38959},
		[405] = {38951,0,0,nil},
		[411] = {38953,0,0,nil},
		[423] = {44457,0,0,38962},
		[426] = {52743,0,0,52744},
		[440] = {52745,0,0,nil},
		[455] = {52749,0,0,nil},
		[465] = {52753,0,0,52751},
		[475] = {52756,0,0,52758},
		[480] = {52757,0,0,nil},
		[485] = {52759,0,0,nil},
		[490] = {52762,0,0,nil},
		[495] = {52766,0,0,nil},
		[500] = {74700,0,0,nil},
		[526] = {74716,0,0,74701},
		[550] = {74710,0,0,nil},
		[556] = {74709,0,0,74720},
		[577] = {74708,0,0,74722},
		[600] = {119293,0,1,112160},
		[650] = {112160,0,0,112115},
	},
	["Engineering"] = { 
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {4357,0,1,nil},
		[30]  = {4359,0,1,nil},
		[50]  = {6219,0,1,nil},
		[51]  = {4360,0,0,nil},
		[75]  = {4364,0,1,nil},
		[90]  = {4365,0,0,nil},
		[100] = {6712,0,0,nil},
		[116] = {4371,0,0,nil},
		[120] = {4406,0,0,nil},
		[132] = {4377,0,1,nil},
		[140] = {4375,0,1,nil},
		[150] = {4382,0,1,nil},
		[160] = {4384,0,0,nil},
		[175] = {10498,0,0,nil},
		[176] = {10505,0,1,nil},
		[195] = {10559,0,0,nil},
		[200] = {10560,0,1,nil},
		[215] = {10561,0,1,nil},
		[238] = {10562,0,0,nil},
		[250] = {15992,0,0,nil},
		[260] = {15994,0,0,nil},
		[281] = {16000,0,0,nil},
		[300] = {23783,0,1,23781},
		[320] = {23736,0,0,nil},
		[325] = {23737,0,0,nil},
		[335] = {23768,0,0,nil},
		[350] = {39681,0,1,39690},
		[370] = {39690,0,1,nil},
		[375] = {39682,0,1,nil},
		[385] = {40536,0,0,nil},
		[390] = {39683,0,1,nil},
		[400] = {44739,0,0,nil},
		[405] = {44951,0,0,nil},
		[410] = {37567,0,0,nil},
		[420] = {40865,0,0,nil},
		[425] = {60224,0,1,nil},
		[442] = {67494,0,0,nil},
		[445] = {67749,0,1,nil},
		[460] = {59595,0,0,59596},
		[470] = {60223,0,0,nil},
		[475] = {60217,0,0,60218},
		[495] = {60403,0,0,nil},
		[500] = {77467,0,0,77468},
		[550] = {90146,0,0,nil},
		[554] = {77530,0,0,nil},
		[579] = {90146,0,0,nil},
		[580] = {87213,0,0,77529},
		[600] = {118007,0,0,118006},
		[624] = {109184,0,0,nil},
		[628] = {119299,0,0,109171},
		[650] = {109171,0,0,nil},
	},
	["First Aid"] = { -- tested and updated 6/4/15
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {1251,0,0,nil},
		[40]  = {2581,0,0,nil},
		[80]  = {3530,0,0,nil},
		[115] = {3531,0,0,nil},
		[130] = {3531,0,0,6453},
		[151] = {6450,0,0,nil},
		[180] = {6451,0,0,nil},
		[210] = {8544,0,0,nil},
		[240] = {8545,0,0,nil},
		[260] = {14529,0,0,nil},
		[290] = {14530,0,0,nil},
		[300] = {21990,0,0,nil},
		[330] = {21991,0,0,nil},
		[350] = {34721,0,0,nil},
		[390] = {34722,0,0,nil},
		[425] = {53049,0,0,nil},
		[475] = {53050,0,0,nil},
		[500] = {72985,0,0,nil},
		[550] = {72986,0,0,nil},
		[600] = {111603,0,0,nil},
		[625] = {116979,0,0,nil},
		[650] = {109223,0,0,nil},
	},
	["Inscription"] = { 		
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {39469,0,1,nil},
		[60]  = {9999001,1,0,nil},
		[76]  = {39774,0,1,nil},
		[80]  = {9999001,1,0,nil},
		[86]  = {43115,0,0,nil},
		[90]  = {43515,0,0,37168},
		[95]  = {9999001,1,0,nil},
		[101] = {43116,0,1,nil},
		[105] = {9999002,1,0,nil},
		[126] = {43117,0,1,nil},
		[130] = {9999002,1,0,nil},
		[145] = {43655,0,0,44142},
		[150] = {43118,0,1,nil},
		[155] = {9999003,1,0,nil},
		[177] = {43656,0,0,44161},
		[185] = {9999003,1,0,nil},
		[200] = {43120,0,1,nil},
		[205] = {9999004,1,0,nil},
		[226] = {43661,0,0,44163},
		[233] = {9999004,1,0,nil},
		[251] = {43122,0,1,nil},
		[255] = {9999005,1,0,nil},
		[279] = {43123,0,0,nil},
		[287] = {43663,0,0,nil},
		[292] = {43124,0,1,nil},
		[305] = {9999006,1,0,nil},
		[326] = {43667,0,0,nil},
		[333] = {9999006,1,0,nil},
		[351] = {43126,0,1,nil},
		[355] = {9999007,1,0,nil},
		[390] = {9999008,1,0,nil},
		[426] = {61978,0,1,nil},
		[445] = {9999009,1,0,nil},
		[475] = {61981,0,1,nil},
		[482] = {9999009,1,0,nil},
		[500] = {79254,0,1,79255},
		[540] = {9999010,1,0,nil},
		[600] = {119297,0,1,nil},
		[650] = {113270,0,0,111526},
		--{0,},
	},
	["Jewelcrafting"] = {
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {20816,0,1,nil},
		[30]  = {25439,0,0,25438},
		[50]  = {20817,0,1,nil},
		[80]  = {20820,0,0,20823},
		[100] = {20828,0,0,20827},
		[110] = {25881,0,0,nil},
		[120] = {20950,0,0,nil},
		[150] = {20963,0,1,nil},
		[180] = {25882,0,0,nil},
		[185] = {20960,0,0,nil},
		[200] = {20960,0,0,20961},
		[220] = {21755,0,0,nil},
		[225] = {21752,0,0,nil},
		[250] = {21764,0,0,nil},
		[260] = {21767,0,0,30422},
		[280] = {30422,0,0,nil},
		[287] = {21790,0,0,29159},
		[290] = {29159,0,0,29160},
		[300] = {23095,0,0,45054},
		[320] = {23095,0,0,23104},
		[325] = {31079,0,1,23105},
		[335] = {23100,0,0,23116},
		[340] = {24078,0,0,nil},
		[350] = {36917,0,0,36932},
		[395] = {42336,0,0,43244},
		[400] = {43248,0,0,43249},
		[420] = {42340,0,0,nil},
		[425] = {52306,0,0,nil},
		[450] = {52308,0,0,nil},
		[467] = {52308,0,0,52492},
		[475] = {52309,0,0,52493},
		[500] = {83793,0,0,nil},
		[512] = {83793,0,0,83794},
		[527] = {76514,0,0,76544},
		[575] = {93409,0,0,83141},
		[585] = {90401,0,0,nil},
		[588] = {76637,0,0,76697},
		[600] = {118723,0,0,115804},
		[650] = {115804,0,0,115806},
	},
	["Leatherworking"] = {	
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {2318,0,1,2304},
		[20]  = {2304,0,0,nil},
		[30]  = {7276,0,0,nil},
		[50]  = {4237,0,0,nil},
		[55]  = {4239,0,0,nil},
		[85]  = {4246,0,1,nil},
		[100] = {4233,0,1,2313},
		[115] = {2315,0,0,nil},
		[130] = {4249,0,0,2316},
		[145] = {4247,0,0,nil},
		[150] = {4234,0,0,nil},
		[155] = {4236,0,0,4265},
		[165] = {4265,0,0,nil},
		[180] = {5964,0,0,nil},
		[190] = {5966,0,0,nil},
		[200] = {8173,0,0,nil},
		[205] = {8176,0,0,nil},
		[235] = {8193,0,0,nil},
		[250] = {15564,0,0,nil},
		[265] = {15084,0,0,15071},
		[290] = {15086,0,0,nil},
		[300] = {21887,0,1,nil},
		[310] = {25650,0,0,nil},
		[325] = {23793,0,1,nil},
		[335] = {25671,0,0,nil},
		[340] = {25659,0,0,nil},
		[350] = {33568,0,1,38375},
		[380] = {38404,0,0,nil},
		[390] = {38425,0,0,nil},
		[405] = {44436,0,0,44440},
		[420] = {43264,0,0,nil},
		[425] = {52976,0,1,nil},
		[435] = {56477,0,0,nil},
		[450] = {56494,0,0,nil},
		[460] = {56480,0,0,nil},
		[470] = {56491,0,0,nil},
		[475] = {56495,0,0,56502},
		[480] = {56509,0,0,56503},
		[485] = {56516,0,1,nil},
		[490] = {56513,0,0,nil},
		[496] = {56518,0,0,nil},
		[499] = {56505,0,0,nil},
		[500] = {72120,0,1,nil},
		[526] = {85833,0,0,nil},
		[536] = {85832,0,0,85842},
		[540] = {85839,0,0,85845},
		[550] = {85836,0,0,85848},
		[560] = {85838,0,0,85846},
		[564] = {85837,0,0,85844},
		[570] = {85818,0,0,85794},
		[600] = {118721,0,1,110611},
		[650] = {110611,0,0,116170},
	},
	["Tailoring"] = {	
		-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
		[1]   = {2996,0,1,nil},
		[45]  = {4307,0,0,nil},
		[70]  = {2580,0,0,nil},
		[75]  = {2997,0,1,nil},
		[100] = {10047,0,0,nil},
		[110] = {4314,0,0,nil},
		[125] = {4305,0,1,nil},
		[145] = {7048,0,0,nil},
		[160] = {7050,0,0,nil},
		[170] = {4334,0,0,nil},
		[175] = {4339,0,1,nil},
		[185] = {7058,0,0,nil},
		[200] = {7062,0,0,nil},
		[205] = {9999,0,0,nil},
		[215] = {10056,0,0,nil},
		[220] = {10003,0,0,nil},
		[230] = {10024,0,0,nil},
		[250] = {14048,0,1,nil},
		[260] = {13856,0,0,nil},
		[280] = {13863,0,0,nil},
		[295] = {13866,0,0,nil},
		[300] = {21840,0,1,nil},
		[325] = {21841,0,0,nil},
		[330] = {21852,0,0,nil},
		[335] = {21853,0,0,nil},
		[345] = {21855,0,0,nil},
		[350] = {41510,0,1,nil},
		[375] = {41522,0,0,nil},
		[380] = {41520,0,0,nil},
		[385] = {41521,0,0,nil},
		[395] = {41543,0,0,nil},
		[400] = {41511,0,1,41548},
		[405] = {41551,0,0,nil},
		[410] = {41545,0,0,nil},
		[415] = {41593,0,0,41594},
		[425] = {53643,0,1,nil},
		[450] = {54473,0,0,nil},
		[455] = {54477,0,0,nil},
		[460] = {54472,0,0,nil},
		[465] = {54476,0,0,nil},
		[470] = {54481,0,0,nil},
		[475] = {54482,0,0,nil},
		[480] = {54483,0,0,nil},
		[484] = {54443,0,0,54445},
		[494] = {54486,0,0,nil},
		[500] = {82441,0,1,nil},
		[535] = {82400,0,0,82398},
		[547] = {82403,0,0,nil},
		[550] = {92960,1,0,nil},
		[555] = {82434,0,0,82444},
		[600] = {118722,0,1,111556},
		[650] = {114836,0,0,111556},
	},
}