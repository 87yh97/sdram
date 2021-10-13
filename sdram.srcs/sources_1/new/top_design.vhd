
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.COMMANDS.ALL;
use WORK.reset_st.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity top_design is
    Port (
        --Looking-into-chip ports
        signal clk : IN std_logic := '0';
        signal write : IN std_logic := '0';
        signal read : IN std_logic := '0';
        signal reset: IN std_logic := '0';
        signal addr : IN std_logic_vector (30 downto 0) := (others => '0'); -- Доступно 2 Gb = 2,147,483,648 B памяти, единица адресного разрешения - Byte    
        signal word_size : IN std_logic_vector (1 downto 0) := (others => '0'); -- Количество байт данных 00 - WORD (2 Bytes); 01 - DWORD (4 Bytes); 10 - QWORD (8 Bytes)
        
        signal ready : OUT std_logic := '0';
        
        signal data : INOUT std_logic_vector (127 downto 0) := (others => '0');
        --Looking-into-chip ports
        
        --Looking-out-of-chip ports
        signal RESET_out : OUT std_logic := '0';
        signal A : OUT std_logic_vector (13 downto 0) := (others => '0');
        signal BA : OUT std_logic_vector (2 downto 0) := (others => '0');
        signal ODT : OUT std_logic := '0';
        --signal CK : OUT std_logic := '0';
        --signal CK_inv : OUT std_logic := '0';
        signal CKE : OUT std_logic := '0';
        signal CS_inv : OUT std_logic := '0';
        signal RAS_inv : OUT std_logic := '0';
        signal CAS_inv : OUT std_logic := '0';
        signal WE_inv : OUT std_logic := '0';
        signal UDQS : OUT std_logic := '0';
        signal UDQS_inv : OUT std_logic := '0';
        signal LDQS : OUT std_logic := '0';
        signal LDQS_inv : OUT std_logic := '0';
        signal UDM : OUT std_logic := '0';
        signal LDM : OUT std_logic := '0';
        
        signal DQ : INOUT std_logic_vector (15 downto 0)  := (others => '0')
        --Looking-out-of-chip ports
    );
end top_design;

architecture Behavioral of top_design is
    type State_type is (Idle_st, Read_st, Write_st, Refresh_st, Self_Refresh_st, Reset_st);
    signal State : State_type;
    signal ready_internal : std_logic := '1';
    
    signal refresh_counter : unsigned(9 downto 0) := (others => '0');    --Given that frequency is 100 MHz and refresh is required every 7.8us, 
                                                                            --the REFRESH command will be issued every 780 clk cycles.
                                                                            --TODO: Replace this counter with an DSP48 
    signal refresh_needed : std_logic := '0';
    signal state_counter : unsigned(16 downto 0) := (others => '0');
    signal reset_is_ongoing : std_logic := '0';
    

    
begin
    ready <= ready_internal;
    
    process(clk) is
    begin
        if rising_edge(clk) then ------------------------
        
            if reset_is_ongoing = '0' then
                if reset = '1' then
                    State <= Reset_st;
                    state_counter <= to_unsigned(0, 17);
                    ready_internal <= '0';
                    reset_is_ongoing <= '1';
                else
                    if ready_internal = '1' then    
                        if refresh_needed = '1' then
                            State <= Refresh_st;
                            state_counter <= to_unsigned(0, 17);
                            ready_internal <= '0';
                        else
                            if read = '1' then
                                State <= Read_st;
                                state_counter <= to_unsigned(0, 17);
                                ready_internal <= '0';
                            end if;
                            
                            if write = '1' then
                                State <= Write_st;
                                state_counter <= to_unsigned(0, 17);
                                ready_internal <= '0';
                            end if;
                            
                            State <= Idle_st;
                            --state_counter <= to_unsigned(0, 17); --Is this reset needed?
                        end if;
                
                    end if;
                end if;
            end if;
            
--            if State = Reset_st then
--                if (state_counter = 0) then
--                        RESET_out <= '0';
--                        CKE <= '0';
--                        ODT <= '0';
--                end if;
--                if (state_counter = 25000) then
--                    RESET_out <= '1';
--                end if;
                
--                if (state_counter = 80000) then
--                    CKE <= '1';
--                    A(13 downto 0) <= (others => '1');
--                    command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                end if;
                
--                if (state_counter = 80020) then
--                    command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    BA <= "010"; --MR2 register
--                    A(13 downto 11) <= (others => '0'); --RFU, always 0
--                    A(10 downto 9) <= "00"; --ODT, including dynamic ODT is disabled due to DLL_DISABLE operation mode
--                    A(8) <= '0'; --RFU, always 0
--                    A(7) <= '0'; --SRT is normal, operating temperature is not expected to exceed 85C
--                    A(6) <= '0'; --ASR is disabled, operating temperature is not expected to exceed 85C
--                    A(5 downto 3) <= "001";
--                    A(2 downto 0) <= (others => '0'); --RFU, always 0
--                end if;
                
--                state_counter <= state_counter + 1;
--            end if;
            
            case State is
            
                when Reset_st => 
                    
                    reset_state(--clk, 
                                write, read, reset, 
                                addr, word_size, ready, data, 
                                RESET_out, A, BA, ODT, CKE, 
                                CS_inv, RAS_inv, CAS_inv, WE_inv, 
                                UDQS, UDQS_inv, LDQS, LDQS_inv, 
                                UDM, LDM, DQ, reset_is_ongoing, 
                                ready_internal, state_counter);
                    
                    --command(MRS, CS_inv);
