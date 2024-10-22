module sudoku_container_with_remaining_valid_cell_choices


export SudokuContainerWithRemainingValidCellChoices


include("sudoku_container.jl")

using .sudoku_container


mutable struct SudokuContainerWithRemainingValidCellChoices
    sudoku_container::SudokuContainer

    # map index -> set
    # where index is (int, int)
    # and set is Set(int)
    remaining_valid_cell_choices::Dict{Tuple{Int8, Int8}, Set{Int8}}

    function SudokuContainerWithRemainingValidCellChoices()
        remaining_valid_cell_choices = Dict{Tuple{Int8, Int8}, Set{Int8}}()
        for row in 1:9, col in 1:9
            remaining_valid_cell_choices[(row, col)] = Set(1:9)
        end
        new(SudokuContainer(), remaining_valid_cell_choices)
    end
end


function initialize_sudoku_board(sudoku_board::SudokuContainerWithRemainingValidCellChoices)

    function single_step(sudoku_board::SudokuContainerWithRemainingValidCellChoices)
        println("single_step")

        if length(sudoku_board.remaining_valid_cell_choices) < 1
            return false
        end

        tuple_index = rand(keys(sudoku_board.remaining_valid_cell_choices))
        row_index = tuple_index[2]
        col_index = tuple_index[1]

        println("chose random index: $(tuple_index)")

        set_of_remaining_valid = sudoku_board.remaining_valid_cell_choices[tuple_index]
        random_valid_choice = rand(set_of_remaining_valid)

        println("chose random choice: $(random_valid_choice)")

        # TODO: this must operate on sudoku_board.sudoku_container
        ##check_can_set_cell(tuple_index, random_valid_choice)

        set_cell(sudoku_board.sudoku_container, tuple_index, random_valid_choice)

        # delete this cell
        delete!(sudoku_board.remaining_valid_cell_choices, tuple_index)

        # remove value from row
        for index_row in 1:9
            index_col = col_index
            tuple_index = (index_col, index_row)
            if tuple_index in keys(sudoku_board.remaining_valid_cell_choices)
                println("remove value $(random_valid_choice) at index $(tuple_index)")
                delete!(sudoku_board.remaining_valid_cell_choices[index_col, index_row], random_valid_choice)
            else
                println("index $(tuple_index) does not exist")
            end
        end

        # remove value from column
        for index_col in 1:9
            index_row = row_index
            tuple_index = (index_col, index_row)
            if tuple_index in keys(sudoku_board.remaining_valid_cell_choices)
                println("remove value $(random_valid_choice) at index $(tuple_index)")
                delete!(sudoku_board.remaining_valid_cell_choices[index_col, index_row], random_valid_choice)
            else
                println("index $(tuple_index) does not exist")
            end
        end

        println("number of remaining cells to fill: $(length(sudoku_board.remaining_valid_cell_choices))")
        println("")

        return true
    end

    counter::Integer = 0
    while single_step(sudoku_board)
        println(sudoku_board.sudoku_container)
        counter += 1
        println("counter=$(counter)")
    end
end


end
