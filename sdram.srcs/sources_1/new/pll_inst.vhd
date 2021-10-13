
library IEEE;
Library UNISIM;
library work;
use work.top_design;
use IEEE.STD_LOGIC_1164.ALL;
use UNISIM.vcomponents.all;

-- PLLE2_BASE: Base Phase Locked Loop (PLL)
-- 7 Series
-- Xilinx HDL Language Template, version 2020.1

entity pll_inst is
    Port (
        --Looking-into-chip ports
        signal clk : IN std_logic;
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
        signal CK : OUT std_logic;
        signal CK_inv : OUT std_logic;
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
        
        signal DQ : INOUT std_logic_vector (15 downto 0)
        --Looking-out-of-chip ports  
    );
end pll_inst;

architecture Behavioral of pll_inst is
    signal clk_internal : std_logic := '0';
    signal CLKFB : std_logic := '0';
begin
    PLLE2_BASE_inst : PLLE2_BASE
    generic map (
        BANDWIDTH => "OPTIMIZED", -- OPTIMIZED, HIGH, LOW
        CLKFBOUT_MULT => 16, -- Multiply value for all CLKOUT, (2-64)
        CLKFBOUT_PHASE => 0.0, -- Phase offset in degrees of CLKFB, (-360.000-360.000).
        CLKIN1_PERIOD => 20.0, -- Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
        CLKOUT0_DIVIDE => 8,-- CLKOUT0_DIVIDE - CLKOUT5_DIVIDE: Divide amount for each CLKOUT (1-128)
        CLKOUT1_DIVIDE => 8,
        CLKOUT2_DIVIDE => 8,
        CLKOUT3_DIVIDE => 1,
        CLKOUT4_DIVIDE => 1,
        CLKOUT5_DIVIDE => 1,
        CLKOUT0_DUTY_CYCLE => 0.5, -- CLKOUT0_DUTY_CYCLE - CLKOUT5_DUTY_CYCLE: Duty cycle for each CLKOUT (0.001-0.999).
        CLKOUT1_DUTY_CYCLE => 0.5,
        CLKOUT2_DUTY_CYCLE => 0.5,
        CLKOUT3_DUTY_CYCLE => 0.5,
        CLKOUT4_DUTY_CYCLE => 0.5,
        CLKOUT5_DUTY_CYCLE => 0.5,
        -- CLKOUT0_PHASE - CLKOUT5_PHASE: Phase offset for each CLKOUT (-360.000-360.000).
        CLKOUT0_PHASE => 0.0,
        CLKOUT1_PHASE => 90.0,
        CLKOUT2_PHASE => 270.0,
        CLKOUT3_PHASE => 0.0,
        CLKOUT4_PHASE => 0.0,
        CLKOUT5_PHASE => 0.0,
        DIVCLK_DIVIDE => 1, -- Master division value, (1-56)
        REF_JITTER1 => 0.0, -- Reference input jitter in UI, (0.000-0.999).
        STARTUP_WAIT => "FALSE" -- Delay DONE until PLL Locks, ("TRUE"/"FALSE")
    )
    port map (
        -- Clock Outputs: 1-bit (each) output: User configurable clock outputs
        CLKOUT0 => clk_internal, -- 1-bit output: CLKOUT0
        CLKOUT1 => CK, -- 1-bit output: CLKOUT1
        CLKOUT2 => CK_inv, -- 1-bit output: CLKOUT2
        CLKOUT3 => open, -- 1-bit output: CLKOUT3
        CLKOUT4 => open, -- 1-bit output: CLKOUT4
        CLKOUT5 => open, -- 1-bit output: CLKOUT5
        -- Feedback Clocks: 1-bit (each) output: Clock feedback ports
        CLKFBOUT => CLKFB, -- 1-bit output: Feedback clock
        LOCKED => open, -- 1-bit output: LOCK
        CLKIN1 => clk, -- 1-bit input: Input clock
        -- Control Ports: 1-bit (each) input: PLL control ports
        PWRDWN => '0', -- 1-bit input: Power-down  DOES '1' MEAN THAT ITS POWERED DOWN OR DOES '0' MEAN THAT!?!??!
        RST => '0', -- 1-bit input: Reset
        -- Feedback Clocks: 1-bit (each) input: Clock feedback ports
        CLKFBIN => CLKFB -- 1-bit input: Feedback clock
    );
---- End of PLLE2_BASE_inst instantiation


    top_design : entity work.top_design(Behavioral)
    port map (
        clk => clk_internal,
        write => write, 
        read => read,
        reset => reset,
        addr => addr,
        word_size => word_size,
      
        ready => ready,
      
        data => data,
        
      
        
        RESET_out => RESET_out,
        A => A,
        BA => BA, 
        ODT => ODT,
        --CK => CK,
        --CK_inv => CK_inv,
        CKE => CKE,
        CS_inv => CS_inv,
        RAS_inv => RAS_inv,
        CAS_inv => CAS_inv, 
        WE_inv => WE_inv,
        UDQS => UDQS,
        UDQS_inv => UDQS_inv,
        LDQS => LDQS,
        LDQS_inv => LDQS_inv,
        UDM => UDM,
        LDM => LDM,
       
        DQ => DQ
    );
    
end Behavioral;


















