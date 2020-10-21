//
//  Reversi.swift
//  reversi WatchKit Extension
//
//  Created by Jakob & Niko Neufeld on 20.10.20.
//

import Foundation
enum Color {
    case red
    case green
    case empty
}

enum AIStrength {
    case villageIdiot
    case newbie
}

struct Board {
    var _board: [[Color]] = [[]]
    func at(_ position: Position) -> Color {
        return _board[Int(position.row)][Int(position.column)]
    }
    mutating func set(position: Position, color: Color) {
        _board[Int(position.row)][Int(position.column)] = color
    }
}

struct Position: Hashable {
    var row : UInt8
    var column: UInt8
}

typealias Move = [Position]

struct PlayableString {
    var bodyColor: Color? = nil
    var head: Position? = nil
    var tail: Position? = nil
    var body = Set<Position>()
}


struct Reversi {
    var aistrength: AIStrength = .villageIdiot
    let size: Int
    var board = Board()
    var playableStrings = [PlayableString]()
    init(size: Int) {
        assert(size % 2 == 0)
        self.size = size
        reset()
    }
    mutating func reset() {
        for row in 0..<size {
            for column in 0..<size {
                board._board[row][column] = .empty
            }
        }
        board._board[(size - 1) / 2][(size - 1) / 2] = .green
        board._board[size  / 2][(size - 1) / 2] = .red
        board._board[(size - 1) / 2][size / 2 ] = .red
        board._board[size / 2][size / 2] = .green
    }
    func idiotMove(color: Color) -> Move? {
        let moves = possibleMoves(player: color)
        return moves.randomElement()
    }
    func newbieMove(color: Color) -> Move? {
        let moves = possibleMoves(player: color)
        if moves.count == 0 {
            return nil
        }
        var bestMove = moves[0]
        for move in moves {
            if move.count > bestMove.count {
                bestMove = move
            }
        }
        return bestMove
    }
    func compterMove(color: Color) -> Move? {
        switch aistrength {
        case .villageIdiot: return idiotMove(color: color)
        case .newbie: return newbieMove(color: color)
        }
    }
    func gameOver() -> Bool {
        if possibleMoves(player: .red).count == 0 && possibleMoves(player: .green).count == 0 {
            return true
        }
        return false
    }
    func winner() -> Color {
        var count = [Color.red : 0, Color.green: 0]
        for row in 0..<size {
            for column in 0..<size {
                let color = board.at(Position(row: UInt8(row), column: UInt8(column)))
                count[color]! += 1
            }
        }
        if count[Color.green]! > count[Color.red]! {
            return .green
        }
        if count[.red]! > count[.green]! {
            return .red
        }
        return .empty // i.e. draw
    }
    func moveOk(color: Color, position: Position) -> Bool {
        for move in possibleMoves(player: color) {
            if move[0] == position {
                return true
            }
        }
        return false
    }
    mutating func applyMove(color: Color, position: Position) {
        for move in possibleMoves(player: color) {
            if move[0] == position {
                for _position in move {
                    board.set(position: _position, color: color)
                }
            }
        }
    }
    func possibleMoves(player: Color) -> [Move] {
        var moves: [Move] = []
        for row in 0..<size {
            for column in 0..<size {
                if board._board[row][column] != .empty {
                    continue
                }
                // look in eight possible directions for neighbour in opposite color
                // define increment for each direction
                // continue until find empty or border or own color
                for (rowInc, colInc) in [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)] {
                    let move = getString(player: player, position: Position(row: UInt8(row), column: UInt8(column)), rowInc: UInt8(rowInc), colInc: UInt8(colInc))
                    if move != nil {
                        moves.append(move!)
                    }
                }
            }
        }
        return moves
    }
    func getString(player: Color, position: Position, rowInc: UInt8, colInc: UInt8) -> Move? {
        var move = [position]
        var row = position.row + rowInc
        var column = position.column + colInc
        while (true) {
            if row < 0 || row == size || column < 0 || column == size {
                return nil
            }
            if board._board[Int(row)][Int(column)] == .empty {
                return nil
            }
            if board._board[Int(row)][Int(column)] == player {
                // same color found -- done
                move.append(Position(row: row,column: column))
                break
            } else {
                // opposite color found continue
                move.append(Position(row: row,column: column))
                row += rowInc
                column += colInc
                continue
            }
        }
        if move.count == 2 {
            // no opposite color in between
            return nil
        }
        return move
    }
}
