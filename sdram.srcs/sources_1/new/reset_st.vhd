
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.COMMANDS.ALL;

library UNISIM;
use UNISIM.VComponents.all;


package reset_st is
    procedure reset_state(
        --Looking-into-chip ports
        --signal clk : IN std_logic;
        signal write : IN std_logic;
        signal read : IN std_logic;
        signal reset: IN std_logic;
        signal addr : IN std_logic_vector (30 downto 0); -- Доступно 2 Gb = 2,147,483,648 B памяти, единица адресного разрешения - Byte    
        signal word_size : IN std_logic_vector (1 downto 0); -- Количество байт данных 00 - WORD (2 Bytes); 01 - DWORD (4 Bytes); 10 - QWORD (8 Bytes)
        
        signal ready : OUT std_logic;
        
        signal data : INOUT std_logic_vector (127 downto 0);
        --Looking-into-chip ports
        
        --Looking-out-of-chip ports
        signal RESET_out : OUT std_logic;
        signal A : OUT std_logic_vector (13 downto 0);
        signal BA : OUT std_logic_vector (2 downto 0);
        signal ODT : OUT std_logic;
        --signal CK : OUT std_logic := '0';
        --signal CK_inv : OUT std_logic := '0';
        signal CKE : OUT std_logic;
        signal CS_inv : OUT std_logic;
        signal RAS_inv : OUT std_logic;
        signal CAS_inv : OUT std_logic;
        signal WE_inv : OUT std_logic;
        signal UDQS : OUT std_logic;
        signal UDQS_inv : OUT std_logic;
        signal LDQS : OUT std_logic;
        signal LDQS_inv : OUT std_logic;
        signal UDM : OUT std_logic;
        signal LDM : OUT std_logic;
        
        signal DQ : INOUT std_logic_vector (15 downto 0);
        --Looking-out-of-chip ports
        
        signal reset_is_ongoing : INOUT std_logic;
        signal ready_internal : INOUT std_logic;
        
        signal state_counter : unsigned(16 downto 0)
        );
end package;

