include("lib_for_practic_10.jl")

#r = Robot()
#r = BorderRobot{CoordRobot}(r)
#r = PutmarkersRobot{BorderRobot{Robot}}(r)
#show!(r.robot.robot)

function all_kvadro(r)

    x = movements!(r,West)
    y = movements!(r,Sud)
    snake!(r)

    movements!(r,West)
    movements!(r,Sud)
    movements!(r,Nord, y)
    movements!(r,Ost, x)
    
end

all_kvadro(r)
show(r.robot.robot)