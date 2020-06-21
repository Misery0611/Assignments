library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity rf is
    PORT (clk:   in  std_logic;
          rfwa:  in  std_logic_vector(3 downto 0);
          rfwe:  in  std_logic;
          opr1a: in  std_logic_vector(4 downto 0);
          opr1e: in  std_logic;
          opr2a: in  std_logic_vector(3 downto 0);
          opr2e: in  std_logic;
          rf_in: in  bus_16_bit;
          opr1:  out bus_16_bit;
          opr2:  out bus_16_bit;

          slide_sw: in bus_8_bit;
          push_btn: in std_logic_vector(3 downto 0)
        );
end entity rf;

architecture behavior of rf is

SIGNAL reg_files: bus_16_bit_vector(15 downto 0);
SIGNAL switches: std_logic_vector(11 downto 0);

begin

    write: process(rfwe)
    begin
        if falling_edge(rfwe) then
            reg_files(to_integer(unsigned(rfwa))) <= rf_in;
        end if;
    end process write;

    export1: process(opr1e, opr1a)
    begin
        if opr1e = '1' then
            if opr1a(4) = '0' then
                opr1 <= reg_files(to_integer(unsigned(opr1a(3 downto 0))));
            elsif opr1a(4) = '1' then
                opr1(15 downto 1) <= (others => '0');
                opr1(0) <= switches(to_integer(unsigned(opr1a(3 downto 0))));
            end if;
        end if;
    end process export1;

    export2: process(opr2e, opr2a)
    begin
        if opr2e = '1' then
            opr2 <= reg_files(to_integer(unsigned(opr2a)));
        end if;
    end process export2;

    switches(3 downto 0) <= push_btn;
    switches(11 downto 4) <= slide_sw;
    --gen_switches: for i in 16 to 27 generate
    --    reg_files(i)(15 downto 1) <= (others => '0');
    --    bind2pushBtn: if i < 20 generate
    --        reg_files(i)(0) <= push_btn(i - 16);
    --    end generate bind2pushBtn;

    --    bind2SlideSW: if i > 19 generate
    --        reg_files(i)(0) <= slide_sw(i - 20);
    --    end generate bind2SlideSW;
    --end generate gen_switches;

end architecture behavior;