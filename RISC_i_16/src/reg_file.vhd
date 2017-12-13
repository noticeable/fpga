------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    2017-09-19
-- Parts by
--  
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.risc_i_16_pack.all;

entity reg_file is
  
  generic (
    registers_g : integer := registers_c);

  port (
    clk_i             : in  std_ulogic;
    res_i             : in  std_ulogic;
 
    reg_a_idx_i       : in  reg_idx_t;
    reg_b_idx_i       : in  reg_idx_t;
    clk_en_reg_file_i : in  std_ulogic;
    
    reg_i             : in  data_vec_t;
    reg_a_o           : out data_vec_t;
    reg_b_o           : out data_vec_t);

end reg_file;

architecture rtl of reg_file is

  type reg_file_t is array (0 to registers_g - 1) of data_vec_t;
  signal reg_file : reg_file_t;
  
  -- help dc, be structural
  type clk_en_t is array(0 to registers_g - 1) of std_ulogic;
  signal clk_en : clk_en_t;
  
begin  -- rtl

  clk_en_generate: for i in 0 to registers_g - 1 generate
    clk_en(i) <= clk_en_reg_file_i when reg_a_idx_i = i else
                 '0';
  end generate clk_en_generate;

  -- purpose: register file
  -- type   : sequential
  -- inputs : clk_i
  -- outputs: 
  reg_file_inst: process (clk_i, res_i)
  begin  -- process reg_file_inst
    if res_i = reset_active_nc then
      for i in reg_file'range loop
        reg_file(i) <= (others => '0');
      end loop;
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      for i in 0 to registers_g - 1 loop
        if clk_en(i) = '1' then
          reg_file(i) <= reg_i;
        end if;
      end loop;  -- i
    end if;
  end process reg_file_inst;
  
  reg_a_o <= (others => 'X') when reg_a_idx_i = -1 else
             reg_file(reg_a_idx_i);

  reg_b_o <= (others => 'X') when reg_b_idx_i = -1 else
             reg_file(reg_b_idx_i);

end rtl;
