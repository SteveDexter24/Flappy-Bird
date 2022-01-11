library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_Std.ALL;

entity flappy_bird is
  Port (
      clk: in  std_logic;
      BTNC, BTNR, BTND: in  std_logic;
      hsync, vsync: out std_logic;
      sel: buffer std_logic := '0';
      ssd: out std_logic_vector(6 downto 0);
      red, green, blue : out std_logic_vector(3 downto 0);
      sw: in std_logic_vector(1 downto 0)
    );
end flappy_bird;

architecture Behavioral of flappy_bird is

constant H_START: integer:= 48 + 240 - 1;
constant H_END: integer:= 1344 - 32 - 1;

constant V_START: integer:= 3 + 12 - 1;
constant V_END: integer:= 625 - 10 - 1;

signal hcount, vcount: integer;

signal clk100Hz, clk250Hz, clk150Hz, clk200Hz, clock_signal: std_logic;

signal ground_x: integer := H_START;

-- ground range V_END - 25 to V_END
signal ground_y: integer := V_END - 30;

signal sky_x: integer := H_START;
signal sky_y: integer := V_END - 25;

signal p1xs: integer := H_END - 60 - 341;
signal p1xe: integer := H_END - 341;

signal p2xs: integer := H_END;
signal p2xe: integer := H_END + 60;

signal p3xs: integer := H_END + 341;
signal p3xe: integer := H_END + 60 + 341;

signal p1ys: integer := V_START + 150;
signal p2ys: integer := V_START + 100;
signal p3ys: integer := V_START + 200;
signal gap, gap1, gap2, gap3: integer := 200;

signal timerCounter: integer := 0;

constant bird_width: integer:= 23;
constant bird_height: integer:= 25;

constant text_height: integer:= 59;
constant text_width: integer:= 595;

-- Bird area box
signal b_start_x: integer := H_START + 120;
signal b_end_x: integer := H_START + 120 + bird_width;
signal b_start_y: integer := V_START + 285;
signal b_end_y: integer := V_START + 285 + bird_height;

-- Text Area
signal t_start_x: integer := H_START + 236;
signal t_end_x: integer := H_START + 236 + text_width;
signal t_start_y: integer := V_START + 180;
signal t_end_y: integer := V_START + 180 + text_height;

-- Text Area 2
constant playHeight: integer := 29;
constant playWidth: integer := 269;

signal t2_start_x: integer := H_START + 400;
signal t2_end_x: integer := H_START + 400 + playWidth;
signal t2_start_y: integer := V_START + 300;
signal t2_end_y: integer := V_START + 300 + playHeight;

-- Text Area 3
constant gameOverHeight: integer := 39;
constant gameOverWidth: integer := 323;

signal t3_start_x: integer := H_START + 361;
signal t3_end_x: integer := H_START + 361 + gameOverWidth;
signal t3_start_y: integer := V_START + 280;
signal t3_end_y: integer := V_START + 280 + gameOverHeight;


-- Text Area 4
constant playAgainHeight: integer := 19;
constant playAgainWidth: integer := 287;

signal t4_start_x: integer := H_START + 400;
signal t4_end_x: integer := H_START + 400 + playAgainWidth;
signal t4_start_y: integer := V_START + 400;
signal t4_end_y: integer := V_START + 400 + playAgainHeight;


-- Cloud and pos
type cloud_small2D is array(0 to 26, 0 to 38) of integer;
signal cloud_small: cloud_small2D;

type cloud_large2D is array(0 to 35, 0 to 51) of integer;
signal cloud_large: cloud_large2D;

type cloud_xl2D is array(0 to 53, 0 to 77) of integer;
signal cloud_xl: cloud_xl2D;

constant cloud_s_height: integer := 26;
constant cloud_s_width: integer:= 38;

constant cloud_l_height: integer := 35;
constant cloud_l_width: integer:= 51;

constant cloud_xl_height: integer := 53;
constant cloud_xl_width: integer := 77;

signal cs_start_x: integer := H_START + 100;
signal cs_end_x: integer := H_START + 100 +  cloud_s_width;
signal cs_start_y: integer := V_START + 50;
signal cs_end_y: integer := V_START + 50 + cloud_s_height;

