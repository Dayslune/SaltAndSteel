extends Node

func addModifier( toolData : PlayerStatsChange ):
	PlayerStats.powerIncreasePerKill += toolData.powerIncreasePerKill
	PlayerStats.wavePowerRewardIncreaseFlat += toolData.wavePowerRewardIncreaseFlat
	PlayerStats.wavePowerRewardIncreasePercent += toolData.wavePowerRewardIncreasePercent
	PlayerStats.wavePowerRewardMultiplier *= toolData.wavePowerRewardMultiplier
	PlayerStats.reduceShopCostPercent += toolData.reduceShopCostPercent
