----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2021 03:17:43
-- Design Name: 
-- Module Name: reset_simulation - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reset_simulation is
--  Port ( );
end reset_simulation;

architecture Behavioral of reset_simulation is
        constant T : time := 20 ns;
        --signal counter : std_logic_vector (3 downto 0) := (others => '0');
        --Looking-into-chip ports
        signal clk : std_logic := '0';
        signal write : std_logic := '0';
        signal read : std_logic := '0';
        signal reset: std_logic := '0';
        signal addr : std_logic_vector (30 downto 0) := (others => '0'); -- Доступно 2 Gb = 2,147,483,648 B памяти, единица адресного разрешения - Byte    
        signal word_size : std_logic_vector (1 downto 0) := (others => '0'); -- Количество байт данных 00 - WORD (2 Bytes); 01 - DWORD (4 Bytes); 10 - QWORD (8 Bytes)
        
        signal ready : std_logic := '0';
        
        signal data : std_logic_vector (127 downto 0) := (others => '0');
        --Looking-into-chip ports
        
        --Looking-out-of-chip ports
        signal RESET_out : std_logic := '0';
        signal A : std_logic_vector (13 downto 0) := (others => '0');
        signal BA : std_logic_vector (2 downto 0) := (others => '0');
        signal ODT : std_logic := '0';
        --signal CK : std_logic := '0';
        --signal CK_inv : std_logic := '0';
        signal CKE : std_logic := '0';
        signal CS_inv : std_logic := '0';
        signal RAS_inv : std_logic := '0';
        signal CAS_inv : std_logic := '0';
        signal WE_inv : std_logic := '0';
        signal UDQS : std_logic := '0';
        signal UDQS_inv : std_logic := '0';
        signal LDQS : std_logic := '0';
        signal LDQS_inv : std_logic := '0';
        signal UDM : std_logic := '0';
        signal LDM : std_logic := '0';
        
        signal DQ : std_logic_vector (15 downto 0)  := (others => '0');
        --Looking-out-of-chip ports
begin
    top_design : entity work.pll_inst
        port map (
        clk => clk,
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
    
    process
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;
    
    reset <= '1', '0' after 10 * T;
    
end Behavioral;
