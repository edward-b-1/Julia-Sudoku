module sudoku_container


export SudokuContainer
export set_cell
export find_cells


mutable struct SudokuContainer
    data::Array{Union{Int8, Nothing}, 2} # elements i,j
    possible_values::Array{Bool, 3} # elements i,j preceeded by value index k, such that k is the first and fastest index for iteration

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
    for column_index in 1:cols
        for row_index in 1:rows
            cell = sudoku.data[column_index, row_index]
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
    ##println("set cell $(tuple_index) to $(value)")
    sudoku.data[tuple_index[1], tuple_index[2]] = value
    # the current cell is now set, so it has no remaining possible values
    for index in 1:9
        #println("remove possible value $(index) at $(tuple_index)")
        sudoku.possible_values[index, tuple_index[1], tuple_index[2]] = false
    end
    # cells in the same row cannot have the current cell value
    for index_x in 1:9
        #println("remove possible value $(value) at $((index_x, tuple_index[2]))")
        sudoku.possible_values[value, index_x, tuple_index[2],] = false
    end
    # cells in the same col cannot have the current cell value
    for index_y in 1:9
        #println("remove possible value $(value) at $((tuple_index[1], index_y))")
        sudoku.possible_values[value, tuple_index[1], index_y] = false
    end
    # cells in the same box cannot have the current cell value
    #println("cells in the same box cannot have the current cell value")
    box_x = div(tuple_index[1] - 1, 3) #1->0->0 -> 0
    box_y = div(tuple_index[2] - 1, 3) #8->7->2 -> 6
    for index_x in 1:3
        for index_y in 1:3
            index_xx = index_x + 3box_x
            index_yy = index_y + 3box_y
            #println("remove possible value $(value) at $((index_xx, index_yy))")
            sudoku.possible_values[value, index_xx, index_yy] = false
        end
    end
    #println("done")
end

function find_cells(
    sudoku::SudokuContainer,
)
    """
    This function will return -1 if there are no possible values for the cell
    OR if there are multiple possible values for the cell.

    Otherwise, the single possible cell value will be returned. 
    """
    function test_single_value(
        sudoku::SudokuContainer,
        index_x,
        index_y,
    )
        cell_value::Int8 = -1
        for index in 1:9
            if sudoku.possible_values[index, index_x, index_y] == true
                if cell_value == -1
                    cell_value = index
                else
                    return -1
                end
            end
        end
        return cell_value
    end

    single_value_index_list::Vector{Tuple{Int8, Int8, Int8}} = []

    ##println("finding cells with unique possible value")
    for index_x in 1:9
        for index_y in 1:9
            single_value::Int8 =
                test_single_value(
                    sudoku,
                    index_x,
                    index_y,
                )
            if single_value != -1
                push!(single_value_index_list, (single_value, index_x, index_y))
            end
        end
    end
    ##l = length(single_value_index_list)
    ##println("found $(l) cells")
    
    return single_value_index_list
end

end
