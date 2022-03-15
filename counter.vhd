library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

entity timer is 
    port(Clk, Reset, M, S, Start_Stop : in std_logic; 
        OutputS, OutputM : out std_logic_vector(6 downto 0);
        sec,min,sec1,sec2,min1,min2: inout integer;
        af0,af1,af2,af3:out std_logic_vector(6 downto 0);
        led: out std_logic := '0');
end timer;  

architecture architecture_timer of timer is    
    constant DELAY : time := 60 ns;
    signal tmpS: std_logic_vector(6 downto 0); 
    signal tmpM: std_logic_vector(6 downto 0); 
    
    signal Ssec1: std_logic_vector (3 downto 0);     
    signal Ssec2: std_logic_vector (3 downto 0);
    signal Smin1: std_logic_vector (3 downto 0);     
    signal Smin2: std_logic_vector (3 downto 0);
    
    
    
    component bcd_7segment is
        Port ( BCDin : in STD_LOGIC_VECTOR (3 downto 0);
            Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
    
begin  	 
	
    process (Clk, Start_Stop,M,S,Reset)  
    variable sled: std_logic := '0';
    variable cd:bit:='0';    
    variable st:bit:='0';    
    begin 
        if (Reset = '1') then 
            tmpS <= "0000000"; 
            tmpM <= "0000000";
            
        elsif (S'event) then
            if(M'event) then
                tmpS <= "0000000"; 
                tmpM <= "0000000";    
                cd := '0';
                st := '1';
            
                
            else
                tmpS <= tmpS +1;
                cd := '1' ;    
                st := '0';
                
            end if;
            
        elsif (M'event ) then
            if(S'event)    then
                tmpS <= "0000000"; 
                tmpM <= "0000000";    
                cd := '0';
                st := '1';
                
            else
                tmpM <= tmpM + 1; 
                cd := '1';  
                st := '0';
                
            end if;
            
        elsif(cd = '1' and rising_edge(Clk)) then
            if(Start_Stop = '0') then
                if( tmpS = "0000000") then
                    tmpS <= "0111011"; 
                    tmpM <= tmpM - 1;
                    
                 elsif(tmpM = "0000000" and tmpS = "0000001") then 
                      tmpM <= "0000000";   
                      tmpS <= "0000000";
                      cd:='0'; 
                        sled := '1';       
                        
                else 
                    tmpS <= tmpS - 1;  
                end if;    
                
            else
                tmpS <= tmpS;
                tmpM <= tmpM;
            end if;
            
            
        elsif (rising_edge(Clk)) then 
            if (Start_Stop = '1' and st = '0') then 
                if( tmpS = "0111011") then
                    tmpS <= "0000000";
                    
                    if(tmpM = "1100011") then
                        tmpM <= "0000000";
                        
                    else 
                        tmpM <= tmpM + 1;     
                        
                    end if;
                    
                else
                    tmpS <= tmpS + 1;
                    
                end if;          
            end if;    
            st:= '0';
        end if;	 

if (sled = '1') then	

  led <= '1' after 0 ns, (not sled) after DELAY;   
  sled := '0';
end if; 

		 
    end process;   

 
    OutputS <= tmpS;     
    OutputM <= tmpM;
	
    sec <= to_integer(unsigned(tmpS));     
    min <= to_integer(unsigned(tmpM)); 
    
    sec1 <= sec mod 10;    
    sec2 <= sec/10;
    
    min1 <= min mod 10;
    min2 <= min/10;    
    
    
    Ssec1 <= std_logic_vector(to_signed(sec1, Ssec1'length));  
    Ssec2 <= std_logic_vector(to_signed(sec2, Ssec2'length));  
    Smin1 <= std_logic_vector(to_signed(min1, Smin1'length)); 
    Smin2 <= std_logic_vector(to_signed(min2, Smin2'length));
    
    
    c1: bcd_7segment port map (Ssec1, af0);     
    c2: bcd_7segment port map (Ssec2, af1);
    c3: bcd_7segment port map (Smin1, af2);
    c4: bcd_7segment port map (Smin2, af3);
    
end architecture_timer; 

