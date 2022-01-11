library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_controller is
    Port (clk: in std_logic; 
        hsync, vsync: out std_logic;
        vcount, hcount: buffer integer 
        );
end vga_controller;

architecture Behavioral of vga_controller is

-- row constants
constant H_TOTAL: integer:= 1344 - 1;
constant H_SYNC: integer:= 48 - 1;
constant H_BACK: integer:= 240 - 1;
constant H_START: integer:= 48 + 240 - 1;
constant H_ACTIVE: integer:= 1024 - 1;
constant H_END: integer:= 1344 - 32 - 1;
constant H_FRONT: integer:= 32 - 1;

-- column constants
constant V_TOTAL: integer:= 625 - 1;
constant V_SYNC: integer:= 3 - 1;
constant V_BACK: integer:= 12 - 1;
constant V_START: integer:= 3 + 12 - 1;
constant V_ACTIVE: integer:= 600 - 1;
constant V_END: integer:= 625 - 10 - 1;
constant V_FRONT: integer:= 10 - 1;

signal clk50MHz: std_logic;

begin

vga_clk: process(clk) begin
    if(rising_edge(clk)) then
        clk50MHz <= not clk50MHz;
    end if;
end process vga_clk;

-- horizontal counter
pixel_count_proc: process(clk50MHz) begin
    if( rising_edge(clk50MHz) ) then
        if(hcount = H_TOTAL) then
            hcount <= 0;
        else
            hcount <= hcount + 1;
        end if;
    end if;
end process pixel_count_proc;

-- generate hsync
hsync_gen_proc: process(hcount) begin
    if(hcount < H_SYNC) then
        hsync <= '1';
    else
        hsync <= '0';
    end if;
end process hsync_gen_proc;

-- vertical counter
line_count_proc: process(clk50MHz)
begin
    if( rising_edge(clk50MHz) ) then
        if(hcount = H_TOTAL) then
            if(vcount = V_TOTAL) then
                vcount <= 0;
            else
                vcount <= vcount + 1;
            end if;
        end if;
    end if;
end process line_count_proc;

-- generate vsync
vsync_gen_proc: process(hcount)
begin
    if(vcount < V_SYNC) then
        vsync <= '1';
    else
        vsync <= '0';
    end if;
end process vsync_gen_proc;



end Behavioral;
