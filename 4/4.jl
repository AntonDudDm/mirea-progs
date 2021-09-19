function move_count_mark!(r,side::HorizonSide, level, len)
    for i in 1:(len - level)
        putmarker!(r)
        move!(r, side)
    end
    putmarker!(r)
end

function movements_to_side!(r,side::HorizonSide)
    count = 0
    while isborder(r,side) ==  false 
        move!(r,side)
        count = count + 1
    end 
    return count
end

function move_mark_to_side!(r,side::HorizonSide)

    count = 0

    while isborder(r,side) ==  false 
        putmarker!(r)
        move!(r,side)
        count = count + 1
    end 
    putmarker!(r)
    return count
end


function movements_to_zero!(r, ost_m, nord_m)

    movements_to_side!(r, West)
    movements_to_side!(r, Sud)

    for i = 1:nord_m
        move!(r,Nord)
    end
    for i = 1:ost_m
        move!(r,Ost)
    end

end

function ladder(r)

    level = 1
    len = 0

    ost_m = movements_to_side!(r, West)
    nord_m = movements_to_side!(r, Sud)

    len = move_mark_to_side!(r, Ost)
    movements_to_side!(r, West)

    while (isborder(r, Nord) == false)
        move!(r, Nord)
        move_count_mark!(r, Ost, level, len)
        movements_to_side!(r, West)
        level = level + 1
    end

    movements_to_zero!(r, ost_m, nord_m)
    
end

ladder(r)
show(r)