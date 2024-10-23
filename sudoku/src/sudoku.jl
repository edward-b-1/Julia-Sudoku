module sudoku


export sudoku_main


include("sudoku_container.jl")

using Main.sudoku_container
using Main.sudoku_container_with_remaining_valid_cell_choices
using Main.sudoku_container_with_remaining_valid_cell_choices: initialize_sudoku_board


function sudoku_main()

    println("sudoku main starts")

    sudoku::SudokuContainerWithRemainingValidCellChoices = SudokuContainerWithRemainingValidCellChoices()
    #println(sudoku)

    initialize_sudoku_board(sudoku)
    println(sudoku.sudoku_container)


    println("end of program, exit")

end

end # module sudoku
