


#ConwayGame Class
class ConwaysGame
  #public get symbols
  attr_reader :row, :column, :board, :bufferBoard, :input
  
  #inilializtion blocl
  def initialize(row, column, input)
    @row = row.to_i
    @column = column.to_i
    @input = input.map{|e| e.nil? ? ' ': e.chomp }
  end
  
  #public method start  
  #params <None - return type <None>
  def start
    #method calls for Create and Print initial boardboard
    createBoard
    printBoard
    puts "\e[H\e[2J"
    #loop 10 times 
    #process board and print
    10.times do
      processBoard
      printBoard
    end
  end
  
  #private methods
  private
  
  #priate method Create board
  #params None, Return None
  #creates two boards(2d array) over rows and columns
  #fills the first board and use second board as buffer to work on
  def createBoard
    @board = Array.new(row.to_i) {Array.new(column.to_i) {"-"}}
    @bufferBoard = Array.new(row.to_i) {Array.new(column.to_i) {"-"}}
    
    #loop through board and fill it with file data 
    #line by line
    for i in 0..(row.to_i - 1)
      k = 0
      unless input.size == 0
        input.shift.split("").each do |val|
          board[i][k] = (val == "*" ? "*" : " ")
          k = k + 1;
        end
      end
      
      #if input file does not match the array dim 
      #then fill it with blanks
      while k < (column.to_i ) do
          board[i][k] = " "
          k = k + 1
      end
    end
  end

  
  #private method Prints the board to Std output
  #loops through two dim array over i and j and prints 
  #once loop is done its print end of line and a seprator =
  def printBoard
    for i in 0..(row.to_i - 1)
      for j in 0..(column.to_i - 1)
        print board[i][j]
      end
      puts ""
    end 
    
    column.times do
      print "="
    end
    puts ""
  end
  
  
  #private method decides cells next state
  #params: current value (char) and countNeighbours (int)
  #returns Live or Dead state "*" or " "
  def conwayFunction(curValue, countNeighbors)
    if curValue == "*"   # is alive 
      if countNeighbors == 2 || countNeighbors == 3   #2 or 3 neighbours
        return "*"
      else
        return " "
      end
    end
    if curValue != "*" #dead
      if countNeighbors == 3 #three neighbours
        return "*"
      else
        return " "
      end
    end
  end
  
  #private method processes the board
   #params: none
   #returns none
  def processBoard
     count = 0
     
     #loop thrugh the board array and process
      for i in 0..(row - 1)
        for j in 0..(column - 1)
          #gets valid neighours for current Cell
          loc = valid_locations(i,j)
           
           #Count live neighbours
          loc.each do |l|
            count += 1 if board[l[0]] [l[1]] == "*"
          end
          
          #fill put buffer with the next value for current cell
          #use conwayFunction to make decision 
          @bufferBoard[i][j] = conwayFunction(board[i][j], count)
          count = 0
        end
      end

      #dump buffer into board array 
       for i in 0..(row - 1)
          for j in 0..(column - 1)
           @board[i][j] = @bufferBoard[i][j]
          end
        end
  end
  
  #private method Defines all the valid Neighbours for a Cell
  #params: r (int)  and c (int)
  #returns an array of all valid cordinates 
  def valid_locations(r, c)
     positions = []
    #top row
     positions << [r - 1, c - 1]
     positions << [r - 1, c]
     positions << [r - 1, c + 1]

     #center row
     positions << [r, c-1]
     positions << [r, c + 1]

     #bottom row
     positions << [r + 1, c - 1]
     positions << [r + 1, c]
     positions << [r + 1, c + 1]
     
     #array boundry Check on the list of positions to find those that are on the board
     positions.delete_if {|v| v[0] < 0 || v[0] >= row}.delete_if{|v| v[1] < 0 || v[1] >= column}
     return positions
   end
end



#Class defined above
#Process with Process Flow
#open file Read and fill it in an input array
input = [] 
File.open('./life.txt').each do |line|
  input << line
end

#take the first line of input
#use split it and use it as x y cords
x , y = input.shift.split " "

#create class instance 
game = ConwaysGame.new(x, y, input)

#process class
game.start

