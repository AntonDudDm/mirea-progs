
function revers(side :: HorizonSide)
    side = HorizonSide((Int(side)+2)%4)
    return side
end

function movements_to_side!(r, side :: HorizonSide)
    while isborder(r,side) == false 
        move!(r,side)
    end
end

function movements_find_temp!(r,side::HorizonSide, side_part :: HorizonSide)

    temp = 0
    count = 0

    while isborder(r,side_part) == false
        while isborder(r,side) ==  false 
            if ismarker(r)
                temp = temp + temperature(r)
                count = count + 1
            end
            move!(r,side)
        end 
        move!(r, side_part)
        side = revers(side)

        if ismarker(r)
            temp = temp + temperature(r)
            count = count + 1
        end

    end

    while isborder(r,side) ==  false 
        if ismarker(r)
            temp = temp + temperature(r)
            count = count + 1
        end
        move!(r,side)
    end 

    if ismarker(r)
        temp = temp + temperature(r)
        count = count + 1
    end

    return temp, count

end

function mid_temp(r)

    mid_temp = 0
    temp = 0
    count = 0

    temp, count = movements_find_temp!(r,Ost,Nord)
    
    movements_to_side!(r,Sud) #вернул его домой для порядка
    movements_to_side!(r,West)

    println(count)

    mid_temp = temp / count
    
    print(mid_temp)
end

mid_temp(r)
show(r)