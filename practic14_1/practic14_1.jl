include("lib_for_practic_10.jl")

function put_markers_in_labirint!(robot::CoordRobot)

    function recurs_for_labirint()
        coord = get_coord(get_coord(robot))
        if !(coord in set_coords)
            push!(set_coords, coord)
            putmarker!(robot)
            for side in (Nord, West, Sud, Ost) 
                if try_move!(robot, side)
                    recurs_for_labirint() 
                    move!(robot, inverse(side))
                end
            end
        end
    end

    set_coords = Set{NTuple{2,Int}}()
    recurs_for_labirint()
end

put_markers_in_labirint!(r)
show(r.robot)