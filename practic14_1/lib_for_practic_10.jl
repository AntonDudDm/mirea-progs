using HorizonSideRobots

#--------- ИСПОЛЬЗУЕМЫЕ "БИБЛИОТЕЧНЫЕ" ФУНКЦИИ ДЛЯ ТИПА HorizonSideRobots.HorizonSide:


inverse(side::HorizonSide) = HorizonSide(mod(Int(side)+2, 4))
left(side::HorizonSide) = HorizonSide(mod(Int(side)+1, 4))
right(side::HorizonSide) = HorizonSide(mod(Int(side)-1, 4))

#---------------- ВСПОМОГАТЕЛЬНЫЙ КОНКРЕТНЫЙ ТИП Coord: -----------------------------


mutable struct Coord   # supertype(Coord) == Any
    x::Int
    y::Int 
end

Coord() = Coord(0,0) 
# - это определение внешнего (вне структуры) конструктора типа CoordRobot (для удобства использования), 
#   где Coord(0,0) - это конструктор по умолчанию

import HorizonSideRobots: move! 
# !!! этот импорт необходим для обеспечения возможности переопределения функции move!, которая уже определена в пакете HorizonSideRobots,
#   и который мы собираемся использовать, для нового типа (Coord)
#   Если этого не сделать, то при использовании пакета HorizonSideRobots возникнет конфликт имён.
#   

function move!(coord::Coord, side::HorizonSide)
    if side==Nord
        coord.y += 1
    elseif side==Sud
        coord.y -= 1
    elseif side==Ost
        coord.x += 1
    elseif side==West
        coord.x -= 1
    end
    nothing
end

get_coord(coord::Coord) = (coord.x, coord.y)

#----------------------- ИЕРАРХИЯ ПРОЕКТИРУЕМЫХ ТИПОВ: ------------------------------
#=
Any:
|           try_move! 
|           movements! - перемещает робота в заданном направлении (4 разных метода)
|           shuttle! - перемещает робота "челноком" с увеличением амплитуды до тех пор, пока не выполнится некорое заданное условие
|           spiral! - перемещает робота по раскручивающейся спирали до тех пор, пока не выполнится некорое заданное условие
|           snake!  - (2 метода) перемещает робота "змейкой" (по верикальным или по горизонтальным рядам) 
|                     до тех пор, пока не будет пройдено все поле, или пока не выполнится некорое заданное условие
|
| # КОНКРЕТНЫЕ ТИПЫ:
|           
|-- CoordRobot (тип робота, при перемещениях отслеживающего свои координаты):
|           move!, isborder, putmarker!, ismarker, temperature - стандартный интерфейс робота
|           get_coord - возвращает текущие координаты робота
|        
| # КОНКРЕТНЫЕ ПАРАМЕТРИЧЕСКИЕ ТИПЫ:
|
|-- BorderRobot{TypeRobot}
|       (здесь TypeRobot - это формальный параметр;
|        cответствующий фактический параметр, например, может быть равен или SimpleRobot, или CoordRobot)
|           
|           try_move! - переопредяляемая функция, обеспечивающая обход простых (прямолинейных) или прямоугольных перегородок
|           (после каждой удачной попытки сделать щаг в заданном направлении, вызывающая функцию action!(), )
|       
|--   
|       (здесь TypeRobot - это формальный параметр;
|       cответствующий фактический параметр, например, может быть равен или SimpleRobot, или CoordRobot, или BorderRobot{SimpleRobot}, 
|       или BorderRobot{CoordRobot})
|
|-- CountmarkersRobot{TypeRobot}
|
|-- MarkersCoordsRobot{TypeRobot}

=#

#------------------- ОБОБЩЕННЫЕ ФУНКЦИИ: ------------------------
"""
try_move!(robot, side)::Bool

-- перемещает робота на 1 шаг в заданном направлении, если это возможно, в этом случае возвращает true, в противном - false 
"""
function try_move!(robot, side)::Bool
    if isborder(robot, side) # - это вызов виртуальной функции (кторая реально будет определена в каком-то из производных типов)
        false
    else
        move!(robot, side) # - это вызов виртуальной функции (кторая реально будет определена в каком-то из производных типов)
        true
    end
end


"""
movements!(robot, side)

-- перемещает робота в заданном направлении "до упора" (пока возможно) и возвращает число сделанных шагов
"""
function movements!(robot, side)
    n=0

    while try_move!(robot, side)
        n += 1
    end

    return n
end

"""
movements!(robot, side)

-- перемещает робота в заданном не более чем на max_num_steps шагов, пока это возможно, и возвращает число сделанных шагов
"""
function movements!(robot, side, max_num_steps::Integer)
    n=0
    while n < max_num_steps && try_move!(robot, side) # - в этом логическом выражении порядок аргументов важен!
        n += 1
    end
    return n
end


