LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY work;
USE work.common.all;

ENTITY seven_segment_controller IS
    
    PORT (SELECTOR: IN      STD_LOGIC_VECTOR(2 DOWNTO 0);
          VALUE:    IN      STD_LOGIC_VECTOR(3 DOWNTO 0);
          ENABLE:   IN      STD_LOGIC;
          HEX:      OUT     bus_7_bit_vector(7 DOWNTO 0)
         );
END seven_segment_controller;

ARCHITECTURE behavior of seven_segment_controller IS
    --SIGNAL DE_SEL:  STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL OUTPUT:  STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
    -- Decode VALUE to OUTPUT Character

    OUTPUT(0) <= (VALUE(3) and VALUE(1)) or (VALUE(2) and (not VALUE(0))) or ((not VALUE(3)) and (not VALUE(2)) and (not VALUE(1)) and VALUE(0));
    OUTPUT(1) <= (VALUE(3) and VALUE(2)) or (VALUE(2) and (not VALUE(1)) and VALUE(0)) or (VALUE(2) and VALUE(1) and (not VALUE(0))) or (VALUE(3) and VALUE(1) and VALUE(0));
    OUTPUT(2) <= (VALUE(3) and VALUE(2)) or (VALUE(3) and VALUE(1) and VALUE(0)) or ((not VALUE(3)) and (not VALUE(2)) and VALUE(1) and (not VALUE(0)));
    OUTPUT(3) <= (VALUE(3) and VALUE(1)) or (VALUE(2) and (not VALUE(1)) and (not VALUE(0))) or ((not VALUE(2)) and (not VALUE(1)) and VALUE(0)) or (VALUE(2) and VALUE(1) and VALUE(0));
    OUTPUT(4) <= ((not VALUE(3)) and VALUE(0)) or ((not VALUE(1)) and VALUE(0)) or (VALUE(2) and (not VALUE(1))) or (VALUE(3) and VALUE(1) and (not VALUE(0)));
    OUTPUT(5) <= (VALUE(3) and VALUE(2)) or ((not VALUE(3)) and (not VALUE(2)) and VALUE(0)) or ((not VALUE(2)) and VALUE(1) and (not VALUE(0))) or ((not VALUE(3)) and VALUE(1) and VALUE(0));
    OUTPUT(6) <= ((not VALUE(3)) and (not VALUE(2)) and (not VALUE(1))) or (VALUE(2) and VALUE(1) and VALUE(0)) or (VALUE(3) and VALUE(2) and VALUE(0)) or (VALUE(3) and VALUE(2) and VALUE(1)); 

    -- Decode SELECTOR (3 to 8 decoder)
    --DE_SEL(0) <= (NOT SELECTOR(2)) AND (NOT SELECTOR(1)) AND (NOT SELECTOR(0));
    --DE_SEL(1) <= (NOT SELECTOR(2)) AND (NOT SELECTOR(1)) AND SELECTOR(0);
    --DE_SEL(2) <= (NOT SELECTOR(2)) AND SELECTOR(1) AND (NOT SELECTOR(0));
    --DE_SEL(3) <= (NOT SELECTOR(2)) AND SELECTOR(1) AND SELECTOR(0);
    --DE_SEL(4) <= SELECTOR(2) AND (NOT SELECTOR(1)) AND (NOT SELECTOR(0));
    --DE_SEL(5) <= SELECTOR(2) AND (NOT SELECTOR(1)) AND SELECTOR(0);
    --DE_SEL(6) <= SELECTOR(2) AND SELECTOR(1) AND (NOT SELECTOR(0));
    --DE_SEL(7) <= SELECTOR(2) AND SELECTOR(1) AND SELECTOR(0);

update: process(OUTPUT, SELECTOR, ENABLE)
BEGIN
    -- Works only if enabled
    if (ENABLE = '1') then
        HEX(to_integer(unsigned(SELECTOR))) <= OUTPUT;
    end if;
END process;

END behavior;