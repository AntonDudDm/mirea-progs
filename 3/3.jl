function movements_mark!(r,side::HorizonSide)
    flag = true

    while (isborder(r,side) ==  false) && (flag == true)

        move!(r,side)

        if (ismarker(r) == false)
            putmarker!(r)
        else
            flag = false 
        end
    end

    if flag == false 
        movements_to_side!(r,side)
        return flag
    end


end

function movements_one!(r,side::HorizonSide)
    if (isborder(r,side) ==  false)
        move!(r,side)
        putmarker!(r)
    else  
        return false 
    end
end

function movements_to_side!(r,side::HorizonSide)

    while isborder(r,side) ==  false 
        move!(r,side)
    end 

end


function movements_to_zero!(r,side::HorizonSide, temp, home::HorizonSide)

    while (isborder(r,home) ==  false)
        move!(r,home)
    end

    while (isborder(r,side) ==  false) && (ismarker(r) == true)
        move!(r,side)
    end

    while  (temperature(r) != temp) && (isborder(r,HorizonSide((Int(home)+2)%4)) ==  false)
        putmarker!(r)
        move!(r,HorizonSide((Int(home)+2)%4))
    end 
end

function all_kvadro(r)

    putmarker!(r)

    temp = 0
    temp = temperature(r) #исходная точка

    flag = true

    movements_to_side!(r,Nord)
    movements_to_side!(r,West)
    side = Sud
    home = Nord

    putmarker!(r)

    while flag != false

        flag_h = movements_mark!(r,side)

        if flag_h == false 
            home = side
        end

        flag = movements_one!(r,Ost)
        side = HorizonSide((Int(side)+2)%4)
    end

    putmarker!(r)

    movements_to_zero!(r,West,temp,home)

    show(r)
end

all_kvadro(r)
show(r)