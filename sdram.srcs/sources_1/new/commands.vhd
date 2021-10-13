
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package commands is
    type command_type is (MRS, REF, SRE, SRX, PRE, PREA, ACT, WR, WRS4, WRS8, WRAP, WRAPS4, WRAPS8, 
                    RD, RDS4, RDS8, RDAP, RDAPS4, RDAPS8, NOP, DES, PDE, PDX, ZQCL, ZQCS);
    procedure command (command : command_type; 
                        signal CS_inv : OUT std_logic;
                        signal RAS_inv : OUT std_logic;
                        signal CAS_inv : OUT std_logic;
                        signal WE_inv : OUT std_logic;
                        signal BA : OUT std_logic_vector (2 downto 0);
                        signal A : OUT std_logic_vector(13 downto 0)
                        );
end package;

package body commands is
    procedure command (command : command_type; 
                        signal CS_inv : OUT std_logic;
                        signal RAS_inv : OUT std_logic;
                        signal CAS_inv : OUT std_logic;
                        signal WE_inv : OUT std_logic;
                        signal BA : OUT std_logic_vector (2 downto 0);
                        signal A : OUT std_logic_vector(13 downto 0)
                        ) is 
    begin
        case command is
        
            when MRS =>
                CS_inv <= '0'; RAS_inv <= '0'; CAS_inv <= '0'; WE_inv <= '0';
            when REF =>
                CS_inv <= '0'; RAS_inv <= '0'; CAS_inv <= '0'; WE_inv <= '1';
                BA <= "000"; A <= "00000000000000";
            when SRE =>
                CS_inv <= '0'; RAS_inv <= '0'; CAS_inv <= '0'; WE_inv <= '1';
                BA <= "000"; A <= "00000000000000";
            when SRX =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '1'; WE_inv <= '1';
                BA <= "000"; A <= "00000000000000";
            when PRE =>
                CS_inv <= '0'; RAS_inv <= '0'; CAS_inv <= '1'; WE_inv <= '0';
                A <= "00000000000000";
            when PREA =>
                CS_inv <= '0'; RAS_inv <= '0'; CAS_inv <= '1'; WE_inv <= '0';
                BA <= "000"; A(13 downto 0) <= "00010000000000";
            when ACT =>
                CS_inv <= '0'; RAS_inv <= '0'; CAS_inv <= '1'; WE_inv <= '1';
                
            when WR =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '0';
                A(13 downto 12) <= "00"; A(10) <= '0';
            when WRS4 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '0';
                A(13 downto 12) <= "00"; A(10) <= '0';
            when WRS8 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '0';
                A(13) <= '0'; A(12) <= '1'; A(10) <= '0';
            when WRAP =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '0';
                A(13 downto 12) <= "00"; A(10) <= '1';
            when WRAPS4 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '0';
                A(13 downto 12) <= "00"; A(10) <= '1';
            when WRAPS8 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '0';
                A(13) <= '0'; A(12) <= '1'; A(10) <= '1';
                
            when RD =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '1';
                A(13 downto 12) <= "00"; A(10) <= '0';
            when RDS4 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '1';
                A(13 downto 12) <= "00"; A(10) <= '0';
            when RDS8 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '1';
                A(13) <= '0'; A(12) <= '1'; A(10) <= '0';
            when RDAP =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '1';
                A(13 downto 12) <= "00"; A(10) <= '1';
            when RDAPS4 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '1';
                A(13 downto 12) <= "00"; A(10) <= '1';
            when RDAPS8 =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '0'; WE_inv <= '1';
                A(13) <= '0'; A(12) <= '1'; A(10) <= '1';
                
            when NOP =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '1'; WE_inv <= '1';
                BA <= "000"; A(13 downto 0) <= "00000000000000";
            when DES =>
                CS_inv <= '1'; 
            when PDE =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '1'; WE_inv <= '1';
                BA <= "000"; A(13 downto 0) <= "00000000000000";
            when PDX =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '1'; WE_inv <= '1';
                BA <= "000"; A(13 downto 0) <= "00000000000000";
            when ZQCL =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '1'; WE_inv <= '0';
                A(10) <= '1';
            when ZQCS =>
                CS_inv <= '0'; RAS_inv <= '1'; CAS_inv <= '1'; WE_inv <= '0';
                A(10) <= '0';
 
        end case;
    end procedure;
end commands; 