signal cl_start_x: integer := H_START + 400;
signal cl_end_x: integer := H_START + 400 +  cloud_l_width;
signal cl_start_y: integer := V_START + 20;
signal cl_end_y: integer := V_START + 20 + cloud_l_height;

signal cxl_start_x: integer := H_START + 800;
signal cxl_end_x: integer := H_START + 800 +  cloud_xl_width;
signal cxl_start_y: integer := V_START + 80;
signal cxl_end_y: integer := V_START + 80 + cloud_xl_height;

-- another set of clouds
signal cs1_start_x: integer := H_START + 130;
signal cs1_end_x: integer := H_START + 130 +  cloud_s_width;
signal cs1_start_y: integer := V_START + 80;
signal cs1_end_y: integer := V_START + 80 + cloud_s_height;

signal cl1_start_x: integer := H_START + 350;
signal cl1_end_x: integer := H_START + 350 +  cloud_l_width;
signal cl1_start_y: integer := V_START + 80;
signal cl1_end_y: integer := V_START + 80 + cloud_l_height;

-- Large Angry Bird position and size
constant ab_height: integer := 143;
constant ab_width: integer := 149;

signal ab_start_x: integer := H_START + 450;
signal ab_end_x: integer := H_START + 450 + ab_width;
signal ab_start_y: integer := V_START + 380;
signal ab_end_y: integer := V_START + 380 + ab_height;

type largeAB is array(0 to 143, 0 to 149) of integer;
signal angryBirdLarge: largeAB;

type angry2D is array(0 to 23, 0 to 25) of integer range 0 to 9;
signal bird: angry2D;

type flappyWord is array (0 to 59, 0 to 593) of integer;
signal flappy_W: flappyWord;

type play2D is array(0 to 29, 0 to 269) of integer;
signal play_W: play2D;

type end2D is array(0 to 39, 0 to 323) of integer;
signal end_W: end2D;

type playAgain2D is array(0 to 19, 0 to 287) of integer;
signal playAgain_W: playAgain2D;

type INT_ARRAY is array (integer range <>) of integer;
signal pipe_ran: INT_ARRAY(0 to 99);
signal pipe_count: integer := 0;

-- Components
component clouds is
    Port (cloud_small: out cloud_small2D; cloud_large: out cloud_large2D; cloud_xl: out cloud_xl2D);
end component;

component largeAngryBird is
    Port (angryBirdLarge: out largeAB );
end component;

component flappy is
    Port (flappy_W: out flappyWord );
end component;

component play is
    Port (play_W: out play2D);
end component;

component gameover is
    Port (end_W: out end2D);
end component;

-- Angry Bird
component angryBird is
      Port (bird: out angry2D );
end component;


component pmodssd
    Port (
        clk: in std_logic; 
        sel: buffer std_logic := '0'; 
        ssd: out std_logic_vector(6 downto 0);
        value: in integer
        );
end component;

component clock_gen is
    Port (clk: in std_logic; clk100Hz, clk250Hz, clk150Hz, clk200Hz: buffer std_logic);
end component;

component playAgain is
    Port (playAgain_W: out playAgain2D );
end component;

component pipe is
    Port (pipe_ran: out INT_ARRAY);
end component;

component vga_controller is
    Port (clk: in std_logic; 
        hsync, vsync: out std_logic;
        vcount, hcount: buffer integer 
        );
end component;

signal value: integer := 0;

-- states
type state_type is (splash_screen, game_play, end_screen);
signal game_state: state_type:=splash_screen;

begin

--bird_img: bird_image port map(bird);
birdImg: angryBird port map(bird);
pipe_display: pipe port map(pipe_ran);
clock_100hz: clock_gen port map (clk, clk100Hz, clk250Hz, clk150Hz, clk200Hz);
vga: vga_controller port map (clk, hsync, vsync, vcount, hcount);
score: pmodssd port map (clk, sel, ssd, value);
texttop: flappy port map (flappy_W); -- OK
textRight: play port map(play_W);  -- Alignment issue resolved
endOfGame: gameover port map(end_W); -- OK
gameClouds: clouds port map (cloud_small, cloud_large, cloud_xl);
tryAgain: playAgain port map(playAgain_W);
largeABird: largeAngryBird port map(angryBirdLarge);

