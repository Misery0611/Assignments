library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

LIBRARY work;
USE work.common.all;

entity ram is
    port (
        clk     : in  std_logic;
        mre:      in  std_logic;
        mwe:      in  std_logic;
        address : in  bus_8_bit;
        datain  : in  bus_16_bit;
        dataout : out bus_16_bit
    );
end entity ram;

architecture behavior of ram is

--type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);
--signal ram : ram_type;
signal read_address : std_logic_vector(address'range);
SIGNAL mem: bus_16_bit_vector(255 downto 0);

begin

    main: process(clk) is

    begin
        if (clk'event and clk = '1') then
            read_address <= address;
        elsif (clk'event and clk = '0') then
            if mwe = '1' then
                mem(to_integer(unsigned(address))) <= datain;
            end if;
        end if;
    end process main;

    dataout <= mem(to_integer(unsigned(read_address)));

end architecture behavior;