--                    if (state_counter = 0) then
--                        RESET_out <= '0';
--                        CKE <= '0';
--                        ODT <= '0';
--                    end if;
                    
--                    if (state_counter = 25000) then
--                        RESET_out <= '1';
--                    end if;
--                    --
--                    --
--                    -- T = 500us(MIN), waiting for 550us
--                    -- 
--                    --
--                    if (state_counter = 80000) then
--                        CKE <= '1';
--                        command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    --
--                    -- 
--                    -- tXPR - greater of 5CK or tRFC + 10ns, tRFC = 160ns, tXPR >= 170ns, 
--                    -- waiting for 200ns
--                    --
--                    if (state_counter = 80020) then
--                        command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                        BA <= "010"; --MR2 register
--                        A(13 downto 11) <= (others => '0'); --RFU, always 0
--                        A(8) <= '0'; --RFU, always 0
--                        A(2 downto 0) <= (others => '0'); --RFU, always 0
--                        A(10 downto 9) <= "00"; --ODT, including dynamic ODT, is disabled due to DLL_DISABLE operation mode
--                        A(7) <= '0'; --SRT is normal, operating temperature is not expected to exceed 85C
--                        A(6) <= '0'; --ASR is disabled, operating temperature is not expected to exceed 85C
--                        A(5 downto 3) <= "001"; --CAS Write Latecy is set to 6 CK, as it is the only available mode with DLL disabled
--                    end if;
--                    if (state_counter = 80021) then
--                        command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    --
--                    --
--                    -- tMRD - 4CK or greater
--                    --
--                    --
--                    if (state_counter = 80025) then
--                        command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                        BA <= "011"; --MR3 register
--                        A(13 downto 3) <= (others => '0'); --RFU, always 0
--                        A(2) <= '0'; --MPR function is disabled
--                        A(1 downto 0) <= (others => '0'); -- Ignored by DRAM as MPR function is disabled
--                    end if;
--                    if (state_counter = 80026) then
--                        command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    --
--                    --
--                    -- tMRD - 4CK or greater
--                    --
--                    --
--                    if (state_counter = 80030) then
--                        command(MRS, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                        BA <= "001"; --MR1 register
--                        A(13) <= '0'; A(10) <= '0'; A(8) <= '0';  --RFU, always 0  
--                        A(12) <= '0'; --Q off is enabled, DQ, DQS, DQS# are in normal mode operation
--                        A(11) <= '0'; --TDQS feature is disabled, as it's available only for x8 DRAM
--                        A(9) <= '0'; A(6) <= '0'; A(2) <= '0'; -- ODT is disabled, as it's not supported in DLL disable mode
--                        A(7) <= '0';  --Write leveling is disabled
--                        A(5) <= '0'; A(1) <= '1'; --Output drive strength is set to 34 Ohm
--                        A(4 downto 3) <= "00"; --Additive latency is disabled, AL = 0
--                        A(0) <= '0'; --DLL is disabled 
--                    end if;
--                    if (state_counter = 80031) then
--                        command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    --
--                    --
--                    -- tMRD - 4CK or greater
--                    --
--                    --
--                    if (state_counter = 80035) then
--                        BA <= "000"; --MR0 Register
--                        A(13) <= '0'; A(7) <= '0'; --RFU, always 0
--                        A(12) <= '0'; --DLL is off during precharge power-down mode
--                        A(11 downto 9) <= "010"; --Write recovery is set to 6. Stated that its got to be 
--                                                 --more than 40ns. CK is 10ns. So tWR equal 6 is enough.
--                        A(8) <= '0'; --DLL Reset is disabled, as SDRAM is operating in DLL disable mode
--                        A(6) <= '0'; A(5) <= '1'; A(4) <= '0'; A(2) <= '0'; --CAS Latency is set to 6, as its
--                                                                            --the only possible mode with DLL off
--                        A(3) <= '0'; --READ Burst type is set to sequential
--                        A(1 downto 0) <= "00"; --Burst length is set to "Fixed BL8"
--                    end if;
--                    if (state_counter = 80036) then
--                        command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    --
--                    --
--                    -- tMOD - 12CK or greater
--                    --
--                    --
--                    if (state_counter = 80050) then
--                        command(ZQCL, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    if (state_counter = 80051) then
--                        command(NOP, CS_inv, RAS_inv, CAS_inv, WE_inv, BA, A);
--                    end if;
--                    --
--                    --
--                    -- tZQinit - 512CK or greater
--                    --
--                    --
--                    if (state_counter = 80600) then
--                        reset_is_ongoing <= '0';
--                        ready_internal <= '1';
--                    end if;
                    
                    
                    
                    
                    
                    
                    
                    
                    -- TODO: Reset the reset_is_ongoing signal to 0 at the end of reset
                    state_counter <= state_counter + 1;
                    
                when Refresh_st =>
                when Self_Refresh_st =>
                when Read_st =>
                when Write_st =>
                when Idle_st =>
                
            end case;
        
        
        end if; ---------------------------------------------
    
    
    end process;
    
    process(clk) is 
    begin
        if rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
            if refresh_counter = 750 then               --TODO:Check the longest possible operation and adjust the flag's assertion period accordingly
                refresh_needed <= '1';
            end if;
        end if;
    
    end process;
    
    
    
    
    
    
    
    
    

end Behavioral;
