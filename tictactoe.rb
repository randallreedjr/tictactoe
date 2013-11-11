class TicTacToe
    
    def initialize
        #Set starting values for class variables
        #@board = ['_','_','_','_','_','_','_','_','_']
        @board = Array.new(9,'_')
        #Keep track of current player
        @currentturn = 'X'
        @winner = ''
        @movenum = 0
        @exit = false
        @keyboard = false
        @numpad = false
        @playagain = true
    end
    
    #Read access to class variables
    def Winner
        @winner
    end
    
    def Move
        @movenum
    end
    
    def PlayAgain
        @playagain
    end
    
    def ExitEarly
        @exit
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
            initialize()
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
            elsif ((@board[4] == @board[1] and @board[4] == @board[7]) or (@board[4] == @board[3] and @board[4] == @board[5])) and @board[4] != '_'
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
end


#Run program
t = TicTacToe.new
t.PrintInstructions()

while t.PlayAgain and not t.ExitEarly do
    until t.Winner != '' or t.Move == 9 or t.ExitEarly
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
    if not t.ExitEarly
        t.PrintWinner()
        t.AskPlayAgain()
    else
        "Game was exited early"
    end
end
