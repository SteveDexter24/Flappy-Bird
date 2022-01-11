library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pmodssd is
    Port (
        clk: in std_logic; 
        sel: buffer std_logic := '0'; 
        ssd: out std_logic_vector(6 downto 0);
        value: in integer
        );
end pmodssd;

architecture Behavioral of pmodssd is

signal digit: integer;
signal clk_100Hz: std_logic:='0';
signal count_100hz : integer := 0;
begin

-- display the digits in set mode using switch
Clock100Hz: process(clk) begin
    if(rising_edge(clk)) then
        if(count_100hz = (500000 - 1)) then
            clk_100Hz <= not clk_100Hz;
            count_100hz <= 0;
        else
            count_100hz <= count_100hz + 1;
        end if;
    end if;
end process Clock100Hz;  

Display_Digits: process(clk_100Hz) begin
    if(rising_edge(clk_100Hz)) then
	   sel <= not sel;
       if(sel = '0') then
            digit <= value / 10;
        else
            digit <= value mod 10;  
        end if;
    end if;
end process Display_Digits;

-- display the digits in set mode    
process(digit) begin
    case digit is 
        when 0 => ssd <= "1111110";
        when 1 => ssd <= "0110000";
        when 2 => ssd <= "1101101";
        when 3 => ssd <= "1111001";
        when 4 => ssd <= "0110011";
        when 5 => ssd <= "1011011";
        when 6 => ssd <= "1011111";
        when 7 => ssd <= "1110000";
        when 8 => ssd <= "1111111";
        when 9 => ssd <= "1111011";
        when others => ssd <= "0000000";
    end case;
end process;


end Behavioral;
