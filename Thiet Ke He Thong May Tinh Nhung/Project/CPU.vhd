LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity CPU is
    port (rst : in std_logic;
          clk : in std_logic;

          slide_sw: in  bus_8_bit;
          push_btn: in  std_logic_vector(3 downto 0);

          ROM_ad  : out unsigned(7 downto 0);
          ROM_out : in  bus_16_bit;

          instr_out : out bus_16_bit;

          Mre     : out std_logic;
          Mwe     : out std_logic;
          RAM_ad  : out bus_8_bit;
          RAM_out : in bus_16_bit;

          OPR1 : out bus_16_bit;

          HEX_en : out std_logic);

end entity CPU;

architecture structure of CPU is

SIGNAL instr : bus_16_bit;

SIGNAL RFs   : std_logic_vector(1 downto 0);
SIGNAL RFwa  : ad_line;
SIGNAL RFwe  : std_logic;
SIGNAL OPR1a : std_logic_vector(4 downto 0);
SIGNAL OPR1e : std_logic;
SIGNAL OPR2a : ad_line;
SIGNAL OPR2e : std_logic;
SIGNAL OPR2  : bus_16_bit;

SIGNAL ALUs  : sel_line;
SIGNAL ALUc  : std_logic;
SIGNAL ALUz  : std_logic;
SIGNAL ALUr  : bus_16_bit;
SIGNAL ALUn  : std_logic;

begin

Datapath: entity work.Datapath(structure)
port map(clk => clk,

         slide_sw => slide_sw,
         push_btn => push_btn,

         instr => instr,

         RAM_out => RAM_out,


         RFs   => RFs,
         RFwe  => RFwe,
         RFwa  => RFwa,
         OPR1e => OPR1e,
         OPR1a => OPR1a,
         OPR2e => OPR2e,
         OPR2a => OPR2a,
         OPR1  => OPR1,
         OPR2  => OPR2, 

         ALUs => ALUs,
         ALUc => ALUc,
         ALUz => ALUz,
         ALUn => ALUn);

Control_unit: entity work.Control_unit(structure)
port map(rst => rst,
         clk => clk,

         ROM_out => ROM_out,
         ROM_ad => ROM_ad,

         instr => instr,

         Mre => Mre,
         Mwe => Mwe,
         RAM_ad => RAM_ad,

         RFs   => RFs,
         RFwe  => RFwe,
         RFwa  => RFwa,
         OPR1e => OPR1e,
         OPR1a => OPR1a,
         OPR2e => OPR2e,
         OPR2a => OPR2a,
         OPR2  => OPR2, 

         ALUs => ALUs,
         ALUc => ALUc,
         ALUz => ALUz,
         ALUn => ALUn,

         HEX_en => HEX_en);

instr_out <= instr;

end architecture structure;