class TicTacToe
    def initialize
        @board = ['_','_','_','_','_','_','_','_','_']
        @currentturn = 'X'
        @winner = ''
        @move = 0
    end
    
    def makemove(move)
        if not (move == '1' or move == '2' or move == '3' or move == '4' or move == '5' or move == '6' or move == '7' or move == '8' or move == '9') 
            puts "Select number 1-9\n"
            PrintInstructions()
            return
        end
        move = Integer(move)
        if @board[move-1] == '_' then
            @board[move-1] = @currentturn
            if @currentturn == 'X' then
                @currentturn = 'O'
            else
                @currentturn = 'X'
            end
            @move += 1
            PrintBoard()
            CheckWinner()
        else
            puts "Space taken"
        end

    end
    
    def CheckWinner
        if @move < 5 
            return ''
        else
            if ((@board[0] == @board[1] and @board[0] == @board[2]) or (@board[0] == @board[3] and @board[0] == @board[6])) and @board[0] != '_'
                @winner = @board[0]
            elsif ((@board[4] == @board[0] and @board[4] == @board[8]) or (@board[4] == @board[2] and @board[4] == @board[6])) and @board[4] != '_'
                @winner = @board[4]
            elsif ((@board[4] == @board[1] and @board == @board[7]) or (@board[4] == @board[3] and @board[4] == @board[5])) and @board[4] != '_'
                @winner = @board[4]
            elsif ((@board[8] == @board[7] and @board[8] == @board[6]) or (@board[8] == @board[5] and @board[8] == @board[2])) and @board[8] != '_'
                @winner = @board[8]
            elsif @move == 9
                return 'C'
            else
                return ''
            end
        end
    end
    
    
    def PrintInstructions
        puts "Select space using number keys"
        puts "|1|2|3|"
        puts "|4|5|6|"
        puts "|7|8|9|"
        puts "X goes first"
    end
    
    def PrintBoard
        
        for i in 0..8
            print "|" + @board[i]
            if i%3==2 then 
                print "|\n"
            end
        end
    end
    
    def Winner
        @winner
    end
    
    def Move
        @move
    end
    
    def PrintWinner
        if @winner == 'C'
            "Sorry, Cat wins."
        else
            "Congratulations! " + @winner + " wins!"
        end
    end
end

t = TicTacToe.new
t.PrintInstructions

until t.Winner != '' or t.Move == 9
    command = gets.chomp
    if command == 'exit'
        break
    elsif command == "board"
        t.PrintBoard
    else
        t.makemove(command)
    end
end

if command != 'exit'
    t.PrintWinner
else
    "Game was exited early"
end

