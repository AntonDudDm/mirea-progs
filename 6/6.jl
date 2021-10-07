
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

function home_path!(r)

    home = Int[]

    while (isborder(r, Nord) == false) || (isborder(r, West) == false)
        s = movements_to_side!(r, Nord)
        w = movements_to_side!(r, West)
        push!(home, s)
        push!(home, w)
    end
    return home
end

function go_home!(r, home)

    home_path!(r)

    reverse!(home)

    for i in 1: length(home)
        if i % 2 == 0
            count_move!(r, Sud, home[i])
        else
            count_move!(r, Ost, home[i])
        end
    end 
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
    home = Int[]

    home = home_path!(r)
    find(r)
    perimetr(r) 
    go_home!(r, home)

end

all_perimetr(r)
show(r)