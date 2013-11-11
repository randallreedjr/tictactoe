class TicTacToe
    
    #Read access to some class variables
    attr_reader :winner
    attr_reader :movenum
    attr_reader :playagain
    attr_reader :exit
    attr_reader :keyboard
    attr_reader :players
    
    def initialize
        #Set starting values for class variables
        #@board = ['_','_','_','_','_','_','_','_','_']
        @board = Array.new(9,'_')
        @keyboardboard = ['Q','W','E','A','S','D','Z','X','C']
        @numpadboard = ['7','8','9','4','5','6','1','2','3']
        @defaultboard = ['1','2','3','4','5','6','7','8','9']
        @players = 2
        #Keep track of current player
        @currentturn = 'X'
        @winner = ''
        @movenum = 0
        @lastmoveindex = -1
        @penultimatemoveindex = -1
        @exit = false
        @keyboard = false
        @numpad = false
        @playagain = true
    end
    
    def Reset
        #Reset game specific variables
        @board = Array.new(9,'_')
        @currentturn = 'X'
        @winner = ''
        @movenum = 0
        @lastmoveindex = -1
        @playagain = true
    end
    
    def PrintInstructions
        
        if @keyboard
            puts "Select space using letters"
            PrintBoard(@keyboardboard)
        elsif @numpad
            puts "Select space using number pad"
            PrintBoard(@numpadboard)
        else
            puts "Select space using number keys"
            PrintBoard(@defaultboard)
        end
        puts "X goes first"
    end
    
    def SelectPlayers
        if @movenum == 0 then
            puts "How many players? (Enter 1 or 2)"
            input = gets.chomp
            if input == '1'
                @players = 1
                puts "Now playing computer (easy)"
            elsif input == '2'
                @players = 2
            elsif ValidateCommand(input)
                puts "Select players before setting options"
                SelectPlayers()
            else
                puts "Invalid input; assuming 2 players"
                @players = 2
            end
        else
            puts "Cannot change players during game"
        end
    end
    
    def ValidateCommand(command)
        if command.length == 1 
            if not @keyboard and (command >= '1' and command <= '9')
                return true
            elsif @keyboard
                case command.downcase
                when 'q','w','e','a','s','d','z','x','c'
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
        
        case command.downcase
    
        when 'exit', 'board','kb','num','np','players','help','undo','debug'
            return true
        else
            return false
        end
    end
    
    def ExecuteCommand(command)
        if command.length == 1 
            if not @keyboard and (command >= '1' and command <= '9')
                if @numpad
                    #Convert keypad entry to normal number entry
                    case command
                    when '1'
                        command = '7'
                    when '2'
                        command = '8'
                    when '3'
                        command = '9'
                    when '7'
                        command = '1'
                    when '8'
                        command = '2'
                    when '9'
                        command = '3'
                    end
                end
                MakeMove(command)
                if @players == 1
                    #Computer will check for winner before making move
                    ComputerMove()
                end
            elsif @keyboard
                case command.downcase
                when 'q'
                    command = 1
                when 'w'
                    command = 2
                when 'e'
                    command = 3
                when 'a'
                    command = 4
                when 's'
                    command = 5
                when 'd'
                    command = 6
                when 'z'
                    command = 7
                when 'x'
                    command = 8
                when 'c'
                    command = 9
                end
                MakeMove(command)
                if @players == 1 
                    #Computer will check for winner before making move
                    ComputerMove()
                end
            end
        else
            case command.downcase
            #Valid commands are move space, exit, board, kb, num, np, players, help, and debug
            when 'exit' 
                @exit = true
                @playagain = false
            when 'board'
                PrintBoard(@board)
            when 'kb'
                @keyboard = true
                @numpad = false
                puts "Now using keyboard input"
                PrintInstructions()
            when 'num'
                @keyboard = false
                @numpad = false
                puts "Now using number input"
                PrintInstructions()
            when 'np'
                @keyboard = false
                @numpad = true
                puts "Now using number pad input"
                PrintInstructions()
            when 'players'
                SelectPlayers()
                PrintInstructions()
            when 'help'
                #display list of commands
                ShowHelp()
            when 'undo'
                #Cannot undo winning move
                if winner == ''
                    UndoMove()
                end
                PrintBoard(@board)
            when 'debug'
                #for developer only; not included in help list
                ShowDebug()
            end
        end
    end
    
    #Display board's current state
    def PrintBoard(board)
        #Display board in same format as instuctions, with values filled in
        for i in 0..8
            print "|" + board[i]
            if i % 3 == 2
                #Start new line every 3 columns
                print "|\n"
            end
        end
    end
    
    #Print outcome of game to players
    def PrintWinner
        if @winner == 'C'
            puts "Sorry, cat's game."
        else
            if @players == 2 
                puts "Congratulations! " + @winner + " wins!"
            elsif @players == 1 and @winner == 'X'
                puts "Congratulations! Player wins!"
            else
                #1 player, 'O' won
                puts "Sorry, computer wins."
            end
            
        end
    end
    
    def AskPlayAgain
        puts "Would you like to play again? y/n"
        option = gets.chomp.downcase
        if option == 'y'
            Reset()
            PrintInstructions()
        elsif option == 'n' or option == 'exit'
            @playagain = false
        else
            #for invalid input, recall recursively
            AskPlayAgain()
        end
    end
    
    def ShowDebug
        #Print internal values so developer can inspect
        puts "Debug mode - Dump internal values"
        puts "@players: " + @players.to_s
        puts "@currentturn: " + @currentturn
        puts "@winner: " + @winner
        puts "@movenum: " + @movenum.to_s
        puts "@exit: " + @exit.to_s
        puts "@keyboard: " + @keyboard.to_s
        puts "@numpad: " + @numpad.to_s
    end
    
    def ShowHelp
        #Show user what options are available
        puts "Available commands are:"
        puts "help - displays this screen"
        puts "board - displays current game board"
        puts "players - change number of players"
        puts "kb - changes to keyboard input (q,w,e,a,s,d,z,x,c)"
        puts "num - changes to number inputs (default; 1-9)"
        puts "np - inverts number input to match number pad"
        puts "undo - undo last move (only one move can be undone)"
        puts "exit - quits game"
    end
    
    def MakeMove(move)
        move = Integer(move)
        @penultimatemoveindex = @lastmoveindex
        @lastmoveindex = move-1
        #Array index is one less than move space
        if @board[@lastmoveindex] == '_'
            @board[@lastmoveindex] = @currentturn

            #Increment move counter
            @movenum += 1
            
            #Show updated board
            PrintBoard(@board)
            
            #Check for win condition
            @winner = CheckWinner()
            
            if @winner == ''
                #Toggle current player
                if @currentturn == 'X'
                    @currentturn = 'O'
                else
                    @currentturn = 'X'
                end
            end
        else
            #Do not allow player to choose space that has already been played
            puts "Space taken"
        end
    end
    
    def ComputerMove()
        if @winner == ''
            #Select random number 0-8 inclusive; this will match board index
            move = rand(9)
            while @board[move] != '_'
                move = rand(9)
            end
            #Need to increment index to match normal layout
            if @keyboard
                movestring = @keyboardboard[move]
            elsif @numpad
                movestring = @numpadboard[move]
            else
                movestring = (move+1).to_s
            end
            puts "Computer chooses " + movestring
            MakeMove(move+1)
        end
    end
    
    def UndoMove()
        if @players == 1
            #Undo computer and player move
            #Clear 2 moves from board
            @board[@lastmoveindex] = '_'
            @board[@penultimatemoveindex] = '_'
            @lastmoveindex = -1
            @penultimatemoveindex = -1
            
            @movenum -= 2
        else
            #Undo player move only
            #Clear move
            @board[@lastmoveindex] = '_'
            
            #Decrement move counter
            @movenum -= 1
            
            #Toggle current player
            if @currentturn == 'X'
                @currentturn = 'O'
            else
                @currentturn = 'X'
            end
        end
        puts "Move undone"
    end
    
    def CheckWinner
        if @movenum < 5 
            #Game cannot end in less than 5 moves
            return ''
        else
            
            case @lastmoveindex / 3
            #Determine row to check
            when 0
                if CheckWinTopRow() then return @currentturn end
            when 1
                if CheckWinCenterRow() then return @currentturn end
            when 2
                if CheckWinBottomRow() then return @currentturn end
            end
            
            case @lastmoveindex % 3
            #Determine column to check
            when 0
                if CheckWinLeftColumn() then return @currentturn end
            when 1
                if CheckWinMiddleColumn() then return @currentturn end
            when 2
                if CheckWinRightColumn() then return @currentturn end
            end
            
            if @lastmoveindex % 2 == 0
                #Determine diagonals to check
                if @lastmoveindex == 4 or @lastmoveindex % 4 == 2
                    if CheckWinBottomLeftToTopRight() then return @currentturn end
                elsif @lastmoveindex %4 == 0
                    if CheckWinTopLeftToBottomRight() then return @currentturn end
                end
            end
        end

        if @movenum == 9
            #Game over, no winner; cat's game
            return 'C'
        else
            #Game has not yet been decided
            return ''
        end

    end
    
    def CheckWinLeftColumn()
        if (@board[0] == @board[3]) and (@board[0] == @board[6])
            return true
        else
            return false
        end
    end
    
    def CheckWinMiddleColumn()
        if (@board[4] == @board[1]) and (@board[4] == @board[7]) 
            return true
        else
            return false
        end 
    end
    
    def CheckWinRightColumn()
        if (@board[8] == @board[2]) and (@board[8] == @board[5])
            return true
        else
            return false
        end
    end
    
    def CheckWinTopRow()
        if (@board[0] == @board[1]) and (@board[0] == @board[2])
            return true
        else
            return false
        end
    end
    
    def CheckWinCenterRow()
        if (@board[4] == @board[3]) and (@board[4] == @board[5]) 
            return true
        else
            return false
        end
    end
    
    def CheckWinBottomRow()
        if (@board[8] == @board[7]) and (@board[8] == @board[6])
            return true
        else
            return false
        end
    end
    
    def CheckWinTopLeftToBottomRight()
        if (@board[4] == @board[0]) and (@board[4] == @board[8])
            return true
        else
            return false
        end
    end
    
    def CheckWinBottomLeftToTopRight()
        if (@board[4] == @board[2]) and (@board[4] == @board[6])
            return true
        else
            return false
        end
    end
end


#Run program
t = TicTacToe.new
t.SelectPlayers()
t.PrintInstructions()

while t.playagain and not t.exit do
    until t.winner != '' or t.movenum == 9 or t.exit
        command = gets.chomp
        if t.ValidateCommand(command)
            t.ExecuteCommand(command)
        else
            if t.keyboard
                puts "Select valid letter\n"
            else
                puts "Select number 1-9\n"
            end
            #If invalid input is detected, redisplay instructions
            t.PrintInstructions()
        end
    end
    
    #Allow player to exit game early
    if not t.exit
        t.PrintWinner()
        t.AskPlayAgain()
    else
        puts "Game was exited early"
    end
end

puts "Thanks for playing!"
