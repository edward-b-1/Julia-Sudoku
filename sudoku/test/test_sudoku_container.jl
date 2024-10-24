
using Test

include("../src/sudoku_container.jl")

using Main.sudoku_container


function test_sudoku_container()

    sc = SudokuContainer()

    @test size(sc.data) == (9, 9)

    @test all(x -> x === nothing, sc.data)

    sc.data[1, 1] = 5
    sc.data[2, 3] = 9
    sc.data[9, 9] = 1

    @test sc.data[1, 1] == 5
    @test sc.data[2, 3] == 9
    @test sc.data[9, 9] == 1

    io = IOBuffer()
    show(io, sc)
    output = String(take!(io))

    expected_output = 
"""
Sudoku:
5 . . . . . . . . 
. . 9 . . . . . . 
. . . . . . . . . 
. . . . . . . . . 
. . . . . . . . . 
. . . . . . . . . 
. . . . . . . . . 
. . . . . . . . . 
. . . . . . . . 1 
"""

    @test strip(output) == strip(expected_output)
end

function fill_board_using_matrix(
    sudoku_container::SudokuContainer,
    board::Matrix{Int8},
)
    for index_x::Int8 in 1:9
        for index_y::Int8 in 1:9
            value = board[index_x, index_y]
            if value == -1
                continue
            end
            set_cell(sudoku_container, (index_x, index_y), value)
        end
    end
end

function test_sudoku_container_1_remaining() 

    sc = SudokuContainer()

    board_matrix::Matrix{Int8} = [
        3 9 1 2 8 6 5 7 4;
        4 8 7 3 5 9 1 2 6;
        6 5 2 7 1 4 8 3 9;
        8 7 5 4 3 1 6 9 2;
        2 1 3 9 6 7 4 8 5;
        9 6 4 5 2 8 7 1 3;
        1 4 9 6 7 3 2 5 8;
        5 3 8 6 7 3 2 5 8;
        7 2 6 8 9 5 3 4 1;
    ]
    board_matrix[1, 1] = -1
    @test board_matrix[3, 2] == 5

    println("board_matrix:")
    println(board_matrix)

    fill_board_using_matrix(
        sc,
        board_matrix,
    )

    print(find_cells(sc))
    @test find_cells(sc) == [(3, 1, 1)]
end

function test_easy_sudoku_puzzle()

    sc = SudokuContainer()

    board_matrix::Matrix{Int8} = [
        8 0 1 3 0 0 9 0 0;
        0 4 9 0 0 0 0 5 1;
        2 5 6 8 9 0 4 0 0;
        0 1 5 6 8 0 0 4 0;
        4 0 0 0 0 0 0 0 8;
        0 8 0 0 0 4 1 9 7;
        1 0 2 0 7 9 0 0 0;
        0 6 0 5 3 8 0 0 0;
        0 0 8 0 6 0 0 3 4;
    ]
    board_matrix = (
        map(
            element -> element == 0 ? -1 : element,
            board_matrix,
        )
    )

    println("board_matrix:")
    println(board_matrix)

    fill_board_using_matrix(
        sc,
        board_matrix,
    )

    while true
        found_cells = find_cells(sc)

        if length(found_cells) < 1
            break
        end

        for found_cell in found_cells
            println("found cell: $(found_cell)")
            (value, tuple_index) = (found_cell[1], found_cell[2:end])
            set_cell(sc, tuple_index, value)
        end
    end

    println("completed board")
    println(sc)

end


function test_easy_sudoku_puzzle_2()

    sc = SudokuContainer()

    board_matrix::Matrix{Int8} = [
        0 0 0 2 6 0 7 0 1;
        6 8 0 0 7 0 0 9 0;
        1 9 0 0 0 4 5 0 0;
        8 2 0 1 0 0 0 4 0;
        0 0 4 6 0 2 9 0 0;
        0 5 0 0 0 3 0 2 8;
        0 0 9 3 0 0 0 7 4;
        0 4 0 0 5 0 0 3 6;
        7 0 3 0 1 8 0 0 0;
    ]
    board_matrix = (
        map(
            element -> element == 0 ? -1 : element,
            board_matrix,
        )
    )

    println("board_matrix:")
    println(board_matrix)

    fill_board_using_matrix(
        sc,
        board_matrix,
    )
    println("initial board")
    println(sc)

    while true
        found_cells = find_cells(sc)

        if length(found_cells) < 1
            break
        end

        for found_cell in found_cells
            #println("found cell: $(found_cell)")
            (value, tuple_index) = (found_cell[1], found_cell[2:end])
            set_cell(sc, tuple_index, value)
        end
    end

    println("completed board")
    println(sc)

end