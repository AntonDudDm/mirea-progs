include("lib_for_practic_10.jl")

r = Robot()
r = BorderRobot{Robot}(r)
r = PutmarkersRobot{BorderRobot{Robot}}(r)

function movements!(robot, side)::Integer
    n=0
    while try_move!(robot, side)
        n += 1
    end
    return n
end

function krest(r)
    
    n = 0
    for side in [Nord, Ost, Sud, West]
        n = movements!(r, side)
        movements!(r, HorizonSide((Int(side)+2)%4), n)
    end

end

krest(r)