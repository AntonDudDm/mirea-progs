
function movements!(r, count, side)

    flag = true
    for i = 1:count
        if ismarker(r)
            flag = false
            return flag
        end
        move!(r,side)
    end
end

function corner(side :: HorizonSide)
    side = HorizonSide((Int(side)+1)%4)
    return side
end

function spiral(r)

    count = 1
    side :: HorizonSide = Nord
    
    while ismarker(r) == false

        flag = movements!(r, count, side)
        side = corner(side)
        if flag == true
            break
        end

        flag = movements!(r,count, side)
        side = corner(side)
        if flag == true
            break
        end

        count = count + 1
    end;

end

spiral(r)
show(r)