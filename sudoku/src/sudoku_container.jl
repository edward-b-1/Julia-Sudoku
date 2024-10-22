module sudoku_container


export SudokuContainer
export set_cell
export find_cells


mutable struct SudokuContainer
    data::Array{Union{Int8, Nothing}, 2}
    possible_values::Array{Bool, 3}

    function SudokuContainer()
        new(
            fill(nothing, 9, 9),
            fill(true, 9, 9, 9),
        )
    end
end

function Base.show(io::IO, sudoku::SudokuContainer)
    println(io, "Sudoku:")
    (rows, cols) = size(sudoku.data)
    for row_index in 1:rows
        for column_index in 1:cols
            cell = sudoku.data[row_index, column_index]
            print(io, cell === nothing ? "." : string(cell), " ")
        end
        println(io)
    end
end

function set_cell(
    sudoku::SudokuContainer,
    tuple_index::Tuple{Int8, Int8},
    value::Int8,
)
    # tuple_index[2] -> y index
    # tuple_index[1] -> x index
    println("set cell $(tuple_index) to $(value)")
    sudoku.data[tuple_index[2], tuple_index[1]] = value
    # the current cell is now set, so it has no remaining possible values
    for index in 1:9
        #println("remove possible value $(index) at $(tuple_index)")
        sudoku.possible_values[index, tuple_index[2], tuple_index[1]] = false
    end
    # cells in the same row cannot have the current cell value
    for index_x in 1:9
        #println("remove possible value $(value) at $((index_x, tuple_index[2]))")
        sudoku.possible_values[value, tuple_index[2], index_x] = false
    end
    # cells in the same col cannot have the current cell value
    for index_y in 1:9
        #println("remove possible value $(value) at $((tuple_index[1], index_y))")
        sudoku.possible_values[value, index_y, tuple_index[1]] = false
    end
    # cells in the same box cannot have the current cell value
    #println("cells in the same box cannot have the current cell value")
    box_x = div(tuple_index[1] - 1, 3) #1->0->0 -> 0
    box_y = div(tuple_index[2] - 1, 3) #8->7->2 -> 6
    for index_x in 1:3
        for index_y in 1:3
            index_yy = index_y + 3box_y
            index_xx = index_x + 3box_x
            #println("remove possible value $(value) at $((index_xx, index_yy))")
            sudoku.possible_values[value, index_yy, index_xx] = false
        end
    end
    #println("done")
end

function find_cells(
    sudoku::SudokuContainer,
)
    function test_single_value(
        sudoku::SudokuContainer,
        index_x,
        index_y,
    )
        cell_value::Int8 = -1
        for index in 1:9
            if sudoku.possible_values[index, index_y, index_x] == true
                if cell_value != -1
                    continue
                else
                    cell_value = index
                end
            end
        end
        return cell_value
    end

    single_value_index_list::Vector{Tuple{Int8, Int8}} = []

    println("finding cells with unique possible value")
    for index_x in 1:9
        for index_y in 1:9
            single_value::Bool =
                test_single_value(
                    sudoku,
                    index_x,
                    index_y,
                )
            if single_value == true
                push!(single_value_index_list, (index_x, index_y))
            end
        end
    end
    l = length(single_value_index_list)
    println("found $(l) cells")
    
    return single_value_index_list
end

end
