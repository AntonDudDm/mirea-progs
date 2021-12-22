include("lib_for_practic_10.jl")

#r = Robot()
#r = BorderRobot{CoordRobot}(r)
 function border_movements!(r,side::HorizonSide, side_part :: HorizonSide)

    flag = false
    count = 0

    while isborder(r,side_part) == false
        while isborder(r,side) ==  false 
            move!(r,side)
            if (flag == false && isborder(r, side_part))
                flag = true
                count += 1
            elseif (flag == true && !isborder(r, side_part))
                flag = false
            end
        end 

        move!(r, side_part)
        side = inverse(side)
    end

    return count

end


function border_count(r)
    x = movements!(r,West)
    y = movements!(r,Sud)

    ans = border_movements!(r, Ost, Nord)

    movements!(r,West)
    movements!(r,Sud)
    movements!(r,Nord, y)
    movements!(r,Ost, x)

    println(ans)
end