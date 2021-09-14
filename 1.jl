function movements!(r,side::HorizonSide)
    while isborder(r,side) ==  false 
        move!(r,side)
        putmarker!(r)
    end 
end

function movements_mark(r,side::HorizonSide)
    while ismarker(r) == true
        move!(r,side)
    end
end

function krest(r)

    for side in [Nord, Ost, Sud, West]
        movements!(r,side)
        movements_mark(r,HorizonSide((Int(side)+2)%4))
    end

    putmarker!(r)
    show(r)
end

krest(r)
show(r)