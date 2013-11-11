class TicTacToe
    
    #Read access to some class variables
    attr_reader :winner
    attr_reader :movenum
    attr_reader :playagain
    attr_reader :exit
    
    
    def initialize
        #Set starting values for class variables
        #@board = ['_','_','_','_','_','_','_','_','_']
        @board = Array.new(9,'_')
        #Keep track of current player
        @currentturn = 'X'
        @winner = ''
        @movenum = 0
        @lastmoveindex = -1
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
            puts "|Q|W|E|"
            puts "|A|S|D|"
            puts "|Z|X|C|"
        elsif @numpad
            puts "Select space using number pad"
            puts "|7|8|9|"
            puts "|4|5|6|"
            puts "|1|2|3|" 
        else
            puts "Select space using number keys"
            puts "|1|2|3|"
            puts "|4|5|6|"
            puts "|7|8|9|"
        end
        puts "X goes first"
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
    
        when 'exit', 'board','kb','num','np','help','debug'
            return true
        else
            return false
        end
    end
    
    def ExecuteCommand(command)
        if command.length == 1 
            if not @keyboard and (command >= '1' and command <= '9')
                if @numpad
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
            end
        else
            case command.downcase
            #Valid commands are move space, exit, board, kb, and #
            when 'exit' 
                @exit = true
                @playagain = false
            when 'board'
                PrintBoard()
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
            when 'help'
                ShowHelp()
            when 'debug'
                ShowDebug()
            end
        end
    end
    
    #Display board's current state
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
    
    #Print outcome of game to players
    def PrintWinner
        if @winner == 'C'
            puts "Sorry, cat's game."
        else
            puts "Congratulations! " + @winner + " wins!"
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
            AskPlayAgain()
        end
    end
    
    def ShowDebug
        puts "Debug mode - Dump internal values"
        puts "@currentturn: " + @currentturn
        puts "@winner: " + @winner
        puts "@movenum: " + @movenum.to_s
        puts "@exit: " + @exit.to_s
        puts "@keyboard: " + @keyboard.to_s
        puts "@numpad: " + @numpad.to_s
    end
    
    def ShowHelp
        puts "Available commands are:"
        puts "help - displays this screen"
        puts "board - displays current game board"
        puts "kb - changes to keyboard input (q,w,e,a,s,d,z,x,c)"
        puts "num - changes to number inputs (default; 1-9)"
        puts "np - inverts number input to match number pad"
    end
    
    def MakeMove(move)
        move = Integer(move)
        @lastmoveindex = move-1
        #Array index is one less than move space
        if @board[@lastmoveindex] == '_'
            @board[@lastmoveindex] = @currentturn

            #Increment move counter
            @movenum += 1
            
            #Show updated board
            PrintBoard()
            
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
                if CheckWinCenterRow()
                    return @currentturn 
                end
            when 2
                if CheckWinBottomRow() 
                    return @currentturn 
                end
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
                    if CheckWinBottomLeftToTopRight() 
                        return @currentturn 
                    end
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
t.PrintInstructions()

while t.playagain and not t.exit do
    until t.winner != '' or t.movenum == 9 or t.exit
        command = gets.chomp
        if t.ValidateCommand(command)
            t.ExecuteCommand(command)
        else
            puts "Select number 1-9\n"
            #If invalid input is detected, redisplay instructions
            t.PrintInstructions()
        end
    end
    
    #Allow player to exit game early
    if not t.exit
        t.PrintWinner()
        t.AskPlayAgain()
    else
        "Game was exited early"
    end
end
