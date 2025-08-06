-- Othello game
with Ada.Text_Io; use Ada.Text_Io;   -- Library used to display text
with Othellolib; use Othellolib;     -- Library with my own game logic
                                   
               
procedure Othello is                                      	  
Active_Player : Player_Turn := O_Move;       -- Player O starts the game
Game_Won : Boolean := False;                 -- Game state set to not won
Board : T_Board := (others => (others => ' '));  	  		-- Makes an empty board
begin          
           -- Defines the board with the starting pieces
           Board(4,4) := 'O'; Board(5,5) := 'O';     
           Board(4,5) := 'X'; Board(5,4) := 'X';
           -- This adds numbers to the side of the board so it's easier to place your pieces
           for I in Board'Range(1) loop 
               Board(I,0) := Character'Val(Character'Pos('0') + I);     
               Board(0,I) := Character'Val(Character'Pos('0') + I);     
           end loop;      

           -- Main game loop
           while not Game_Won loop  
                 Maintenence(Board, Game_Won, Active_Player);  -- Update everything that is displayed
                 Show_Board(Board); -- Show the board
                 Make_Move(Board, Active_Player);  -- Makes the move
           end loop;
                                                                                       
end Othello;      	 	  
