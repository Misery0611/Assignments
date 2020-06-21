LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity two2one_mux is
    generic(DataWidth : integer);
    port (first:    in  std_logic_vector(DataWidth - 1 downto 0);
          second:   in  std_logic_vector(DataWidth - 1 downto 0);
          sel:      in  std_logic;
          outport:  out std_logic_vector(DataWidth - 1 downto 0));
end entity two2one_mux;

architecture behavior of two2one_mux is
begin
    with sel select
        outport <= first  when '0',
                   second when others;
end behavior;