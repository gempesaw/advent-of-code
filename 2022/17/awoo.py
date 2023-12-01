import copy

with open("data", "r") as data:
    for t in data:
        Line = t.strip()
        InputString = Line

LenthInput = len(InputString)
#Y is front in this program
Rock1 = [(0,2), (0,3), (0,4), (0,5)]
Rock2 = [(0,3), (1,2), (1,3), (1,4), (2,3)]
Rock3 = [(0,2), (0,3), (0,4), (1,4), (2,4)]
Rock4 = [(0,2), (1,2), (2,2), (3,2)]
Rock5 = [(0,2), (0,3), (1,2), (1,3)]

RocksList = [Rock1, Rock2, Rock3, Rock4, Rock5]
Rocks = 0
Cycles = 0
HighestTowerPoint = -1
TowerSet = set()
LoopStartFound = False
CycleStart = False
while Rocks < 1000000000000:
    NewRockTemplate = RocksList[Rocks % 5]
    RockPositions = []
    for Y, X in NewRockTemplate:
        NewRockList = (Y+HighestTowerPoint+4, X)
        RockPositions.append(NewRockList)
    RockFalling = True
    while RockFalling:
        PotentialRockPosition = copy.deepcopy(RockPositions)
        if Cycles%LenthInput == 0:
            print("InputCycle", Rocks)
            #The loop will start after the input loops again but after the 10000th rock
            if Rocks > 10000:
                CycleStart = True
                print("CycleStartIdentified")
        if InputString[Cycles%LenthInput] == "<":
            XMovement = -1
        elif InputString[Cycles%LenthInput] == ">":
            XMovement = 1
        MovementCancelled = False
        for n, r in enumerate(PotentialRockPosition):
            Y, X = r
            NY, NX = Y, X+XMovement
            if NX < 0 or NX > 6 or (NY, NX) in TowerSet:
                MovementCancelled = True
                break
            PotentialRockPosition[n] = (NY, NX)
        if not(MovementCancelled):
            RockPositions = copy.deepcopy(PotentialRockPosition)
        Cycles += 1

        PotentialRockPosition2 = copy.deepcopy(RockPositions)
        DownMovementCancelled = False
        for n, r in enumerate(PotentialRockPosition2):
            Y, X = r
            NY, NX = Y-1, X
            if (NY, NX) in TowerSet or NY < 0:
                DownMovementCancelled = True
                break
            PotentialRockPosition2[n] = (NY, NX)
        if not(DownMovementCancelled):
            RockPositions = copy.deepcopy(PotentialRockPosition2)
        elif DownMovementCancelled:
            for Y, X in RockPositions:
                if Y > HighestTowerPoint:
                    HighestTowerPoint = Y
                TowerSet.add((Y,X))
            RockFalling = False
            Rocks += 1
            break
    if Rocks == 2022:
        Part1Answer = HighestTowerPoint + 1
        print(f"{LenthInput = }")
    if Rocks % 2000 == 0 and Rocks > 100:
        TowerCopy = TowerSet.copy()
        for Y,X in TowerCopy:
            if Y < HighestTowerPoint - 20:
                TowerSet.remove((Y,X))
    if Rocks > 10000 and CycleStart:
        if not(LoopStartFound):
            RockStart = Rocks % 5
            InputCycleStart = Cycles % LenthInput
            CycleTowerStart = HighestTowerPoint
            CycleRocksStart = Rocks
            LoopStartFound = True
            print("CycleStartPoint")
        elif LoopStartFound and Rocks % 5 == RockStart and Cycles % LenthInput == InputCycleStart:
            print("Cycle Found")
            CycleTowerLength = HighestTowerPoint - CycleTowerStart
            CycleRocksLength = Rocks - CycleRocksStart
            print(CycleRocksLength, CycleTowerLength)
            TowerCopy = TowerSet.copy()
            AddCycles = True
            OldTower = HighestTowerPoint
            NumAddCycles = (1000000000000 - Rocks) // CycleRocksLength
            Rocks = Rocks + (NumAddCycles*CycleRocksLength)
            HighestTowerPoint = HighestTowerPoint + (NumAddCycles*CycleTowerLength)
            TowerDifference = HighestTowerPoint - OldTower
            TowerSet.clear()
            for Y, X in TowerCopy:
                TowerSet.add((Y+TowerDifference, X))


Part2Answer = HighestTowerPoint + 1

print(Part2Answer)