-- Game FSM
process(clk100Hz, game_state) begin
    if(rising_edge(clk100Hz)) then
        case game_state is
            when splash_screen => 
                if (BTNR = '1') then
                    game_state <= game_play;
                end if;
            when game_play => 
                if ((b_end_x > p1xs and b_start_x < p1xe) and (b_start_y < p1ys or b_end_y > p1ys + gap)) or
                   ((b_end_x > p2xs and b_start_x < p2xe) and (b_start_y < p2ys or b_end_y > p2ys + gap)) or
                   ((b_end_x > p3xs and b_start_x < p3xe) and (b_start_y < p3ys or b_end_y > p3ys + gap)) or
                   ((b_end_y > V_END and vcount <= ground_y) or (b_start_y < V_START)) then
                   game_state <= end_screen;
                end if;
            when end_screen =>
                if(BTND = '1') then
                    game_state <= splash_screen;
                    timerCounter <= 0;
                end if;
            when others => 
                game_state <= game_state;
       end case;
    end if;
end process;

GameSpeedController: process(clock_signal, value) begin
    --if(game_state = splash_screen) then
        if(value < 10) then
            clock_signal <= clk100Hz;
        elsif(value >= 10 and value <= 12) then
            clock_signal <= clk150Hz;
        elsif(value > 12 and value <= 16) then
            clock_signal <= clk200Hz;
        else
            clock_signal <= clk250Hz;
        end if;
end process;

--GapController: process(value) begin
--    if(value = 3) then
--        gap <= gap - 5;
--    elsif (value = 10) then
--        gap <= gap - 10;
--    elsif(value = 15) then
--        gap <= gap - 10;
--    elsif(value = 17) then
--        gap <= gap - 15;
--    else
--        gap <= gap;
--    end if;
--end process;


cloud_generator: process(clock_signal) begin
    if(rising_edge(clock_signal)) then
        if(game_state = game_play) then
            -- small cloud
            if(cs_end_x > H_START) then
                cs_start_x <= cs_start_x - 1;
                cs_end_x <= cs_end_x - 1;
             else
                cs_start_x <= H_END + 80;
                cs_end_x <= H_END + 80 + cloud_s_width;
             end if;
             if(cs1_end_x > H_START) then
                cs1_start_x <= cs1_start_x - 1;
                cs1_end_x <= cs1_end_x - 1;
             else
                cs1_start_x <= H_END + 80;
                cs1_end_x <= H_END + 80 + cloud_s_width;
             end if;
             
             -- large cloud 
             if(cl_end_x > H_START) then
                cl_start_x <= cl_start_x - 1;
                cl_end_x <= cl_end_x - 1;
             else
                cl_start_x <= H_END + 100;
                cl_end_x <= H_END + 100 + cloud_l_width;
             end if;
             if(cl1_end_x > H_START) then
                cl1_start_x <= cl1_start_x - 1;
                cl1_end_x <= cl1_end_x - 1;
             else
                cl1_start_x <= H_END + 80;
                cl1_end_x <= H_END + 80 + cloud_l_width;
             end if;
             
             -- extra large cloud
             if(cxl_end_x > H_START) then
                cxl_start_x <= cxl_start_x - 1;
                cxl_end_x <= cxl_end_x - 1;
             else
                cxl_start_x <= H_END + 80;
                cxl_end_x <= H_END + 80 + cloud_xl_width;
             end if;
             
        elsif (game_state = end_screen or game_state = splash_screen) then
            cs_start_x <= H_START + 100;
            cs_end_x <= H_START + 100 +  cloud_s_width;
            cs_start_y <= V_START + 50;
            cs_end_y <= V_START + 50 + cloud_s_height; 
            
            cl_start_x <= H_START + 400;
            cl_end_x <= H_START + 400 +  cloud_l_width;
            cl_start_y <= V_START + 20;
            cl_end_y <= V_START + 20 + cloud_l_height;  
            
            cs1_start_x <= H_START + 130;
            cs1_end_x <= H_START + 130 + cloud_s_width;
            cs1_end_x <= H_START + 80;
            cs1_end_y <= V_START + 80 + cloud_s_height; 
            
            cl1_start_x <= H_START + 350;
            cl1_end_x <= H_START + 350 +  cloud_l_width;
            cl1_start_y <= V_START + 80;
            cl1_end_y <= V_START + 80 + cloud_l_height;    
            
            
            cxl_start_x <= H_START + 800;
            cxl_end_x <= H_START + 800 +  cloud_xl_width;
            cxl_start_y <= V_START + 80;
            cxl_end_y <= V_START + 80 + cloud_xl_height;
  
        end if;
    end if;
