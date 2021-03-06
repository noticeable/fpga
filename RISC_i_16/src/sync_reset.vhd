------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    
-- Parts by
--  
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.risc_i_16_pack.all;

entity sync_reset is

  generic (
    nr_of_sync_ffs_g : integer := nr_of_sync_ffs_c);

  port (
    clk_i       : in  std_ulogic;
    res_i       : in  std_ulogic;

    -- bypass dft violation
    test_mode_i : in  std_ulogic;
    
    res_sync_o  : out std_ulogic);       -- synchronized reset
    
end sync_reset;

architecture rtl of sync_reset is

  signal sync_ffs : std_ulogic_vector(0 to nr_of_sync_ffs_g - 1);
  
begin  -- rtl

  -- purpose: synchronize reset
  -- type   : sequential
  -- inputs : clk_i, res_i
  -- outputs: 
  sync_in: process (clk_i, res_i)
  begin  -- process sync_in
    if res_i = reset_active_nc then -- asynchronous reset (active low)
      sync_ffs <= (others => reset_active_nc);
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      sync_ffs <= not reset_active_nc &
                  sync_ffs(0 to sync_ffs'high - 1);
    end if;
  end process sync_in;

  with test_mode_i select -- synopsys infer_mux
    res_sync_o <=
    sync_ffs(sync_ffs'high) when '0',
    res_i                   when '1',
    'X'                     when others;

end rtl;
