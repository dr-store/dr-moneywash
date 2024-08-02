Config = {} -- If you need help ask here: https://discord.gg/XwMnwWdkbj

Config.MoneyLaundry = {
	NeedJob = true, -- Only people with the job can wash money ?
	Jobs = {'taxi', 'ambulance'}, -- Jobs that can wash money
	
	PedCode = 'g_m_m_armboss_01', -- Ped Model -- https://docs.fivem.net/docs/game-references/ped-models
	PedLocation = vector4(748.7151, -529.0323, 27.7779, 70.3816), -- Where ped will be at
	
	EnableBlip = true, -- Ped will be marked in Map
	BlipOnlyforJobs = true, -- Only people with jobs can see it

	MarkerText = 'Money Launderer',
	InteractText = 'Wash Money',
	MoneyLaunderer = 'Dealer',
	MoneyQuantity = 'Money Quantity',
	Description = 'How much money do you want to wash?',
	InvalidQuantity = 'Invalid quantity. Please enter a value between 1,000$ and 500,000$',
	TalkingtoDealer = 'Talking to Dealer',
	InvalidInput = "You don't have that amount of dirty money.",
	MoneyLaunderingCanceled = 'Money Laundering Canceled!',
	SuccessLaundry = 'You washed',
	Dollar = '$',

	BlipSprite = 500, -- https://docs.fivem.net/docs/game-references/blips/
	BlipDisplay = 4, -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928
	BlipScale = 1.0,  -- Scale of the Blip
	BlipColour = 11, -- https://docs.fivem.net/docs/game-references/blips/#blip-colors

	DefaultNumber = 1000, -- Default Amount to Wash
	LaundryMin = 1000, -- Minimum you can wash
	LaundryMax = 500000, -- Max you can wash

	LaundryTime = 5, -- in Seconds
	CleanLoss = 0.10, -- How much % of money will player lost in the money laundry (0.10 = 10%)
}