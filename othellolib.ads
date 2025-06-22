package OthelloLib is

   type Search_Direction is (Up_Left  ,Up    ,Up_Right,    
                             Left            ,Right,       
                             Down_Left ,Down ,Down_Right);

   subtype Board_Index is Integer range 1 .. 8;
   type Position is record
      Lin : Board_Index;
      Col : Board_Index;
   end record;

   type Player_Turn is (O_Move, X_Move);

   type T_Board is array (0 .. 8, 0 .. 8) of Character;
   
   procedure Show_Board (Board : in T_Board);   
             
   procedure Maintenence (Board     : in T_Board; 
                          Game_Over : in out Boolean;  
                          Player    : in Player_Turn); 
    
   function Ask_Where return Position;    
            
   procedure Check_Recursive ( Board            : in out T_Board;   
                               Now              : in Position;      
                               Direction        : in Search_Direction;   
                               Player,Adversary : in Character;   
                               Found            : out Boolean);
            
   function Check_Valid (Board          : in out T_Board;
                         Where          : in Position;  
                         Active_Player  : in Player_Turn) 
   return Boolean;
            
   procedure Make_Move (Board           : in out T_Board;    
                        Active_Player   : in out Player_Turn);
          
        
        
end OthelloLib;
 
