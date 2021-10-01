
function revers(side :: HorizonSide)
    side = HorizonSide((Int(side)+2)%4)
    return side
end

function movements_to_side!(r, side :: HorizonSide)

    while isborder(r,side) ==  false 
        move!(r,side)
    end 

end

function count_move!(r, side :: HorizonSide, count)
    for i = 1:count 
        move!(r,side)
    end 
end

function go_home(r, x, y, side_part :: HorizonSide, side :: HorizonSide)
    count_move!(r, side_part, y)
    count_move!(r, side, x)
end

function chess_move!(r, side :: HorizonSide, count)

    while isborder(r,side) ==  false 
        if count % 2 == 0
            putmarker!(r)
        end

        move!(r,side)
        count = count + 1
    end 

    if count % 2 == 0
        putmarker!(r)
    end

    return count
end

function part_chess(r, side_part :: HorizonSide, side :: HorizonSide)

    count = 0
    x = 0
    y = 0

    home = side
    flag = true

    while isborder(r,side_part) == false

        count = chess_move!(r, side, count)

        if flag
            x = count
            flag = false
        end

        move!(r, side_part)
        y = y + 1
        count = count + 1
        side = revers(side)

    end
    
    count = chess_move!(r, side, count)

    movements_to_side!(r, home)
    return x, y
end


function chess(r)

    x, y = part_chess(r, Sud, West)
    go_home(r, x, y, Nord, Ost)
    x, y = part_chess(r, Nord, Ost)
    go_home(r, x, y, Sud, West)

end

chess(r)
show(r)