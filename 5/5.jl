function movements_to_side(r, side :: HorizonSide)
    count = 0
    while isborder(r,side) == false 
        move!(r,side)
        count = count + 1
    end
    return count
end

function ugol(r)

    home = Int[]

    while (isborder(r, Sud) == false) || (isborder(r, West) == false)
        s = movements_to_side(r, Sud)
        w = movements_to_side(r, West)
        push!(home, s)
        push!(home, w)
    end
    return home
end

function count_move!(r, side :: HorizonSide, count)

    for i = 1:count
        move!(r, side)
    end
end

function go_home(r, home)
    reverse!(home)

    for i in 1: length(home)
        if i % 2 == 0
            count_move(r, Nord, home[i])
        else
            count_move(r, Ost, home[i])
        end
    end 
end

function corners(r)

    home = Int[]
    home = ugol(r)

    for side in (Nord, Ost, Sud, West)
        movements_to_side!(r, side)
        putmarker!(r)
    end

    go_home(r,home)

end

corners(r)
show(r)