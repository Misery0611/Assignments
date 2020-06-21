LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;


LIBRARY work;
USE work.common.all;

entity alu is
	port (opr1 : in  bus_16_bit;
		  opr2 : in  bus_16_bit;
		  ALUc : in  std_logic;
		  ALUs : in  std_logic_vector(1 downto 0);
		  ALUz : out std_logic;
		  ALUr : out bus_16_bit;
		  ALUn : out std_logic
		);
end entity alu;

architecture behavior of alu is

SIGNAL add_r : bus_16_bit;
SIGNAL sub_r : bus_16_bit;
SIGNAL and_r : bus_16_bit;
SIGNAL or_r  : bus_16_bit;
SIGNAL result : bus_16_bit;

begin

-- Compare zero
aluz <= ALUc or opr1(0) or opr1(1) or opr1(2) or opr1(3) or opr1(4) or opr1(5) or opr1(6) or opr1(7) or opr1(8) or opr1(9) or opr1(10) or opr1(11) or opr1(12) or opr1(13) or opr1(14) or opr1(15);
ALUn <= opr1(15);
--and_loop: for i in 0 to 15 generate
--	and_r(i) <= opr1(i) and opr2(i);
--end generate;

--or_loop: for i in 0 to 15 generate
--	or_r(i) <= opr1(i) or opr2(i);
--end generate;

add_r <= std_logic_vector(signed(opr1) + signed(opr2));
sub_r <= std_logic_vector(signed(opr1) - signed(opr2));
and_r <= opr1 and opr2;
or_r <= opr1 or opr2;

--with ALUs select ALUr <=
--	std_logic_vector(signed(opr1) + signed(opr2)) when "00",
--	std_logic_vector(signed(opr1) - signed(opr2)) when "01",
--	or_r										  when "10",
--	and_r										  when	"11",
--	(others => '0')								  when others;
--ALUr <= add_r when ALUs = "00" else sub_r when ALUs = "01" else and_r when ALUs = "11" else or_r when ALUs = "10";
process (ALUs, OPR1, OPR2)
begin
	case (ALUs) is
		when "00" => result <= add_r;
		when "01" => result <= sub_r;
		when "10" => result <= and_r;
		when "11" => result <= or_r;
		when others => NULL;
	end case;
end process;

ALUr <= result;

end architecture behavior;