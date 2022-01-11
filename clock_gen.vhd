library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_gen is
    Port (clk: in std_logic; clk100Hz, clk250Hz, clk150Hz, clk200Hz: buffer std_logic);
end clock_gen;

architecture Behavioral of clock_gen is
signal count100, count250, count150, count200: integer := 0;
begin

Clock100Hz: process(clk) begin
    if(rising_edge(clk)) then
        if (count100 = (500000 - 1)) then
            clk100Hz <= not clk100Hz;
            count100 <= 0;
        else
            count100 <= count100 + 1;
        end if;
    end if;
end process Clock100Hz;

Clock250Hz: process(clk) begin
    if(rising_edge(clk)) then
        if (count250 = (200000 - 1)) then
            clk250Hz <= not clk250Hz;
            count250 <= 0;
        else
            count250 <= count250 + 1;
        end if;
    end if;
end process Clock250Hz;

Clock150Hz: process(clk) begin
    if(rising_edge(clk)) then
        if (count150 = (333333 - 1)) then
            clk150Hz <= not clk150Hz;
            count150 <= 0;
        else
            count150 <= count150 + 1;
        end if;
    end if;
end process Clock150Hz;

Clock200Hz: process(clk) begin
    if(rising_edge(clk)) then
        if (count200 = (250000 - 1)) then
            clk200Hz <= not clk200Hz;
            count200 <= 0;
        else
            count200 <= count200 + 1;
        end if;
    end if;
end process Clock200Hz;

end Behavioral;
