return {
	schema = function()
		return {
			FinancialData = {
				MainCurrency = 0,
				MainCurrencyGained = 0,
				MainCurrencySpent = 0,
			},

			SessionsData = {
				SessionCount = 0, -- Number of times player has joined the server.
				LastJoin = 0,
				TimePlayed = 0, -- Total time played in seconds.
			},

			PurchaseData = {
				RobuxSpent = 0,
				PurchaseLog = {}
			}
		}
	end,

	replicatedFields = {
		FinancialData = true,
		SessionsData = true,
		PurchaseData = true
	}
}