function movements_to_side(r, side :: HorizonSide)
    count = 0
    while isborder(r,side) == false 
        move!(r,side)
        count = count + 1
    end
    return count
end

function ugol(r)

    count_s_n = 0
    count_w_o = 0
    home = Int[]

    while (isborder(r, Sud) == false) || (isborder(r, West) == false)
        s = movements_to_side(r, Sud)
        w = movements_to_side(r, West)
        count_s_n = count_s_n + s
        count_w_o = count_w_o + w
        push!(home, s)
        push!(home, w)
    end
    return home, count_s_n, count_w_o
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
            count_move!(r, Nord, home[i])
        else
            count_move!(r, Ost, home[i])
        end
    end 
end

function Crest(r)

    home = Int[]
    home, count_s_n , count_w_o = ugol(r)

    for side in (Nord, Ost, Sud, West)
        if (side == Nord) || (side == Sud)
            count_move!(r, side, count_s_n)
            putmarker!(r)
            count_s_n = movements_to_side(r,side)
        else 
            count_move!(r, side, count_w_o)
            putmarker!(r)
            count_w_o = movements_to_side(r,side)
        end  
    end
    go_home(r,home)

end

Crest(r)
show(r)