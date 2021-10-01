function count_move!(r, side :: HorizonSide, count)
    for i = 1:count 
        move!(r,side)
    end 
end

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


function corner(r)
    x = 0
    y = 0
    while (isborder(r, Sud) == false) || (isborder(r, West) == false)
        y = y + movements_to_side!(r, Sud)
        x = x + movements_to_side!(r, West)
    end
    return x, y
end

function go_home!(r, x, y)
    corner(r)
    count_move!(r, Nord, y)
    count_move!(r, Ost, x)
end

function ladder(r)

    level = 1
    len = 0
    x = 0
    y = 0

    x, y = corner(r)

    len = move_mark_to_side!(r, Ost)
    movements_to_side!(r, West)

    while (isborder(r, Nord) == false)
        move!(r, Nord)
        move_count_mark!(r, Ost, level, len)
        movements_to_side!(r, West)
        level = level + 1
    end

    go_home!(r, x, y)
    
end

ladder(r)
show(r)