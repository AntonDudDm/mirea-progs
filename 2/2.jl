function movements_mark!(r,side::HorizonSide)
    while (isborder(r,side) ==  false) && (ismarker(r) == false)
        putmarker!(r)
        move!(r,side)
    end 
end

function movements_to_side!(r,side::HorizonSide)
    count = 0
    while isborder(r,side) ==  false 
        move!(r,side)
        count = count + 1
    end 
    return count
end

function movements_to_zero!(r, side::HorizonSide, count)

    for i = 1:count
        move!(r,side)
    end 
end

function kvadro!(r)

    count = movements_to_side!(r,Ost)

    for side in [Sud, West, Nord, Ost, Sud]
        movements_mark!(r,side)
    end

    movements_to_zero!(r, West, count)

end

kvadro!(r)
show(r)