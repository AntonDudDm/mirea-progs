function count_move!(r, side :: HorizonSide, count)
    for i = 1:count 
        move!(r,side)
    end 
end

function movements_mark!(r,side::HorizonSide, side_part :: HorizonSide)

    while isborder(r,side_part) == false
        while isborder(r,side) ==  false 
            putmarker!(r)
            move!(r,side)
        end 
        putmarker!(r)
        move!(r, side_part)
        side = revers(side)
    end

    while isborder(r,side) ==  false 
        putmarker!(r)
        move!(r,side)
    end 
    putmarker!(r)
end

function corner(r)
    x = 0
    y = 0
    while (isborder(r, Nord) == false) || (isborder(r, West) == false)
        y = y + movements_to_side!(r, Nord)
        x = x + movements_to_side!(r, West)
    end
    return x, y
end


function movements_to_side!(r,side::HorizonSide)
    count = 0
    while isborder(r,side) ==  false 
        move!(r,side)
        count = count + 1
    end 
    return count
end

function go_home!(r, x, y)
    corner(r)
    count_move!(r, Sud, y)
    count_move!(r, Ost, x)
end


function all_kvadro(r)
    x = 0;
    y = 0;
    x, y = corner(r)
    movements_mark!(r,Ost,Sud)
    go_home!(r, x ,y)
    
end

all_kvadro(r)
show(r)