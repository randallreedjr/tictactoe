class TicTacToe
    
    def initialize
        #Set starting values for class variables
        @board = ['_','_','_','_','_','_','_','_','_']
        #Keep track of current player
        @currentturn = 'X'
        @winner = ''
        @movenum = 0
    end
    
    def makemove(move)
        #Verify input
        if not (move == '1' or move == '2' or move == '3' or move == '4' or move == '5' or move == '6' or move == '7' or move == '8' or move == '9') 
            puts "Select number 1-9\n"
            #If invalid input is detected, redisplay instructions
            PrintInstructions()
            return
        end
        move = Integer(move)
        #Array index is one less than move space
        if @board[move-1] == '_'
            @board[move-1] = @currentturn
            
            #Toggle current player
            if @currentturn == 'X'
                @currentturn = 'O'
            else
                @currentturn = 'X'
            end
            #Increment move counter
            @movenum += 1
            
            #Show updated board
            PrintBoard()
            
            #Check for win condition
            @winner = CheckWinner()
        else
            #Do not allow player to choose space that has already been played
            puts "Space taken"
        end

    end
    
    def CheckWinner
        if @movenum < 5 
            #Game cannot end in less than 5 moves
            return ''
        else
            #Check left column and top row
            if ((@board[0] == @board[1] and @board[0] == @board[2]) or (@board[0] == @board[3] and @board[0] == @board[6])) and @board[0] != '_'
                return @board[0]
            #Check middle diagponals
            elsif ((@board[4] == @board[0] and @board[4] == @board[8]) or (@board[4] == @board[2] and @board[4] == @board[6])) and @board[4] != '_'
                return @board[4]
            #Check middle column and middle row
            elsif ((@board[4] == @board[1] and @board == @board[7]) or (@board[4] == @board[3] and @board[4] == @board[5])) and @board[4] != '_'
                return @board[4]
            #Check right column and bottom row
            elsif ((@board[8] == @board[7] and @board[8] == @board[6]) or (@board[8] == @board[5] and @board[8] == @board[2])) and @board[8] != '_'
                return @board[8]
            #If all moves have been made and no winner, cat game
            elsif @movenum == 9
                return 'C'
            else
                #Game has not yet been decided
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
        #Display board in same format as instuctions, with values filled in
        for i in 0..8
            print "|" + @board[i]
            if i % 3 == 2
                #Start new line every 3 columns
                print "|\n"
            end
        end
    end
    
    #Read access to class variables
    def Winner
        @winner
    end
    
    def Move
        @movenum
    end
    
    #Print outcome to players
    def PrintWinner
        if @winner == 'C'
            "Sorry, cat's game."
        else
            "Congratulations! " + @winner + " wins!"
        end
    end
end


#Run program
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

#Allow player to exit game early
if command != 'exit'
    t.PrintWinner
else
    "Game was exited early"
end

