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

 
   procedure Check_Recursive (
      Board         : in out T_Board;
      Now           : in Position;
      Direction     : in Search_Direction;
      Player        : in Character;
      Adversary     : in Character;
      Found         : out Boolean
   ) is
      Next : Position;
   begin
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

      if Next.Lin not in 1 .. 8 or Next.Col not in 1 .. 8 then
         Found := False;
         return;
      end if;

      declare
         Cell : Character := Board(Next.Lin, Next.Col);
      begin
         if Cell = ' ' then
            Found := False;
         elsif Cell = Player then
            Found := True;
         elsif Cell = Adversary then
            Check_Recursive(Board, Next, Direction, Player, Adversary, Found);
            if Found then
               Board(Next.Lin, Next.Col) := Player;
            end if;
         else
            Found := False;
         end if;
      end;
   end Check_Recursive;

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


   procedure Make_Move (
      Board         : in out T_Board;
      Active_Player : in out Player_Turn
   ) is
      Where       : Position;
      Valid_Move  : Boolean;
   begin          
                  
      Where := Ask_Where;                            
      if Board(Where.Lin, Where.Col) /= ' ' then
          Put_Line("Opptatt, prøv igjen bitch!.");
          return;
      end if;

      Valid_Move := Check_Valid(Board, Where, Active_Player);
                 
      if Valid_Move and Active_Player = O_Move then
         Board(Where.Lin, Where.Col) := 'O';
         Active_Player := X_Move;

       elsif Valid_Move and Active_Player = X_Move then
         Board(Where.Lin, Where.Col) := 'X';
         Active_Player := O_Move;

       else
          Put_Line("Invalid move, try again");
         end if;
   end Make_Move;

end OthelloLib;
