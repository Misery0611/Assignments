LIBRARY ieee;
USE ieee.std_logic_1164.all;

package common is
    subtype sel_line is STD_LOGIC_VECTOR(1 DOWNTO 0);
    subtype ad_line is STD_LOGIC_VECTOR(3 DOWNTO 0);
    subtype bus_8_bit is STD_LOGIC_VECTOR(7 DOWNTO 0);
    subtype bus_7_bit is STD_LOGIC_VECTOR(6 DOWNTO 0);
    subtype bus_16_bit is STD_LOGIC_VECTOR(15 DOWNTO 0);
    type bus_7_bit_vector is array(natural range<>) of bus_7_bit;
    type bus_8_bit_vector is array(natural range<>) of bus_8_bit;
    type bus_16_bit_vector is array(natural range <>) of bus_16_bit;
    type state_t is (IDLE, INCREASE, FETCH, DECODE, CMD0, CMD1, CMD2, CMD3, CMD4, CMD5, CMD6, CMD7, CMD8, CMD9, CMD10, CMD11, CMD12, CMD13, CMD14);
end package common;

package body common is

end package body common;