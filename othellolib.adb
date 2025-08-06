with Ada.Text_IO; use Ada.Text_IO;

package body OthelloLib is -- Used to define this as a library to be used in Othello.adb

   package Int_IO is new Ada.Text_IO.Integer_IO (Integer);
   use Int_IO;

-- This is a procedure that is used to display the board in the terminal
   procedure Show_Board(Board : in T_Board) is
   begin
      for Lin in Board'Range(1) loop -- Loops through all the lines of the board
         for Col in Board'Range(2) loop -- Loops though all the rows of the board
            Put("[" & Board(Lin, Col) & "]"); -- Prints the content of the cell
         end loop;
         New_Line; -- After a row has been completed it breaks the line and starts a new
      end loop;
      New_Line;
   end Show_Board;   

-- This is a function that handles everything that is needed between
   procedure Maintenence (Board     : in T_Board;   
                          Game_Over : in out Boolean;  
                          Player    : in Player_Turn     
   ) is  
     Nb_O,Nb_X,Nb_null : Integer := 0; -- Initialize the numbers that will be used to count the number of O's X's and empty squares            
   begin
      -- A loop that is used to count the number of each type of square between every round
      for Lin in Board'Range(1) loop   
         for Col in Board'Range(2) loop   
             if Board(Lin,Col) = 'X' then 
                Nb_X := Nb_X + 1;  
             elsif Board(Lin,Col) = 'O' then 
                Nb_O := Nb_O + 1; 
             else    
                Nb_Null := Nb_Null + 1;   
             end if;    
         end loop;      
     end loop;    

     -- Prints to terminal what player's move it is    
     if Player = O_Move then  
        Put_Line("O to move");   
     else           
        Put_Line("X to move");   
     end if;        

     -- Updates the Scores and prints to terminal
     Put_Line("O : " & Integer'Image(Nb_O)); 
     Put_Line("X : " & Integer'Image(Nb_X)); 

     -- Checks to see if all squares are covered, if they are game is over
     if Nb_X + Nb_O = 64 then 
        Game_Over := True;    
        if Nb_O > Nb_X then   
           Put_Line("White wins");  -- White wins
        elsif Nb_O < Nb_X then      
           Put_Line("Black wins");  -- Black wins
        else               
           Put_Line("Game tied"); 
        end if;  
     end if;
   end Maintenence;

   -- Function that asks from standard input where the player wants to move next
   -- Returns a tuple called position
   function Ask_Where return Position is
      P : Position;
   begin
      Put("Hvilken rad? (1–8): ");
      Get(P.Lin); -- Gets the line standard input
      Put("Hvilken kolonne? (1–8): ");
      Get(P.Col);  -- Gets the row from standard input
      return P;
   end Ask_Where;

   -- this is is a function that first checks if a move is legal or not, 
   -- if it is it will turn all the pieces to the color of Player
   -- if not, it will not turn any pieces
   procedure Check_Recursive (
      Board         : in out T_Board;         -- The current game board
      Now           : in Position;            -- A square (Where the last piece was placed, but will change with every iteration)
      Direction     : in Search_Direction;    -- The direction of which we'll check recursivly
      Player        : in Character;           -- Active player (White or black)
      Adversary     : in Character;           -- Inactive player (White or black)
      Found         : out Boolean             -- A boolean that is set to true if the move is legal
   ) is
      Next : Position;                        -- The square that will be checked next iteration (depens on Direction)
   begin
         -- This is a case that will define the variable next depending on what direction we're checking
      case Direction is
         when Up_Left     => Next := (Lin => Now.Lin - 1, Col => Now.Col - 1);
         when Up          => Next := (Lin => Now.Lin - 1, Col => Now.Col    );
         when Up_Right    => Next := (Lin => Now.Lin - 1, Col => Now.Col + 1);
         when Right       => Next := (Lin => Now.Lin    , Col => Now.Col + 1);
         when Down_Right  => Next := (Lin => Now.Lin + 1, Col => Now.Col + 1);
         when Down        => Next := (Lin => Now.Lin + 1, Col => Now.Col    );
         when Down_Left   => Next := (Lin => Now.Lin + 1, Col => Now.Col - 1);
         when Left        => Next := (Lin => Now.Lin    , Col => Now.Col - 1);
      end case;

      -- Checks if we're out of bounds
      if Next.Lin not in 1 .. 8 or Next.Col not in 1 .. 8 then
         Found := False; -- Since we have not encoutered a piece of our own colour and there is no more pieces to check we set found to False
         return;
      end if;

      -- Now that we know our next piece is within bounds we check to see what type of Charachter is confined within the "cell" at it's coordinates
      declare
         Cell : Character := Board(Next.Lin, Next.Col);
      begin
         if Cell = ' ' then -- There is nothing there, we stop the recursion there is nothing more to check
            Found := False;
         elsif Cell = Player then
            Found := True;  -- We found ourselves! We set Found to true so we turn the pieces when redecending the recursive tree
         elsif Cell = Adversary then -- We found an enemy piece, we have to keep looking
            Check_Recursive(Board, Next, Direction, Player, Adversary, Found); -- We call upon the function to keep looking

            if Found then -- This is the code that facilitates the turning of the pieces as we redecend the recursive tree
               Board(Next.Lin, Next.Col) := Player;
            end if;

         else -- This is redundant
            Found := False;
         end if;
      end;
   end Check_Recursive;


-- This function checks if a move is valid, and if it is it calls upon the check_recursive procedure to turn the pieces
function Check_Valid (
   Board         : in out T_Board;
   Where         : in Position;
   Active_Player : in Player_Turn
) return Boolean is
   Is_Valid         : Boolean := False;
   Found            : Boolean := False;
   Player, Adversary : Character;
begin
   if Active_Player = O_Move then
      Player    := 'O';
      Adversary := 'X';
   else
      Player    := 'X';
      Adversary := 'O';
   end if;


   -- This is the part of the code I'm least proud of, I since know how to write cleaner code
   -- I however will be leaving it as is because this was my first ever project, and it's an example of something I learned the hard way "not to do"
   -- When i made this I could not get a for loop with every direction to work since the out of bounds check varies, I did not think to pair them up, so it left me with this

   -- It checks that you won't be going out of bounds by calling upon check_recursive, if you won't I calls upon the check recursive to turn the pieces
   -- If for some reason none of the directions work it stores False in Is_Valid so we can later ask the player to find another move
   -- UP-LEFT
   if Where.Lin > 2 and Where.Col > 2 then
      if Board(Where.Lin - 1, Where.Col - 1) = Adversary then
         Check_Recursive(Board, Where, Up_Left, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- UP
   if Where.Lin > 2 then
      if Board(Where.Lin - 1, Where.Col) = Adversary then
         Check_Recursive(Board, Where, Up, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- UP-RIGHT
   if Where.Lin > 2 and Where.Col < 7 then
      if Board(Where.Lin - 1, Where.Col + 1) = Adversary then
         Check_Recursive(Board, Where, Up_Right, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- RIGHT
   if Where.Col < 7 then
      if Board(Where.Lin, Where.Col + 1) = Adversary then
         Check_Recursive(Board, Where, Right, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- DOWN-RIGHT
   if Where.Lin < 7 and Where.Col < 7 then
      if Board(Where.Lin + 1, Where.Col + 1) = Adversary then
         Check_Recursive(Board, Where, Down_Right, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- DOWN
   if Where.Lin < 7 then
      if Board(Where.Lin + 1, Where.Col) = Adversary then
         Check_Recursive(Board, Where, Down, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- DOWN-LEFT
   if Where.Lin < 7 and Where.Col > 2 then
      if Board(Where.Lin + 1, Where.Col - 1) = Adversary then
         Check_Recursive(Board, Where, Down_Left, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   -- LEFT
   if Where.Col > 2 then
      if Board(Where.Lin, Where.Col - 1) = Adversary then
         Check_Recursive(Board, Where, Left, Player, Adversary, Found);
         if Found then
            Is_Valid := True;
         end if;
      end if;
   end if;
   return Is_Valid;
end Check_Valid;

   -- This is the procedure that ties it all together to make a move
   procedure Make_Move (
      Board         : in out T_Board;
      Active_Player : in out Player_Turn
   ) is
      Where       : Position;
      Valid_Move  : Boolean;
   begin          

      -- Uses Ask_Where function to return a tuple coordinate and checks if the square isn't already occupied
      -- If occupied, return nothing
      -- If not Continue
      Where := Ask_Where;                            
      if Board(Where.Lin, Where.Col) /= ' ' then
          Put_Line("Square Occupied! Try again please!.");
          return;
      end if;

      -- Now that we know the square is empty we check if the move is valid
      -- Funnily enough, due to my bad naming scheme, the function that checks if it's valid also makes the changes on the board nessecary
      -- This I would make sure not to do today
      Valid_Move := Check_Valid(Board, Where, Active_Player);

      -- The Valid_Move function only turns the already places pieces,
      -- If it turns out the move was valid we have to draw the actual piece placed,
      -- If a piece is placed we also swap Active_Player
      if Valid_Move and Active_Player = O_Move then
         Board(Where.Lin, Where.Col) := 'O';  -- Draw piece
         Active_Player := X_Move;  -- Switch turn

       elsif Valid_Move and Active_Player = X_Move then
         Board(Where.Lin, Where.Col) := 'X'; - Draw piece
         Active_Player := O_Move; -- Switch turn

       else
          Put_Line("Invalid move, try again"); -- No move was made, nothing is done
         end if;
   end Make_Move;

end OthelloLib;
