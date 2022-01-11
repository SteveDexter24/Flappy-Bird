library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package pipepkg is
    type INT_ARRAY is array (integer range <>) of integer;
end package;

use work.pipepkg.all;

entity pipe is
    Port (pipe_ran: out INT_ARRAY);
end pipe;

architecture Behavioral of pipe is

begin

pipe_ran(0) <= 136; pipe_ran(1) <= 291; pipe_ran(2) <= 281; pipe_ran(3) <= 342; pipe_ran(4) <= 100; pipe_ran(5) <= 269; pipe_ran(6) <= 337; pipe_ran(7) <= 315; 
pipe_ran(8) <= 127; pipe_ran(9) <= 330; pipe_ran(10) <= 111; pipe_ran(11) <= 385; pipe_ran(12) <= 175; pipe_ran(13) <= 341; pipe_ran(14) <= 286; 
pipe_ran(15) <= 309; pipe_ran(16) <= 198; pipe_ran(17) <= 269; pipe_ran(18) <= 236; pipe_ran(19) <= 168; pipe_ran(20) <= 292; pipe_ran(21) <= 159; 
pipe_ran(22) <= 110; pipe_ran(23) <= 218; pipe_ran(24) <= 264; pipe_ran(25) <= 175; pipe_ran(26) <= 230; pipe_ran(27) <= 316; pipe_ran(28) <= 394; 
pipe_ran(29) <= 176; pipe_ran(30) <= 165; pipe_ran(31) <= 122; pipe_ran(32) <= 312; pipe_ran(33) <= 107; pipe_ran(34) <= 147; pipe_ran(35) <= 393; 
pipe_ran(36) <= 114; pipe_ran(37) <= 229; pipe_ran(38) <= 132; pipe_ran(39) <= 386; pipe_ran(40) <= 277; pipe_ran(41) <= 328; pipe_ran(42) <= 245; 
pipe_ran(43) <= 297; pipe_ran(44) <= 289; pipe_ran(45) <= 123; pipe_ran(46) <= 127; pipe_ran(47) <= 177; pipe_ran(48) <= 252; pipe_ran(49) <= 385; 
pipe_ran(50) <= 317; pipe_ran(51) <= 205; pipe_ran(52) <= 161; pipe_ran(53) <= 389; pipe_ran(54) <= 136; pipe_ran(55) <= 122; pipe_ran(56) <= 377; 
pipe_ran(57) <= 105; pipe_ran(58) <= 378; pipe_ran(59) <= 203; pipe_ran(60) <= 237; pipe_ran(61) <= 312; pipe_ran(62) <= 323; pipe_ran(63) <= 296; 
pipe_ran(64) <= 236; pipe_ran(65) <= 219; pipe_ran(66) <= 243; pipe_ran(67) <= 220; pipe_ran(68) <= 171; pipe_ran(69) <= 384; pipe_ran(70) <= 160; 
pipe_ran(71) <= 389; pipe_ran(72) <= 359; pipe_ran(73) <= 244; pipe_ran(74) <= 145; pipe_ran(75) <= 191; pipe_ran(76) <= 114; pipe_ran(77) <= 268; 
pipe_ran(78) <= 315; pipe_ran(79) <= 290; pipe_ran(80) <= 112; pipe_ran(81) <= 162; pipe_ran(82) <= 203; pipe_ran(83) <= 149; pipe_ran(84) <= 162; 
pipe_ran(85) <= 111; pipe_ran(86) <= 277; pipe_ran(87) <= 388; pipe_ran(88) <= 214; pipe_ran(89) <= 264; pipe_ran(90) <= 234; pipe_ran(91) <= 388; 
pipe_ran(92) <= 192; pipe_ran(93) <= 194; pipe_ran(94) <= 217; pipe_ran(95) <= 137; pipe_ran(96) <= 114; pipe_ran(97) <= 391; pipe_ran(98) <= 349; 
pipe_ran(99) <= 320; 


end Behavioral;
