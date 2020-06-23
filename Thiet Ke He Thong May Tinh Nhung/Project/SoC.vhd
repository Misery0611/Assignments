LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity SoC is
	port (rst : std_logic;
		  clk : std_logic;

		  slide_sw: in  bus_8_bit;
          push_btn: in  std_logic_vector(3 downto 0);

          HEX : out bus_7_bit_vector(7 DOWNTO 0));

end entity SoC;

architecture structure of SoC is

SIGNAL instr_out : bus_16_bit;

SIGNAL ROM_ad  	 : unsigned(7 downto 0);
SIGNAL ROM_out   : bus_16_bit;

SIGNAL OPR1 	 : bus_16_bit;

SIGNAL Ms     	 : std_logic;
SIGNAL Mre   	 : std_logic;
SIGNAL Mwe   	 : std_logic;
SIGNAL RAM_ad  	 : bus_8_bit;
SIGNAL RAM_out   : bus_16_bit;

SIGNAL HEX_en 	 : std_logic;

begin

CPU: entity work.CPU(structure)
port map(rst => rst,
	     clk => clk,

	     slide_sw => slide_sw,
	     push_btn => push_btn,

	     ROM_ad  => ROM_ad,
	     ROM_out => ROM_out,

         instr_out => instr_out,

         Mre 	 => Mre,
         Mwe 	 => Mwe,
         RAM_ad  => RAM_ad,
         RAM_out => RAM_out,

         OPR1 => OPR1,

         HEX_en => HEX_en);

Memory: entity work.Memory(structure)
port map(ROM_ad  => ROM_ad,
		 ROM_out => ROM_out,

		 clk 		=> clk,
		 Mre 		=> Mre,
         Mwe 		=> Mwe,
         RAM_ad 	=> RAM_ad,
         RAM_out 	=> RAM_out,
         RAM_datain => OPR1);

seven_seg: entity work.seven_segment_controller(behavior)
port map(selector => instr_out(2 downto 0),
         value => OPR1(3 downto 0),
         enable => HEX_en,
         HEX => HEX);

end architecture structure;