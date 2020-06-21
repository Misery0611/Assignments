LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity cpu is
    port (rst : in  std_logic;
          clk : in  std_logic;
          slide_sw: in bus_8_bit;
          push_btn: in std_logic_vector(3 downto 0);
          ledRed : out std_logic_vector(17 downto 0);
          HEX : OUT bus_7_bit_vector(7 DOWNTO 0));
end entity cpu;

architecture structure of cpu is

CONSTANT three2one_datawidth : integer := 16;
CONSTANT two2one_datawidth   : integer := 8;
CONSTANT ground              : bus_8_bit := (others => '0');

SIGNAL clk_100kHz: std_logic;
SIGNAL clk_10Hz_enable: std_logic;
SIGNAL clk_time_out: std_logic;
SIGNAL HEX_en : std_logic;
--SIGNAL db_10: unsigned(13 downto 0);

SIGNAL instr : bus_16_bit;
SIGNAL PCclr : std_logic;
SIGNAL PCinc : std_logic;
SIGNAL PCld  : std_logic;
SIGNAL IRld  : std_logic;
SIGNAL Ms    : std_logic;
SIGNAL Mre   : std_logic;
SIGNAL Mwe   : std_logic;
SIGNAL RFs   : std_logic_vector(1 downto 0);
SIGNAL RFwa  : ad_line;
SIGNAL RFwe  : std_logic;
SIGNAL OPR1a : std_logic_vector(4 downto 0);
SIGNAL OPR1e : std_logic;
SIGNAL OPR2a : ad_line;
SIGNAL OPR2e : std_logic;
SIGNAL OPR1  : bus_16_bit;
SIGNAL OPR2  : bus_16_bit;
SIGNAL ALUs  : sel_line;
SIGNAL ALUc  : std_logic;
SIGNAL ALUz  : std_logic;
SIGNAL ALUr  : bus_16_bit;
SIGNAL ALUn  : std_logic;
SIGNAL ROM_ad : unsigned(7 downto 0);
SIGNAL ROM_out : bus_16_bit;
SIGNAL RF_in : bus_16_bit;
SIGNAL MEM_out : bus_16_bit;
SIGNAL MEM_ad : bus_8_bit;

--SIGNAL cur_db : state_t;
--SIGNAL next_db :state_t;

begin

controller: entity work.controller(behavior)
port map(rst => rst,
         clk => clk,
         instr => instr,
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
         --cur_db => cur_db,
         --next_db => next_db,
         HEX_en => HEX_en);

pc: entity work.pc(behavior)
port map(clk => clk,
         data_in => instr(7 downto 0),
         PCclr => PCclr,
         PCinc => PCinc,
         PCld => PCld,
         address => ROM_ad);

ir: entity work.ir(behavior)
port map(ROM_out => ROM_out,
         IRld => IRld,
         IRout => instr);

rom: entity work.rom(behavior)
port map(address => ROM_ad,
         data_out => ROM_out);

alu: entity work.alu(behavior)
port map(OPR1 => OPR1,
         OPR2 => OPR2,
         ALUc => ALUc,
         ALUs => ALUs,
         ALUz => ALUz,
         ALUr => ALUr,
         ALUn => ALUn);

rf: entity work.rf(behavior)
port map(clk => clk,
         RFwa => RFwa,
         RFwe => RFwe,
         OPR1a => OPR1a,
         OPR1e => OPR1e,
         OPR2a => OPR2a,
         OPR2e => OPR2e,
         RF_in => RF_in,
         OPR1 => OPR1,
         OPR2 => OPR2,
         slide_sw => slide_sw,
         push_btn => push_btn);

rf_mux: entity work.three2one_mux(behavior)
generic map(Datawidth => three2one_datawidth)
port map(first => ALur,
         second(15 downto 8) => ground,
         second(7 downto 0) => instr(7 downto 0),
         third => MEM_out,
         sel => RFs,
         outport => RF_in);

--ram: entity work.memory(behavior)
--port map(Mre => Mre,
--         Mwe => Mwe,
--         address => MEM_ad,
--         data_in => OPR1,
--         data_out => MEM_out);

ram: entity work.ram(behavior)
port map(clk => clk,
         mre => mre,
         mwe => mwe,
         address => MEM_ad,
         datain => OPR1,
         dataout => MEM_out);

mem_ad_mux: entity work.two2one_mux(behavior)
generic map(Datawidth => two2one_datawidth)
port map(first => OPR2(7 downto 0),
         second => instr(7 downto 0),
         sel => Ms,
         outport => MEM_ad);

lf_clk: entity work.lf_clk(behavior)
port map(rst => rst,
         clk_50MHz => clk,
         clk_10Hz_en => clk_10Hz_enable,
         duration => instr(7 downto 0),
         clk_100kHz => clk_100kHz,
         --db_10 => db_10,
         time_out => clk_time_out);

seven_seg: entity work.seven_segment_controller(behavior)
port map(selector => instr(2 downto 0),
         value => OPR1(3 downto 0),
         enable => HEX_en,
         HEX => HEX);

--ledRed(7 downto 0) <= MEM_ad;
--ledRed(15 downto 8) <= MEM_out(7 downto 0);
--ledRed(17) <= Ms;
ledRed(7 downto 0) <= ALUr(7 downto 0);
ledRed(17 downto 16) <= ALUs;

end architecture structure;