end process;


pipe_genetator: process(clock_signal) begin
    if(rising_edge(clock_signal)) then
        if (game_state = game_play) then
            -- pipe 1    
            if (p1xe > H_START) then
                p1xs <= p1xs - 1;
                p1xe <= p1xe - 1;
            else
                p1xs <= H_END;
                p1xe <= H_END + 60;
                p1ys <= pipe_ran(pipe_count);
                value <= value + 1;
                gap1 <= gap;
                pipe_count <= pipe_count + 1;
            end if;
            -- pipe 2
            if (p2xe > H_START) then
                p2xs <= p2xs - 1;
                p2xe <= p2xe - 1;
               
            else
                p2xs <= H_END;
                p2xe <= H_END + 60;
                p2ys <= pipe_ran(pipe_count);
                value <= value + 1;
                gap2 <= gap;
                pipe_count <= pipe_count + 1;
             
            end if;
            -- pipe 3
            if (p3xe > H_START) then
                p3xs <= p3xs - 1;
                p3xe <= p3xe - 1; 
            else
                p3xs <= H_END;
                p3xe <= H_END + 60;
                p3ys <= pipe_ran(pipe_count);
                value <= value + 1;
                gap3 <= gap;
                pipe_count <= pipe_count + 1;
            end if;
        elsif (game_state = end_screen or game_state = splash_screen) then
            p1xs <= H_END - 60 - 341;
            p1xe <= H_END - 341;
            p2xs <= H_END;
            p2xe <= H_END + 60;
            p3xs <= H_END + 341;
            p3xe <= H_END + 60 + 341;
            
            p1ys <= V_START + 150;
            p2ys <= V_START + 200;
            p3ys <= V_START + 100;
            
            if(game_state = splash_screen) then
                value <= 0;
            end if;
        end if;
    end if;
end process pipe_genetator;

--handle the movement of bird
bird_handle: process(clk100Hz) begin
    if(falling_edge(clk100Hz)) then
        if (game_state = game_play) then
            if(BTNC = '1') then
                b_start_y <= b_start_y - 6;
                b_end_y <= b_start_y + bird_height;
                if(b_start_y < V_START) then
                    b_start_y <= V_START + 1;
                    b_end_y <= b_start_y + bird_height;
                end if;
            else
                b_start_y <= b_start_y + 3;
                b_end_y <= b_start_y + bird_height;
                if(b_end_y > V_END) then
                    b_end_y <= V_END;
                    b_start_y <= b_end_y - bird_height;
                end if;
            end if;
        elsif (game_state = end_screen or game_state = splash_screen) then
            b_start_y <= V_START + 285;
            b_end_y <= V_START + 285 + bird_height;
        end if;
    end if;
end process bird_handle;


