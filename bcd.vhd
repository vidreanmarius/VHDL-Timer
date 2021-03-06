 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_7segment is
	Port ( BCDin : in STD_LOGIC_VECTOR (3 downto 0);
		Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0));
end bcd_7segment;

architecture Behavioral of bcd_7segment is

begin

process(BCDin)
begin

case BCDin is
	when "0000" =>
	Seven_Segment <= "0000001"; --0 ->	1
	
	when "0001" =>
	Seven_Segment <= "1001111"; --1 ->	159
	
	when "0010" =>
	Seven_Segment <= "0010010"; --2	-> 18
	
	when "0011" =>
	Seven_Segment <= "0000110"; --3	-> 6
	
	when "0100" =>
	Seven_Segment <= "1001100"; --4	-> 76 
	
	when "0101" =>
	Seven_Segment <= "0100100"; --5	-> 36
	
	when "0110" =>
	Seven_Segment <= "0100000"; --6 -> 32
	
	when "0111" =>
	Seven_Segment <= "0001111"; --7	-> 15
	
	when "1000" =>
	Seven_Segment <= "0000000"; --8 -> 0
	
	when "1001" =>
	Seven_Segment <= "0000100"; --9	-> 4
	
	when others =>
	Seven_Segment <= "1111111"; --oprit	 
	
end case;

end process;

end Behavioral;
