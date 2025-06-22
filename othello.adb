 -- Dette er et program som emulerer spillet Othello i terminalen		
with Ada.Text_Io; use Ada.Text_Io;   
with Othellolib; use Othellolib;     
                                   
               
procedure Othello is                                      	  
--Declaration de variables de départ			
Active_Player : Player_Turn := O_Move;       
Game_Won : Boolean := False;
Board : T_Board := (others => (others => ' '));  	  		
begin          
           -- Définition de la tableau initiale
           Board(4,4) := 'O'; Board(5,5) := 'O';     
           Board(4,5) := 'X'; Board(5,4) := 'X';     
           for I in Board'Range(1) loop 
               Board(I,0) := Character'Val(Character'Pos('0') + I);     
               Board(0,I) := Character'Val(Character'Pos('0') + I);     
           end loop;      
                           
           while not Game_Won loop  
                 Maintenence(Board, Game_Won, Active_Player);
                 Show_Board(Board); 
                 Make_Move(Board, Active_Player);  
           end loop;
                                                                                       
end Othello;      	 	  
