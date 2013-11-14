class TicTacToe
    
    class Player
        attr_accessor :score
        attr_reader :type
        attr_reader :name
        attr_accessor :mark
        def initialize(type, name, mark)
            @name = name
            @type = type
            @score = 0
            @mark = mark
        end
        
        def Print()
            print name + ", type: " + type + ", score: " + score.to_s
        end
    end
    
    #Read access to some class variables
    attr_reader :winner
    attr_reader :movenum
    attr_reader :playagain
    attr_reader :exit
    attr_reader :keyboard
    attr_reader :player1
    attr_reader :player2
    
    def initialize
        #Set starting values for class variables
        #@board = ['_','_','_','_','_','_','_','_','_']
        @board = Array.new(9,'_')
        #layout if choosing keyboard option
        @keyboardboard = ['Q','W','E','A','S','D','Z','X','C']
        #layout if using number pad option
        @numpadboard = ['7','8','9','4','5','6','1','2','3']
        #layout if using default number option
        @defaultboard = ['1','2','3','4','5','6','7','8','9']
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
        @difficulty = 'easy'
        @movesuccess = false
        @catgames = 0
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
    
    def ShowHelp
        #Show user what options are available
        puts "Available commands are:"
        puts "help - displays this screen"
        puts "board - displays current game board"
        puts "players - change number of players and reset score"
        puts "score - display current score"
        puts "clearscore - reset score"
        puts "difficulty - change difficulty level"
        puts "kb - changes to keyboard input (q,w,e,a,s,d,z,x,c)"
        puts "num - changes to number inputs (default; 1-9)"
        puts "np - inverts number input to match number pad"
        puts "undo - undo last move (only one move can be undone)"
        puts "exit - quits game"
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
    
    def SelectPlayers
        if @movenum == 0 then
            puts "How many players? (Enter 1 or 2)"
            input = gets.chomp
            if input == '1'
                @player1 = Player.new('human', 'Player','X')
                @player2 = Player.new('computer', 'Computer','O')
            elsif input == '2'
                @player1 = Player.new('human', 'Player 1','X')
                @player2 = Player.new('human', 'Player 2','O')
            elsif input.downcase == 'exit'
                #exit anytime
                @exit = true
            elsif ValidateCommand(input)
                puts "Select players before setting options"
                SelectPlayers()
            else
                puts "Invalid input; assuming 2 players"
                @player1 = Player.new('human', 'Player 1','X')
                @player2 = Player.new('human', 'Player 2','O')
            end
        else
            puts "Cannot change players during game"
        end
    end
    
    def ShowScore    
        puts @player1.name + ": " + @player1.score.to_s + ", " + @player2.name + ": " + @player2.score.to_s + ", Cat: " + @catgames.to_s
    end
    
    def ClearScore
        @player1.score = 0
        @player2.score = 0
        @catgames = 0
    end
    
    def SelectDifficulty
        #Cannot change difficulty during game
        if @movenum == 0 then
            puts "Select difficutly"
            puts "1) Easy"
            puts "2) Normal"
            puts "3) Hard"
            input = gets.chomp
            
            if input == '1' or input.downcase == 'easy'
                @difficulty = 'easy'
                puts "Now playing computer on easy"
            elsif input == '2' or input.downcase == 'normal'
                @difficulty = 'normal'
                puts "Now playing computer on normal"
            elsif input == '3' or input.downcase == 'hard'
                @difficulty = 'hard'
                puts "Now playing computer on HARD"
            elsif input.downcase == 'exit'
                @exit = true
            elsif ValidateCommand(input)
                puts "Select difficulty before setting options"
                SelectDifficulty()
            else
                puts "Invalid input; defaulting to easy"
                @difficulty = 'easy'
            end
        else
            puts "Cannot change difficulty during game"
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
    
        when 'exit', 'board','kb','num','np','players','difficulty','score','clearscore','help','undo','debug'
            return true
        else
            return false
        end
    end
    
    def ExecuteCommand(command)
        if command.length == 1 
            if not @keyboard and (command >= '1' and command <= '9')
                if @numpad
                    #Convert keypad entry to normal number entry; middle row stays the same
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
                if @player2.type == 'computer' and @movesuccess
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
                if @player2.type == 'computer' and @movesuccess
                    #Computer will check for winner before making move
                    ComputerMove()
                end
            end
        else
            case command.downcase
            #Valid commands are move space, exit, board, kb, num, np, players, 
            # difficulty, score, clearscore, help, undo, and debug
            when 'exit' 
                @exit = true
                @playagain = false
            when 'board'
                PrintBoard(@board)
                
            #When changing input, always reprint instructions to show player what input is valid
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
                if @player2.type == 'computer'
                    SelectDifficulty()
                end
                PrintInstructions()
            when 'difficulty'
                SelectDifficulty()
            when 'score'
                ShowScore()
            when 'clearscore'
                ClearScore()
                ShowScore()
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
        
    #Print outcome of game to players
    def PrintWinner
        if @winner == 'C'
            puts "Sorry, cat's game."
        else
            if @player1.mark == @winner
                puts "Congratulations! " + @player1.name + " wins!"
            elsif @player2.mark == @winner and @player2.type = 'human'
                puts "Congratulations! " + @player2.name + " wins!"
            elsif @player2.mark == @winner and @player2.type = 'computer'
                #1 player, 'O' won. Do not congratulate player on computer victory.
                puts "Sorry, ' + player2.name + ' wins."
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
        elsif option == 'score'
            #Player may base decision to play again on current score
            ShowScore()
            AskPlayAgain()
        else
            #for invalid input, recall recursively
            AskPlayAgain()
        end
    end
    
    def ShowDebug
        #Print internal values so developer can inspect
        puts "Debug mode - Dump internal values"
        puts @player1.Print()
        puts @player2.Print()
        puts "@difficulty: " + @difficulty
        puts "@currentturn: " + @currentturn
        puts "@winner: " + @winner
        puts "@movenum: " + @movenum.to_s
        puts "@lastmoveindex: " + @lastmoveindex.to_s
        puts "@exit: " + @exit.to_s
        puts "@keyboard: " + @keyboard.to_s
        puts "@numpad: " + @numpad.to_s
    end
    
    def MakeMove(move)
        #Cast string input to integer; easier to work with array index
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
            @winner = CheckWinner(@lastmoveindex)
            
            if @winner == ''
                #Toggle current player
                if @currentturn == 'X'
                    @currentturn = 'O'
                else
                    @currentturn = 'X'
                end
            else
                case @winner
                when 'X'
                    if @player1.mark == 'X'
                        @player1.score += 1
                    else
                        @player2.score += 1
                    end
                when 'O'
                    if @player1.mark == 'X'
                        @player1.score += 1
                    else
                        @player2.score += 1
                    end
                when 'C'
                    @catgames += 1
                end
            end
            @movesuccess = true
        else
            #Do not allow player to choose space that has already been played
            puts "Space taken"
            @movesuccess = false
        end
    end
    
    def ComputerMove()
        if @winner == ''
            if @difficulty == 'easy'
                #Easy computer moves randomly
                move = RandomMove()
            elsif @difficulty == 'normal'
                #Normal computer moves randomly early on, but looks for wins or blocks as the game progresses
                if @movenum < 3
                    move = RandomMove()
                else
                    #Check for winning move first
                    #puts "Checking for win..."
                    move = FindWinningMove()
                    if move == -1
                         #No winning move available, try block next
                        #puts "Checking for block..."
                        move = FindBlockingMove()
                        if move == -1 then
                            #puts "Moving randomly..."
                            move = RandomMove()
                        end
                    end
                end
            elsif @difficulty == 'hard'
                #Hard computer knows what move to make in every situation, until cat game is guaranteed
                move = -1
                if @movenum == 1
                    if @board[4] == '_'
                        move = 4
                    else
                        move = 0
                    end
                elsif @movenum == 3
                    if @board[4] == 'X'
                        if @board[0] != '_' and @board[8] != '_'
                            move = 2
                            elsif @board[2] != '_' and @board[6] != '_'
                            move = 0
                        end
                    else
                        if (@board[1] == 'X' and @board[5] == 'X') or (@board[3] == 'X' and @board[7] == 'X')
                            move = 0
                        elsif (@board[3] == 'X' and @board[8] == 'X') or (@board[5] == 'X' and @board[6] == 'X') or (@board[3] == 'X' and @board[5] == 'X') or (@board[0] == 'X' and @board[8] == 'X') or (@board[2] == 'X' and @board[6] == 'X')
                            move = 1
                        elsif (@board[1] == 'X' and @board[3] == 'X') or (@board[5] == 'X' and @board[7] == 'X')
                            move = 2
                        elsif (@board[2] == 'X' and @board[7] == 'X') or (@board[1] == 'X' and @board[8] == 'X') or (@board[1] == 'X' and @board[7] == 'X')
                            move = 3
                        elsif (@board[1] == 'X' and @board[6] == 'X') or (@board[0] == 'X' and @board[7] == 'X')
                            move = 5
                        elsif (@board[0] == 'X' and @board[5] == 'X') or (@board[2] == 'X' and @board[3] == 'X')
                            move = 7
                        end
                    end
                elsif @movenum == 5
                    if (@board[4] == 'O' and @board[5] == 'X' and @board[7] == 'X' and @board[1] != '_' and @board[3] != '_')
                        move = 0
                    end
                end
                if move == -1
                    #Check for winning move first
                    #puts "Checking for win..."
                    move = FindWinningMove()
                    if move == -1
                         #No winning move available, try block next
                        #puts "Checking for block..."
                        move = FindBlockingMove()
                        if move == -1 then
                            #puts "Select side"
                            if @board[1] == '_'
                                move = 1
                            elsif @board[3] == '_'
                                move = 3
                            elsif @board[5] == '_'
                                move = 5
                            elsif @board[7] == '_'
                                move = 7
                            end
                        end
                    end
                end
                

            end
            ShowComputerMove(move)
            MakeMove(move+1) 
        end
    end
    
    def UndoMove()
        if @player2.type=='computer'
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
    
    def FindWinningMove()
        #Pretend O went in any available square and check for win
        for i in 0..8
            if @board[i] == '_'
                @board[i] = 'O'
                if CheckWinner(i) == 'O'
                    @board[i] = '_'
                    return i
                end
                @board[i] = '_'
            end
        end
        return -1
    end
    
    def FindBlockingMove()
        #Pretend X went in any available square and check for win; that space necessitates a block
        for i in 0..8
            if @board[i] == '_'
                @board[i] = 'X'
                #CheckWinner returns currentturn, so it will still be O
                if CheckWinner(i) == 'O'
                    @board[i] = '_'
                    return i
                end
                @board[i] = '_'
            end
        end
        return -1
    end
    
    def RandomMove()
        #Select random number 0-8 inclusive; this will match board index
        move = rand(9)
        while @board[move] != '_'
            move = rand(9)
        end
        return move
    end
    
    def ShowComputerMove(move)
        #Need to increment index to match normal layout
        if @keyboard
            movestring = @keyboardboard[move]
        elsif @numpad
            movestring = @numpadboard[move]
        else
            movestring = (move+1).to_s
        end
        puts "Computer chooses " + movestring
    end
    
    def CheckWinner(lastmoveindex)
        if @movenum < 3
            #Game cannot end in less than 5 moves
            #However, computer uses this to check for blocks on move 4
            return ''
        else
            case lastmoveindex / 3
            #Determine row to check
            when 0
                if CheckWinTopRow() then return @currentturn end
            when 1
                if CheckWinCenterRow() then return @currentturn end
            when 2
                if CheckWinBottomRow() then return @currentturn end
            end
            
            case lastmoveindex % 3
            #Determine column to check
            when 0
                if CheckWinLeftColumn() then return @currentturn end
            when 1
                if CheckWinMiddleColumn() then return @currentturn end
            when 2
                if CheckWinRightColumn() then return @currentturn end
            end
            
            if lastmoveindex % 2 == 0
                #Determine diagonals to check
                if lastmoveindex != 4 and lastmoveindex % 4 == 2
                    if CheckWinBottomLeftToTopRight() then return @currentturn end
                elsif lastmoveindex != 4 and lastmoveindex %4 == 0
                    if CheckWinTopLeftToBottomRight() then return @currentturn end
                elsif lastmoveindex == 4
                    if CheckWinTopLeftToBottomRight() then return @currentturn end    
                    if CheckWinBottomLeftToTopRight() then return @currentturn end
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
if t.player2.type == 'computer' then t.SelectDifficulty() end
if not t.exit then t.PrintInstructions() end

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

#Always thank your supporters
puts "Thanks for playing!"
