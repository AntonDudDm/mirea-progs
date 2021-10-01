
function revers(side :: HorizonSide)
    side = HorizonSide((Int(side)+2)%4)
    return side
end

function movements!(r, count, side, out_side)

    flag = true
    for i = 1:count
        if isborder(r, out_side) == false
            flag = false
            return flag
        end
        move!(r,side)
    end
end

function find_out(r)

    count = 1
    flag = true

    out_side :: HorizonSide = Nord
    side :: HorizonSide = Ost
    
    while flag != false

        flag = movements!(r,count, side, out_side)

        side = revers(side)

        count = count + 1

    end;

end

find_out(r)
show(r)