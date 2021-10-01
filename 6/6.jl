
function revers(side :: HorizonSide)
    side = HorizonSide((Int(side)+2)%4)
    return side
end

function count_move!(r, side :: HorizonSide, count)
    for i = 1:count 
        move!(r,side)
    end 
end

function movements_to_side!(r, side :: HorizonSide)
    count = 0
    while isborder(r,side) ==  false 
        move!(r,side)
        count = count + 1
    end 
    return count
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

function go_home!(r, x, y)
    corner(r)
    count_move!(r, Sud, y)
    count_move!(r, Ost, x)
end

function find_move!(r, side :: HorizonSide, border_side :: HorizonSide)
    while (isborder(r,side) ==  false) && (isborder(r,border_side) ==  false)
        move!(r,side)
    end 
    return isborder(r,border_side)
end

function find(r)

    side = Sud
    border_side = Ost
    flag = false

    while flag != true
        flag = find_move!(r, side, border_side);
        if flag
            break
        end
        move!(r,Ost)
        side = revers(side)
    end

end

function perimetr(r)

    for side in [Nord, Ost, Sud, West]
        putmarker!(r)
        move!(r, side)
        while isborder(r, HorizonSide((Int(side)+3)%4)) == true 
            putmarker!(r)
            move!(r, side)
        end
    end

    while ismarker(r) ==  false
        putmarker!(r)
        move!(r,Nord)
    end

end

function all_perimetr(r)
    x = 0
    y = 0
    x, y = corner(r)
    find(r)
    perimetr(r) 
    go_home!(r, x, y)

end

all_perimetr(r)
show(r)

#7 задача подсказка, сумма координат четна или нечетна