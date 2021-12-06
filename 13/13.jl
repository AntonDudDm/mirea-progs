function revers(side :: HorizonSide)
    side = HorizonSide((Int(side)+2)%4)
    return side
end

function movements!(r,sides)

    last_side = nothing;
    pl_side = nothing;

    while (isborder(r, sides[1]) ==  false) && (isborder(r, sides[2]) ==  false)
        for side in sides
            if isborder(r,side) == false
                move!(r,side)
                pl_side = last_side
                last_side = side
            end
        end
        putmarker!(r)
    end 
    putmarker!(r)
    return revers(last_side), revers(pl_side)
end

function movements_mark(r, revers_sides)

    while ismarker(r) == true
        for side in revers_sides
            move!(r,side)
        end
    end
    
end

function krest(r)

    for sides in [ (Nord, Ost), (Sud, Ost), (Sud, West), (Nord, West) ]
        revers_sides = movements!(r,sides)
        print(revers_sides)
        movements_mark(r,revers_sides)
    end

    putmarker!(r)
    show(r)
end

krest(r)
show(r)