"""
movements!(stop_condition::Function, robot, side, max_num_steps) 

-- делает не более чем max_num_steps шагов в заданном направлении, пока выпоняется условие !stop_condition()==true", 
и возвращает число сделанных шагов

-- stop_condition - функция без аргументов, возвращающая логическое значение, определяет условие останова
"""
function movements!(stop_condition::Function, robot, side, max_num_steps)
    n = 0
    while n < max_num_steps && !stop_condition() && try_move!(robot, side) # - в этом логическом выражении порядок аргументов важен!
        n += 1
    end  
    return n 
end


"""
movements!(stop_condition::Function, robot, side) 

-- перемещает робота в заданном направлении пока возможен try_move! и пока выпоняется условие !stop_condition()==true", 
и возвращает число сделанных шагов

-- stop_condition - функция без аргументов, возвращающая логическое значение
"""
function movements!(stop_condition::Function, robot, side) 
    n=0
    while !stop_condition() && try_move!(robot,side)
        n += 1
    end
    return n
end


"""
shuttle!(stop_condition::Function, robot, side)

- перемещает робота "туда-сюда" (челноком), с увеличением амплитуды, до тех пор пока не выполнится условие condition()
- side - начальное направление перемещений
"""
function  shuttle!(stop_condition::Function, robot, side)
    n=0 # число шагов от начального положения
    while !stop_condition()  # condition(robot) - как вариант
        n += 1
        movements!(() -> !stop_condition(), robot, side, n)
        side = inverse(side)
    end
end


"""
spiral!(condition::Function, robot, side=Nord)

- перемещает робота по раскручивающейся спипали (влево), до тех пор пока не выполнится условие condition()

- condition - это condition(::HorizonSide)::Bool 

- side - начальное направление перемещений

"""
function spiral!(condition::Function, robot, side = Nord)
    n=1
    while true
        movements!(() -> !condition(side), robot, side, n)
        if condition(side)
            return
        end        
        side = left(side)
        movements!(() -> !condition(side), robot, side, n)
        if condition(side)
            return
        end        
        side = left(side)
        n += 1
    end
end


"""
snake!(stop_condition::Function, robot, (next_row_side, move_side)::NTuple{2,HorizonSide} = (Nord, Ost))

-- выполняет движение зиейкой пока пока не выполнено условие останова (или не пройденны все ряды в направлении next_row_side)

stop_condition - функция без ургумента, возвращающая логическое значение, определяет условие останова при движении змейкой

"""
function snake!(stop_condition::Function, robot, (next_row_side, move_side)::NTuple{2,HorizonSide} = (Nord, Ost)) # - это обобщенная функция
    # Робот - в (inverse(next_row_side), inverse(move_side)) - углу поля
    movements!(stop_condition, robot, move_side)
    while !stop_condition() && try_move!(robot, next_row_side)
        move_side = inverse(move_side)
        movements!(stop_condition, robot, move_side)
    end
end

"""
snake!(robot, (next_row_side, move_side)::NTuple{2,HorizonSide} = (Nord, Ost))

-- перемещает робта "зиейкой" пока не будут пройденны все ряды в направлении next_row_side
"""
function snake!(robot, (next_row_side, move_side)::NTuple{2,HorizonSide}=(Nord, Ost)) # - это обобщенная функция
    # Робот - в (inverse(next_row_side), inverse(move_side)) - углу поля
    snake!(() -> false, robot, (next_row_side, move_side))
end
#----------------------- КОНКРЕТНЫЙ ТИП CoordRobot: ----------------------

struct CoordRobot
    robot::Robot
    coord::Coord
end

# Тип CoordRobot представляет собой КОМПОЗИЦИЮ типов.
# Это есть альтернатива множественному наследованию, которого в языке Julia нет.

import HorizonSideRobots: move!, isborder, putmarker!, ismarker, temperature

function move!(robot::CoordRobot, side)
    move!(robot.robot, side)
    move!(robot.coord, side)
end

isborder(robot::CoordRobot, side) = isborder(robot.robot, side)
putmarker!(robot::CoordRobot) = putmarker!(robot.robot)
ismarker(robot::CoordRobot) = ismarker(robot.robot)
temperature(robot::CoordRobot) = temperature(robot.robot)

get_coord(robot::CoordRobot) = robot.coord

#-------------------- КОНКРЕТНЫЕ ПАРАМЕТРИЧЕСКИЕ ТИПЫ: -----------------------------


# Конкретный ПАРАМЕТРИЧЕСКИЙ тип BorderRobot{TypeRobot}:

import HorizonSideRobots: move!, isborder, putmarker!, ismarker, temperature

struct BorderRobot{TypeRobot}  # TypeRobot = Robot | CoordRobot | ...?
    robot::TypeRobot
end
# robot= BorderRobot{TypeRobot}(robot_of_TypeRobot)

#get(robot::BorderRobot) = robot.robot

