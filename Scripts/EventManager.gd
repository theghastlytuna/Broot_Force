extends Node

signal onWaterCollected
signal onShowRockUI(layer : int)
signal rootStopMoving
signal rootStartMoving
signal onRockUIEnd
signal onEnterNewLayer(newLayer : int)
signal onAllySpawned(type : int)
signal onPlacedTower
signal onSelectedTowerToPlace
signal onTowersPlaced

signal onRootPhaseStart
signal onRootPhaseEnd
signal onGrowthPhaseStart
signal onGrowthPhaseEnd

signal onWaterChanged(newWater : float)

signal onHitRock
signal onSpawnedRock(node : Node2D)
signal onHitUnit
signal onSpawnedUnit(node : Node2D)
signal onHitWater
signal onSpawnedWater(node : Node2D)

signal onClickedOutsideUI

signal onCanopyClicked(towersToShow : Array, parent : Node2D)
signal onGroundClicked(towersToShow : Array,parent : Node2D)
