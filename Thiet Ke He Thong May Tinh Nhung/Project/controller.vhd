LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

entity controller is
    port (rst   : in  std_logic;
          clk   : in  std_logic;
          instr : in  bus_16_bit;
          PCclr : out std_logic;
          PCinc : out std_logic;
          PCld  : out std_logic;
          IRld  : out std_logic;
          Ms    : out std_logic;
          Mre   : out std_logic;
          Mwe   : out std_logic;
          RFs   : out sel_line;
          RFwa  : out ad_line;
          RFwe  : out std_logic;
          OPR1a : out std_logic_vector(4 downto 0);
          OPR1e : out std_logic;
          OPR2a : out ad_line;
          OPR2e : out std_logic;
          ALUs  : out sel_line;
          ALUc  : out std_logic;
          ALUz  : in  std_logic;
          ALUn  : in std_logic;
          delay_en: out std_logic;
          time_out: in std_logic;
          HEX_en : out std_logic
          );
end entity controller;

architecture behavior of controller is

--type state_t is (IDLE, INCREASE, FETCH, DECODE, CMD0, CMD1, CMD2, CMD3, CMD4, CMD5, CMD6, CMD7, CMD8, CMD9, CMD10, CMD11, CMD12, CMD13);
signal current_state : state_t := IDLE;
signal next_state    : state_t;

begin

    update: process(clk, rst)
    begin
        if rst = '0' then           -- asynchronous reset (active low)
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process update;

    -- process to evaluate the next state
    nextstate: process(instr, current_state, ALUz, ALUn, time_out)
    begin
        case current_state is
            when IDLE =>
                    next_state <= FETCH;

            when INCREASE =>
                next_state <= FETCH;

            when FETCH =>
                next_state <= DECODE;

            when DECODE =>
                case instr(15 downto 12) is
                    when "0000" => next_state <= CMD0;
                    when "0001" => next_state <= CMD1;
                    when "0010" => next_state <= CMD2;
                    when "0011" => next_state <= CMD3;
                    when "0100" => next_state <= CMD4;
                    when "0101" => next_state <= CMD5;
                    when "0110" => next_state <= CMD6;
                    when "0111" => next_state <= CMD7;
                    when "1000" => next_state <= CMD8;
                    when "1001" => next_state <= CMD9;
                    when "1010" => next_state <= CMD10;
                    when "1011" => next_state <= CMD11;
                    when "1100" => next_state <= CMD12;
                    when "1101" => next_state <= CMD13;
                    when "1110" => next_state <= CMD14;
                    when others => next_state <= INCREASE;
                end case;

            when CMD9 | CMD13 =>
                if ALUz = '0' then
                    next_state <= CMD10;
                else
                    next_state <= INCREASE;
                end if;

            when CMD10 =>
                next_state <= FETCH;


            when CMD11 =>
                if time_out = '1' then
                    next_state <= INCREASE;
                end if;

            when CMD14 =>
                if (ALUz = '1' and ALUn = '0') then
                    next_state <= CMD10;
                else
                    next_state <= INCREASE;
                end if;
            when others =>
                next_state <= INCREASE;
        end case;
    end process nextstate;

    PCclr <= '1'    when current_state = IDLE      else '0';
    PCinc <= '1'    when current_state = INCREASE  else '0';
    PCld  <= '1'    when current_state = CMD10     else '0';
    IRld  <= '1'    when current_state = FETCH     else '0';
    Ms    <= '1'    when (current_state = CMD0) or (current_state = CMD1) else '0' when (current_state = CMD2) or (current_state = CMD3);
    Mre   <= '1'    when (current_state = CMD0) or (current_state = CMD3) else '0';
    Mwe   <= '1'    when (current_state = CMD1) or (current_state = CMD2) else '0';
    RFs   <= "10"   when (current_state = CMD0) or (current_state = CMD3) else "01" when current_state = CMD4 else "00" when (current_state = CMD5) or (current_state = CMD6) or (current_state = CMD7) or (current_state = CMD8);
    RFwa  <= instr(11 downto 8);
    RFwe  <= '1'    when (current_state = CMD0) or (current_state = CMD3) or (current_state = CMD4) or (current_state = CMD5) or (current_state = CMD6) or (current_state = CMD7)  or (current_state = CMD8) else '0';
    OPR1a(3 downto 0) <= instr(11 downto 8) when (current_state = CMD1) or (current_state = CMD5) or (current_state = CMD6) or (current_state = CMD7) or (current_state = CMD8) or (current_state = CMD9) or (current_state = CMD12) or (current_state = CMD13) or (current_state = CMD14)
        else instr(7 downto 4) when current_state = CMD2 
        else "0000";
    OPR1a(4) <= '1' when current_state = CMD13 else '0';
    OPR1e <= '1' when (current_state = CMD1) or (current_state = CMD2) or (current_state = CMD5) or (current_state = CMD6) or (current_state = CMD7) or (current_state = CMD8) or (current_state = CMD9) or (current_state = CMD12) or (current_state = CMD13) or (current_state = CMD14) else '0';
    OPR2a <= instr(11 downto 8) when current_state = CMD2 
        else instr(7 downto 4) when (current_state = CMD3) or (current_state = CMD5) or (current_state = CMD6) or (current_state = CMD7) or (current_state = CMD8)
        else "0000";
    OPR2e <= '1' when (current_state = CMD2) or (current_state = CMD3) or (current_state = CMD5) or (current_state = CMD6) or (current_state = CMD7) or (current_state = CMD8) else '0';
    ALUs <= "01" when current_state = CMD6 else "10" when current_state = CMD7 else "11" when current_state = CMD8 else "00" when current_state = CMD5;
    ALUc <= '0' when (current_state = CMD9) or (current_state = CMD13) or (current_state = CMD14) else '1';
    delay_en <= '1' when current_state = CMD11 else '0';
    HEX_en <= '1' when current_state = CMD12 else '0';

end architecture behavior;