--display the pipeline and the bird
display_proc: process(hcount, vcount) 
variable dx, dy, tx, ty, tx2, ty2, tx3,ty3, tx4, ty4, csx, csy, clx, cly: integer;
variable cs1x, cs1y, cl1x, cl1y, cxlx, cxly, abx, aby: integer;
begin
    dx := (hcount - b_start_x);
    dy := (vcount - b_start_y);
    
    tx := (hcount - t_start_x);
    ty := (vcount - t_start_y);
    
    tx2 := (hcount - t2_start_x);
    ty2 := (vcount - t2_start_y);
    
    tx3 := (hcount - t3_start_x);
    ty3 := (vcount - t3_start_y);
    
    tx4 := (hcount - t4_start_x);
    ty4 := (vcount - t4_start_y);
    
    csx := (hcount - cs_start_x);
    csy := (vcount - cs_start_y);
    
    clx := (hcount - cl_start_x);
    cly := (vcount - cl_start_y);
    
    cs1x := (hcount - cs1_start_x);
    cs1y := (vcount - cs1_start_y);
    
    cl1x := (hcount - cl1_start_x);
    cl1y := (vcount - cl1_start_y);
    
    cxlx := (hcount - cxl_start_x);
    cxly := (vcount - cxl_start_y);
    
    abx := (hcount - ab_start_x);
    aby := (vcount - ab_start_y);

    case game_state is
        when game_play =>
            if((hcount >= p1xs and hcount <= p1xe) and (vcount >= p1ys + gap or vcount <= p1ys)) then
                red   <= "0000";
                green <= "1111";
                blue  <= "0000";
            elsif((hcount >= p2xs and hcount <= p2xe) and (vcount >= p2ys+gap or vcount <= p2ys)) then
                red   <= "1111";
                green <= "0000";
                blue  <= "0000";
            elsif((hcount >= p3xs and hcount <= p3xe) and (vcount >= p3ys+gap or vcount <= p3ys)) then
                red   <= "0000";
                green <= "0000";
                blue  <= "1111";
           
           -- display clouds TODO: similar as pipes
            elsif(hcount >= cs_start_x and hcount <= cs_end_x) and (vcount >= cs_start_y and vcount <= cs_end_y) then
                if(cloud_small(csy, csx) = 1) then
                    red <= "0000"; blue <= "0000"; green <= "0000";
                elsif(cloud_small(csy, csx) = 0) then
                    red <= "1111"; blue <= "1111"; green <= "1111";
                else
                    red <= "0000"; green <= "0101"; blue <= "0100";
                end if;
                                   
            elsif(hcount >= cl_start_x and hcount <= cl_end_x) and (vcount >= cl_start_y and vcount <= cl_end_y) then
                if(cloud_large(cly, clx) = 1) then
                    red <= "0000"; blue <= "0000"; green <= "0000";
                elsif(cloud_large(cly, clx) = 0) then
                    red <= "1111"; blue <= "1111"; green <= "1111";
                else
                    red <= "0000"; green <= "0101"; blue <= "0100";
                end if;
             -- extra large cloud
             elsif(hcount >= cxl_start_x and hcount <= cxl_end_x) and (vcount >= cxl_start_y and vcount <= cxl_end_y) then
                if(cloud_xl(cxly, cxlx) = 1) then
                    red <= "0000"; blue <= "0000"; green <= "0000";
                elsif(cloud_xl(cxly, cxlx) = 0) then
                    red <= "1111"; blue <= "1111"; green <= "1111";
                else
                    red <= "0000"; green <= "0101"; blue <= "0100";
                end if;
                -- cloud small # 2
            elsif(hcount >= cs1_start_x and hcount <= cs1_end_x) and (vcount >= cs1_start_y and vcount <= cs1_end_y) then
                if(cloud_small(cs1y, cs1x) = 1) then
                    red <= "0000"; blue <= "0000"; green <= "0000";
                elsif(cloud_small(cs1y, cs1x) = 0) then
                    red <= "1111"; blue <= "1111"; green <= "1111";
                else
                    red <= "0000"; green <= "0101"; blue <= "0100";
                end if;
                -- cloud large #2
            elsif(hcount >= cl1_start_x and hcount <= cl1_end_x) and (vcount >= cl1_start_y and vcount <= cl1_end_y) then
                    if(cloud_large(cl1y, cl1x) = 1) then
                        red <= "0000"; blue <= "0000"; green <= "0000";
                    elsif(cloud_large(cl1y, cl1x) = 0) then
                        red <= "1111"; blue <= "1111"; green <= "1111";
                    else
                        red <= "0000"; green <= "0101"; blue <= "0100";
                    end if;            
            
            elsif ((hcount >= ground_x) and (vcount <= V_END - 30)) then
                red <= "0000"; green <= "0101"; blue <= "0100";
            elsif ((hcount >= ground_x) and (vcount >= ground_y and vcount <= V_END)) then
                red <= "1101"; green <= "0110"; blue <= "0000";
            else
                red <= "0000";
                green <= "0000";
                blue <= "0000";
            end if;
            
            -- display bird
            if((hcount >= b_start_x and hcount <= b_end_x) and (vcount >= b_start_y and vcount <= b_end_y)) then
                if(bird(dy, dx) = 5) then -- black
                    red <= "0000"; green <= "0000"; blue <= "0000";
                elsif(bird(dy, dx) = 4) then -- red
                    red <= "1111"; green <= "0000"; blue <= "0000";
                elsif(bird(dy,dx) = 3) then -- orange
                    red <= "1101"; green <= "0110"; blue <= "0000";
                elsif(bird(dy,dx) = 2) then -- white
                    red <= "1111"; green <= "1111"; blue <= "1111";
                else
                    red <= "0000"; green <= "0101"; blue <= "0100";  
                end if;
            end if;
        when splash_screen => 
            if((hcount >=  H_START and hcount < H_END) and (vcount >= V_START and vcount < V_END)) then
                if((hcount >= t_start_x and hcount <= t_end_x) and (vcount >= t_start_y and vcount <= t_end_y)) then 
                    if (flappy_W(ty, tx) = 1) then
                        red   <= "1111"; green <= "1111"; blue  <= "1111";
                    else
                        red <= "0111"; green <= "0110"; blue <= "0000";
                    end if;

                elsif((hcount >= t2_start_x and hcount <= t2_end_x) and (vcount >= t2_start_y and vcount <= t2_end_y)) then 
                    if (play_W(ty2, tx2) = 1) then
                        red   <= "1111"; green <= "1111"; blue  <= "1111";
                    else
                       red <= "0111"; green <= "0110"; blue <= "0000";
                    end if;
                elsif(hcount >= cl_start_x and hcount <= cl_end_x) and (vcount >= cl_start_y and vcount <= cl_end_y) then
                    if(cloud_large(cly, clx) = 1) then
                        red <= "0000"; blue <= "0000"; green <= "0000";
                    elsif(cloud_large(cly, clx) = 0) then
                        red <= "1111"; blue <= "1111"; green <= "1111";
                    else
                        red <= "0111"; green <= "0110"; blue <= "0000";
                    end if;
                elsif(hcount >= cs_start_x and hcount <= cs_end_x) and (vcount >= cs_start_y and vcount <= cs_end_y) then
                    if(cloud_small(csy, csx) = 1) then
                        red <= "0000"; blue <= "0000"; green <= "0000";
                    elsif(cloud_small(csy, csx) = 0) then
                        red <= "1111"; blue <= "1111"; green <= "1111";
                    else
                        red <= "0111"; green <= "0110"; blue <= "0000";
                    end if;  
                elsif(hcount >= ab_start_x and hcount <= ab_end_x) and (vcount >= ab_start_y and vcount <= ab_end_y) then
                           
                    if(angryBirdLarge(aby, abx) = 5) then -- black
                        red <= "0000"; green <= "0000"; blue <= "0000";
                    elsif(angryBirdLarge(aby, abx) = 4) then -- red
                        red <= "1111"; green <= "0000"; blue <= "0000";
                    elsif(angryBirdLarge(aby,abx) = 3) then -- orange
                        red <= "1101"; green <= "0110"; blue <= "0000";
                    elsif(angryBirdLarge(aby,abx) = 2) then -- white
                        red <= "1111"; green <= "1111"; blue <= "1111";
                    else
                        red <= "0111"; green <= "0110"; blue <= "0000";  
                    end if; 
                else
                   red <= "0111"; green <= "0110"; blue <= "0000";
                end if;   
            else
                red <= "0000"; green <= "0000"; blue  <= "0000";      
            end if;
        -- aka end_screen
        when others => 
           if((hcount >=  H_START and hcount < H_END) and (vcount >= V_START and vcount < V_END)) then
                if((hcount >= t3_start_x and hcount <= t3_end_x) and (vcount >= t3_start_y and vcount <= t3_end_y)) then
                   if (end_W(ty3, tx3) = 1) then
                        red  <= "1111"; green <= "1111"; blue  <= "1111";
                   else
                        red <= "0000"; green <= "0000"; blue <= "0000";
                   end if;   
                elsif((hcount >= t4_start_x and hcount <= t4_end_x) and (vcount >= t4_start_y and vcount <= t4_end_y)) then
                    if(playAgain_W(ty4, tx4) = 1) then
                        red  <= "1111"; green <= "1111"; blue  <= "1111";
                    else
                        red <= "0000"; green <= "0000"; blue <= "0000";
                    end if;
                else
                    red <= "0000"; green <= "0000"; blue <= "0000"; 
                end if;
            else
               red <= "0000"; green <= "0000"; blue <= "0000";             
            end if;
    end case;
        
        
end process display_proc;


end Behavioral;
