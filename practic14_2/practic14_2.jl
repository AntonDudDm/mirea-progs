include("lib_for_practic_10.jl")

function count_markers_in_labirint!(robot::CoordRobot)
    coord = (0,0)
    function recurs_for_labirint()
        coord = get_coord(get_coord(robot))
        if !(coord in set_coords)
            push!(set_coords, coord)
            if ismarker(robot)
                num_markers += 1
            end
            for side in (Nord, West, Sud, Ost) 
                if try_move!(robot, side)
                    recurs_for_labirint() 
                    move!(robot, inverse(side))
                end
            end
        end
    end

    set_coords = Set{NTuple{2,Int}}()
    num_markers = 0
    recurs_for_labirint()
    return num_markers
end

count_markers_in_labirint!(r)