package body reset_st is

    procedure reset_state (
        --Looking-into-chip ports
        --signal clk : IN std_logic;
        signal write : IN std_logic;
        signal read : IN std_logic;
        signal reset: IN std_logic;
        signal addr : IN std_logic_vector (30 downto 0); -- Доступно 2 Gb = 2,147,483,648 B памяти, единица адресного разрешения - Byte    
        signal word_size : IN std_logic_vector (1 downto 0); -- Количество байт данных 00 - WORD (2 Bytes); 01 - DWORD (4 Bytes); 10 - QWORD (8 Bytes)
        
        signal ready : OUT std_logic;
        
        signal data : INOUT std_logic_vector (127 downto 0);
        --Looking-into-chip ports
        
        --Looking-out-of-chip ports
        signal RESET_out : OUT std_logic;
        signal A : OUT std_logic_vector (13 downto 0);
        signal BA : OUT std_logic_vector (2 downto 0);
        signal ODT : OUT std_logic;
        --signal CK : OUT std_logic := '0';
        --signal CK_inv : OUT std_logic := '0';
        signal CKE : OUT std_logic;
        signal CS_inv : OUT std_logic;
        signal RAS_inv : OUT std_logic;
        signal CAS_inv : OUT std_logic;
        signal WE_inv : OUT std_logic;
        signal UDQS : OUT std_logic;
        signal UDQS_inv : OUT std_logic;
        signal LDQS : OUT std_logic;
        signal LDQS_inv : OUT std_logic;
        signal UDM : OUT std_logic;
        signal LDM : OUT std_logic;
        
        signal DQ : INOUT std_logic_vector (15 downto 0);
        --Looking-out-of-chip ports
        
        signal reset_is_ongoing : INOUT std_logic;
        signal ready_internal : INOUT std_logic;
        
        signal state_counter : unsigned(16 downto 0)
        ) is
    begin
    
        if (state_counter = 0) then
            RESET_out <= '0';
            CKE <= '0';
            ODT <= '0';
        end if;
        
        if (state_counter = 25000) then
            RESET_out <= '1';
        end if;
        --
        --
        -- T = 500us(MIN), waiting for 550us
        -- 
        --
        if (state_counter = 80000) then
            CKE <= '1';
            command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        --
        -- 
        -- tXPR - greater of 5CK or tRFC + 10ns, tRFC = 160ns, tXPR >= 170ns, 
        -- waiting for 200ns
        --
        if (state_counter = 80020) then
            command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
            BA <= "010"; --MR2 register
            A(13 downto 11) <= (others => '0'); --RFU, always 0
            A(8) <= '0'; --RFU, always 0
            A(2 downto 0) <= (others => '0'); --RFU, always 0
            A(10 downto 9) <= "00"; --ODT, including dynamic ODT, is disabled due to DLL_DISABLE operation mode
            A(7) <= '0'; --SRT is normal, operating temperature is not expected to exceed 85C
            A(6) <= '0'; --ASR is disabled, operating temperature is not expected to exceed 85C
            A(5 downto 3) <= "001"; --CAS Write Latecy is set to 6 CK, as it is the only available mode with DLL disabled
        end if;
        if (state_counter = 80021) then
            command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        --
        --
        -- tMRD - 4CK or greater
        --
        --
        if (state_counter = 80025) then
            command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
            BA <= "011"; --MR3 register
            A(13 downto 3) <= (others => '0'); --RFU, always 0
            A(2) <= '0'; --MPR function is disabled
            A(1 downto 0) <= (others => '0'); -- Ignored by DRAM as MPR function is disabled
        end if;
        if (state_counter = 80026) then
            command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        --
        --
        -- tMRD - 4CK or greater
        --
        --
        if (state_counter = 80030) then
            command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
            BA <= "001"; --MR1 register
            A(13) <= '0'; A(10) <= '0'; A(8) <= '0';  --RFU, always 0  
            A(12) <= '0'; --Q off is enabled, DQ, DQS, DQS# are in normal mode operation
            A(11) <= '0'; --TDQS feature is disabled, as it's available only for x8 DRAM
            A(9) <= '0'; A(6) <= '0'; A(2) <= '0'; -- ODT is disabled, as it's not supported in DLL disable mode
            A(7) <= '0';  --Write leveling is disabled
            A(5) <= '0'; A(1) <= '1'; --Output drive strength is set to 34 Ohm
            A(4 downto 3) <= "00"; --Additive latency is disabled, AL = 0
            A(0) <= '0'; --DLL is disabled 
        end if;
        if (state_counter = 80031) then
            command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        --
        --
        -- tMRD - 4CK or greater
        --
        --
        if (state_counter = 80035) then
            BA <= "000"; --MR0 Register
            A(13) <= '0'; A(7) <= '0'; --RFU, always 0
            A(12) <= '0'; --DLL is off during precharge power-down mode
            A(11 downto 9) <= "010"; --Write recovery is set to 6. Stated that its got to be 
                                     --more than 40ns. CK is 10ns. So tWR equal 6 is enough.
            A(8) <= '0'; --DLL Reset is disabled, as SDRAM is operating in DLL disable mode
            A(6) <= '0'; A(5) <= '1'; A(4) <= '0'; A(2) <= '0'; --CAS Latency is set to 6, as its
                                                                --the only possible mode with DLL off
            A(3) <= '0'; --READ Burst type is set to sequential
            A(1 downto 0) <= "00"; --Burst length is set to "Fixed BL8"
        end if;
        if (state_counter = 80036) then
            command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        --
        --
        -- tMOD - 12CK or greater
        --
        --
        if (state_counter = 80050) then
            command(ZQCL, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        if (state_counter = 80051) then
            command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
        end if;
        --
        --
        -- tZQinit - 512CK or greater
        --
        --
        if (state_counter = 80600) then
            reset_is_ongoing <= '0';
            ready_internal <= '1';
        end if;
                    
    end procedure;
end reset_st;
