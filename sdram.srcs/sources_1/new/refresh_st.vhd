
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.COMMANDS.ALL;

library UNISIM;
use UNISIM.VComponents.all;


package refresh_st is
    procedure refresh_state(
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
        
        --signal reset_is_ongoing : INOUT std_logic;
        signal ready_internal : INOUT std_logic;
        
        signal state_counter : unsigned(16 downto 0)
        );
end package;

package body refresh_st is

    procedure refresh_state (
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
        
        --signal reset_is_ongoing : INOUT std_logic;
        signal ready_internal : INOUT std_logic;
        
        signal state_counter : unsigned(16 downto 0)
        ) is
    begin
    
 
    end procedure;
end refresh_st;
