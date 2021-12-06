function movements_mark!(r,side::HorizonSide)
    while (isborder(r,side) ==  false) && (ismarker(r) == true)
        move!(r,side)
    end 
end

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

function chess_line!(side, n, x, y, r)
    while isborder(r, side) == false
        move!(r, side)
        if side == Ost
            x = x + 1;
        else
            x = x - 1;
        end

        put!(r, x, y, n)

    end

    return x, y
end

function put!(r, x, y, n)
    if ((x ÷ n) + (y ÷ n)) % 2 == 0
        putmarker!(r)
    end
end


function chess(r, n)
    z = 0
    m = 0
    z, m = corner(r)

    side = Ost;
    x = 0;
    y = 0;

    if ((x ÷ n) + (y ÷ n)) % 2 == 0
        putmarker!(r)
    end

    while isborder(r,Nord) == false

        x, y = chess_line!(side, n, x, y, r)

        move!(r,Nord);
        y = y + 1;

        side = revers(side);

        put!(r, x, y, n)

    end

    x, y = chess_line!(side, n, x, y, r)

    go_home!(r, z, m)
    

end

n = 3

chess(r,n)
show(r)


#7 задача подсказка, сумма координат четна или нечетна