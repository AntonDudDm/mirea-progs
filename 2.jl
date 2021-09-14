function movements_mark!(r,side::HorizonSide)
    while (isborder(r,side) ==  false) && (ismarker(r) == false)
        putmarker!(r)
        move!(r,side)
    end 
end

function movements_to_side!(r,side::HorizonSide)

    while isborder(r,side) ==  false 
        move!(r,side)
    end 

end

function movements_to_zero!(r,side::HorizonSide, temp)

    while  temperature(r) != temp
        move!(r,side)
    end 
end

function kvadro(r)

    temp = 0
    temp = temperature(r)

    movements_to_side!(r,Ost)

    for side in [Sud, West, Nord, Ost, Sud]
        movements_mark!(r,side)
    end

    movements_to_zero!(r,West, temp)
    show(r)
end

kvadro(r)
show(r)