LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity Datapath is
    port (clk     : in  std_logic;

          slide_sw: in  bus_8_bit;
          push_btn: in  std_logic_vector(3 downto 0);

          instr   : in  bus_16_bit;

          RAM_out : in  bus_16_bit;

          RFs     : in  std_logic_vector(1 downto 0);
          RFwe    : in  std_logic;
          RFwa    : in  std_logic_vector(3 downto 0);
          OPR1e   : in  std_logic;
          OPR1a   : in  std_logic_vector(4 downto 0);
          OPR2e   : in  std_logic;
          OPR2a   : in  std_logic_vector(3 downto 0);
          OPR1    : out bus_16_bit;
          OPR2    : out bus_16_bit;

          ALUs    : in  std_logic_vector(1 downto 0);
          ALUc    : in  std_logic;
          ALUz    : out std_logic;
          ALUn    : out std_logic);
end entity Datapath;

architecture structure of Datapath is

CONSTANT three2one_datawidth : integer := 16;
CONSTANT ground : bus_8_bit := (others => '0');

SIGNAL ALUr     : bus_16_bit;
SIGNAL RF_in    : bus_16_bit;
SIGNAL OPR1_dum : bus_16_bit;
SIGNAL OPR2_dum : bus_16_bit;

begin

rf_mux: entity work.three2one_mux(behavior)
generic map(Datawidth => three2one_datawidth)
port map(first => ALur,
         second(15 downto 8) => ground,
         second(7 downto 0) => instr(7 downto 0),
         third => RAM_out,
         sel => RFs,
         outport => RF_in);

rf: entity work.rf(behavior)
port map(clk => clk,
         RFwa => RFwa,
         RFwe => RFwe,
         OPR1a => OPR1a,
         OPR1e => OPR1e,
         OPR2a => OPR2a,
         OPR2e => OPR2e,
         RF_in => RF_in,
         OPR1 => OPR1_dum,
         OPR2 => OPR2_dum,
         slide_sw => slide_sw,
         push_btn => push_btn);

alu: entity work.alu(behavior)
port map(OPR1 => OPR1_dum,
         OPR2 => OPR2_dum,
         ALUc => ALUc,
         ALUs => ALUs,
         ALUz => ALUz,
         ALUr => ALUr,
         ALUn => ALUn);

OPR1 <= OPR1_dum;
OPR2 <= OPR2_dum;

end architecture structure;