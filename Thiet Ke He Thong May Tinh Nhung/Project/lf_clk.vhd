LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity LF_clk is
    port(rst : in std_logic;
         clk_50MHz : in std_logic;
         clk_10Hz_en: in std_logic;
         duration: in bus_8_bit;
         clk_100kHz: out std_logic := '0';
         --db_10: out unsigned(13 downto 0);
         time_out: out std_logic := '0');
end entity LF_clk;

architecture behavior of LF_clk is

SIGNAL clk_100kHz_dum : std_logic := '0';
SIGNAL clk_count_100kHz: unsigned(7 downto 0) := (others => '0');
SIGNAL clk_count_10Hz: unsigned(13 downto 0) := (others => '0');
SIGNAL clk_duration: unsigned(7 downto 0) := (others => '0');
--SIGNAL dump1: std_logic := '0';
SIGNAL dump2: std_logic := '0';

CONSTANT LIM_BOT : unsigned(7 downto 0) := X"01";
CONSTANT HALF_DUTY_100kHz : unsigned(7 downto 0) := X"F9";
CONSTANT HALF_DUTY_10Hz : unsigned(13 downto 0) :=  "10" & X"70F";

begin

clock_100kHz: process(rst, clk_50MHz)
begin
    if rst = '0' then
        clk_count_100kHz <= (others => '0');
        clk_100kHz_dum <= '0';
    elsif rising_edge(clk_50MHz) then
        if clk_count_100kHz < HALF_DUTY_100kHz then
            clk_count_100kHz <= clk_count_100kHz + 1;
        else
            clk_count_100kHz <= (others => '0');
            clk_100kHz_dum <= NOT clk_100kHz_dum;
        end if;
    end if;
end process clock_100kHz;

clock_10Hz: process(clk_10Hz_en, clk_100kHz_dum)
begin
    if clk_10Hz_en = '0' then
        dump2 <= '0';
        time_out <= '0';
        clk_count_10Hz <= (others => '0');
    elsif rising_edge(clk_100kHz_dum) then
        if dump2 = '0' then
            clk_duration <= unsigned(duration);
            dump2 <= '1';
            clk_count_10Hz <= (others => '0');
        else
            if clk_count_10Hz < HALF_DUTY_10Hz then
                clk_count_10Hz <= clk_count_10Hz + 1;
            else
                clk_count_10Hz <= (others => '0');

                if clk_duration > LIM_BOT then
                    clk_duration <= clk_duration - 1;
                else
                    time_out <= '1';
                end if;
            end if;
        end if;
    end if;
end process clock_10Hz;

clk_100kHz <= clk_100kHz_dum;
--db_10 <= clk_count_10Hz;

end architecture behavior;