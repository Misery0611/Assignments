LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity Control_unit is
    port (rst : in std_logic;
          clk : in std_logic;

          ROM_out : in bus_16_bit;
          ROM_ad  : out unsigned(7 downto 0);

          instr   : out bus_16_bit;

          Mre    : out std_logic;
          Mwe    : out std_logic;
          RAM_ad : out bus_8_bit;

          RFs   : out sel_line;
          RFwa  : out ad_line;
          RFwe  : out std_logic;
          OPR1a : out std_logic_vector(4 downto 0);
          OPR1e : out std_logic;
          OPR2a : out ad_line;
          OPR2e : out std_logic;
          OPR2  : in  bus_16_bit;

          ALUs  : out sel_line;
          ALUc  : out std_logic;
          ALUz  : in std_logic;
          ALUn  : in std_logic;

          HEX_en : out std_logic
        );
end entity Control_unit;

architecture structure of Control_unit is

CONSTANT two2one_datawidth   : integer := 8;

SIGNAL IRout : bus_16_bit;
SIGNAL PCclr : std_logic;
SIGNAL PCinc : std_logic;
SIGNAL PCld  : std_logic;
SIGNAL IRld  : std_logic;

SIGNAL Ms : std_logic;

SIGNAL clk_100kHz       : std_logic;
SIGNAL clk_10Hz_enable  : std_logic;
SIGNAL clk_time_out     : std_logic;

begin

controller: entity work.controller(behavior)
port map(rst => rst,
         clk => clk,
         instr => IRout,
         PCclr => PCclr,
         PCinc => PCinc,
         PCld => PCld,
         IRld => IRld,
         Ms => Ms,
         Mre => Mre,
         Mwe => Mwe,
         RFs => RFs,
         RFwa => RFwa,
         RFwe => RFwe,
         OPR1a => OPR1a,
         OPR1e => OPR1e,
         OPR2a => OPR2a,
         OPR2e => OPR2e,
         ALUs => ALUs,
         ALUc => ALUc,
         ALUz => ALUz,
         ALUn => ALUn,
         delay_en => clk_10Hz_enable,
         time_out => clk_time_out,
         HEX_en => HEX_en);

pc: entity work.pc(behavior)
port map(clk => clk,
         data_in => IRout(7 downto 0),
         PCclr => PCclr,
         PCinc => PCinc,
         PCld => PCld,
         address => ROM_ad);

ir: entity work.ir(behavior)
port map(ROM_out => ROM_out,
         IRld => IRld,
         IRout => IRout);

ROM_ad_mux: entity work.two2one_mux(behavior)
generic map(Datawidth => two2one_datawidth)
port map(first => OPR2(7 downto 0),
         second => IRout(7 downto 0),
         sel => Ms,
         outport => RAM_ad);

lf_clk: entity work.lf_clk(behavior)
port map(rst => rst,
         clk_50MHz => clk,
         clk_10Hz_en => clk_10Hz_enable,
         duration => IRout(7 downto 0),
         clk_100kHz => clk_100kHz,
         time_out => clk_time_out);

instr <= IRout;

end architecture structure;