"""
try_move!(robot::BorderRobot, side::HorizonSide)::Bool 

-- делает попытку прямолинейного перемещение робота в заданном направлении, в случае необходимости пытаясь обойти внутреннюю прямолинейную 
или прямоугольную перегородку, и возвращает, в случае успеха, значение true, или значение - false, если робот упирается во внешнюю рамку 
"""
function try_move!(robot::BorderRobot, side::HorizonSide)::Bool
    ort_side = left(side)
    n = movements!(() -> !isborder(robot.robot, side), robot.robot, ort_side)
    if isborder(r, side)
        movements!(robot.robot, inverse(ort_side), n)
        return false
    end
    move!(robot.robot, side)
    if n > 0 
        movements!(() -> !isborder(robot.robot, inverse(ort_side)), robot.robot, side)
        movements!(robot.robot, inverse(ort_side), n)
    end
    return true
end

import HorizonSideRobots: move!, isborder, putmarker!, ismarker, temperature

move!(robot::BorderRobot,side) = move!(robot.robot,side)
isborder(robot::BorderRobot, side) = isborder(robot.robot, side)
putmarker!(robot::BorderRobot) = putmarker!(robot.robot)
ismarker(robot::BorderRobot) = ismarker(robot.robot)
temperature(robot::BorderRobot) = temperature(robot.robot)

#=
Поскольку от фактического параметра TypeRobot типа BorderRobot реализация функции try_move! в данном случае не зависит, то
в аннотации типа аргумента robot значение параметра TypeRobot не указано.

ЗАМЕЧАНИЕ. 

В принципе, при определении данной функции, указать на то, что фактическое значение параметра типа может быть любым, можно было бы ещё и 
используюя ключевое слово where:

function try_move!(robot::BorderRobot{TypeRobot}, side::HorizonSide)::Bool where TypeRobot
    ...
end

И это было бы в точности то же самое, но в данном конкретном случае лучше обойтись просто без указания параметра.

Использование же ключевого слова where бы оправдано, например, в ситуации, когда определяемая функция имеет 2 аргумента 
параметрического типа, и необходимо указать, что значения параметра типа и там и там должно быть одно и тоже (хотя и не конкретным):

function f(x::Rational{T}, y::Rational{T}) where {T <: Unsigned}
    ...
end
=#

#--------------------- Конкретный ПАРАМЕТРИЧЕСКИЙ тип PutmarkerRobot: ---------------------

struct PutmarkersRobot{TypeRobot} # TypeRobot = Robot | CoordRobot | ...?
    robot::TypeRobot
end

get(robot::PutmarkersRobot) = robot.robot

function try_move!(robot::PutmarkersRobot, side)::Bool
    result = try_move!(robot.robot, side)
    if result
        putmarker!(robot.robot) # предполагается, что для каждого возможного конкретного типа TypeRobot определен метод putmarker!
    end
    return result
end

import HorizonSideRobots: move!, isborder, putmarker!, ismarker, temperature

move!(robot::PutmarkersRobot,side) = move!(robot.robot,side)
isborder(robot::PutmarkersRobot, side) = isborder(robot.robot, side)
putmarker!(robot::PutmarkersRobot) = putmarker!(robot.robot)
ismarker(robot::PutmarkersRobot) = ismarker(robot.robot)
temperature(robot::PutmarkersRobot) = temperature(robot.robot)

#------------------ Конкретный ПАРАМЕТРИЧЕСКИЙ тип CountmarkersRobot: ------------------------------

mutable struct CountmarkersRobot{TypeRobot}
    robot::TypeRobot
    count::Int
end
# TypeRobot = Robot | CoordRobot | BorderRobot{Robot} | BorderRobot{CoordRobot} | ...?

CountmarkersRobot{TypeRobot}(r::Robot) where TypeRobot =  CountmarkersRobot{TypeRobot}(TypeRobot(r))
# определять этот внешний конструктор не обязательно, это сделано просто для удобства использования, см. также замечание ниже.

function move!(robot::CountmarkersRobot, side)
    if try_move!(robot.robot, side)
        robot.count += 1
    end
end

get_num_markers(robot::CountmarkersRobot) = robot.count


#--------------- Конкретный ПАРАМЕТРИЧЕСКИЙ тип MarkersCoordsRobot: ------------------------------

mutable struct MarkersCoordsRobot{TypeRobot}
    robot::TypeRobot
    coord::Vector{NTuple{2,Int}}
end
# TypeRobot = CoordRobot | BorderRobot{CoordRobot} | ...?

# Предполагается использовать только конструктор по умолчанию

function move!(robot::MarkersCoordsRobot, side)
    if try_move!(robot.robot, side) && ismarker(robot.robot)
        push!(robot.count, get_coord(robot.robot))
    end
end

get_coord(robot::MarkersCoordsRobot) = robot.coord

#-----------------------------------