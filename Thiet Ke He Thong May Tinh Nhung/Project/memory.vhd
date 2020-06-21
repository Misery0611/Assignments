LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity memory is
    port (mre:      in  std_logic;
          mwe:      in  std_logic;
          address:  in  bus_8_bit;
          data_in:  in  bus_16_bit;
          data_out: out bus_16_bit);
end entity memory;

architecture behavior of memory is

SIGNAL mem: bus_16_bit_vector(255 downto 0);

begin

reader: process(mre, address)
begin
    if mre = '1' then
        data_out <= mem(to_integer(unsigned(address)));
    end if;
end process reader;

writer: process(mwe)
begin
    if falling_edge(mwe) then
        mem(to_integer(unsigned(address))) <= data_in;
    end if;
end process writer;

end architecture behavior;