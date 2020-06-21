LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY work;
USE work.common.all;

entity ir is
    port (rom_out : in  bus_16_bit;
          irld    : in  std_logic;
          --clk   : in  std_logic;
          irout   : out bus_16_bit := (others => '1'));
end entity ir;

architecture behavior of ir is

begin

main: process(irld)
begin
    if rising_edge(irld) then
        irout <= rom_out;
    end if;
end process main;

end architecture behavior;