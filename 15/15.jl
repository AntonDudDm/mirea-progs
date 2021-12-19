include("lib_for_practic_10.jl")
#r = Robot()
#r = BorderRobot{CoordRobot}(r)
#show!(r.robot)

function movements_mark!(r,side::HorizonSide)
    while (isborder(r,side) ==  false) && (ismarker(r) == false)
        putmarker!(r)
        move!(r,side)
    end 
end

function kvadro!(r)

    count = movements!(r,Ost)

    for side in [Sud, West, Nord, Ost, Sud]
        movements_mark!(r.robot,side)
    end

    movements!(r, West, count)

end

kvadro!(r)
show(r.robot)