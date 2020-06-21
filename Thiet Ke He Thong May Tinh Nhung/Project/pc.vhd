LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity pc is
    port (clk     : in  std_logic;
          data_in : in  bus_8_bit;
          PCclr   : in  std_logic;
          PCinc   : in  std_logic;
          PCld    : in  std_logic;
          address : out unsigned(7 downto 0));
end entity pc;

architecture behavior of pc is

SIGNAL cur_val  : unsigned(7 downto 0);

begin

main: process(PCclr, PCld, PCinc, clk)
begin
    if PCclr = '1' then
        cur_val <= (others => '0');
    elsif PCld = '1' then
        cur_val <= unsigned(data_in);
    elsif rising_edge(PCinc) then
        cur_val <= cur_val + 1;
    end if;

end process main;

address <= cur_val;

end architecture behavior;