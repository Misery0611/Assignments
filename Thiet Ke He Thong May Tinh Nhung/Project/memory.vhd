LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity memory is
    port (ROM_ad     : in  unsigned(7 downto 0);
          ROM_out    : out bus_16_bit;
          clk        : in  std_logic;
          Mre        : in  std_logic;
          Mwe        : in  std_logic;
          RAM_datain : in  bus_16_bit;
          RAM_ad     : in  bus_8_bit;
          RAM_out    : out bus_16_bit);
end entity memory;

architecture structure of memory is

begin

ROM: entity work.rom(behavior)
port map(address => ROM_ad,
         data_out => ROM_out);

RAM: entity work.ram(behavior)
port map(clk => clk,
         Mre => Mre,
         Mwe => Mwe,
         address => RAM_ad,
         datain => RAM_datain,
         dataout => RAM_out);

end architecture structure;