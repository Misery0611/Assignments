LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity three2one_mux is
    generic(DataWidth : integer);
    port (first:    in  std_logic_vector(DataWidth - 1 downto 0);
          second:   in  std_logic_vector(DataWidth - 1 downto 0);
          third:    in  std_logic_vector(DataWidth - 1 downto 0);
          sel:      in  std_logic_vector(1 downto 0);
          outport:  out std_logic_vector(DataWidth - 1 downto 0));
end entity three2one_mux;

architecture behavior of three2one_mux is
begin
    with sel select
        outport <= first  when "00",
                   second when "01",
                   third  when others;

end behavior;