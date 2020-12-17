local pawn = {}

function pawn:ReceiveBeginPlay()
    print("my pawn beging")
end

function pawn:ReceiveEndPlay(reason)
    print("pawn:ReceiveEndPlay")
end

function pawn:Tick(dt)
    print("pawn:Tick------------")
end

return pawn