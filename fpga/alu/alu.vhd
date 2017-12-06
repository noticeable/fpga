------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    
-- History:
-- 2017-12-3 this is only part of ALU
-- initial version consists of complete entity, complete ADD module and its input add_cin and add_b
-- missing output generation
-- missing functionality of other alu functions like shr, shl, and, not, xor, or etc
--  
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library work;
use work.risc_i_16_pack.all;

entity alu is
  
  -- we do not use data_vec_t to be able to modify the bit width for
  -- functional testing purpose
  generic (
    bit_width_g :     integer := 16);

  port (
    side_a_i    : in  std_ulogic_vector(bit_width_g - 1 downto 0);
    side_b_i    : in  std_ulogic_vector(bit_width_g - 1 downto 0);
    carry_i     : in  std_ulogic;
    alu_func_i  : in  alu_func_t;

    result_o    : out std_ulogic_vector(bit_width_g - 1 downto 0);
    carry_o     : out std_ulogic;
    zero_o      : out std_ulogic);
  
end alu;

architecture rtl of alu is

  -- helper signals for adder
  signal add_b    : std_ulogic_vector(bit_width_g - 1 downto 0);
  signal add_cin  : std_ulogic;
  signal add_res  : std_ulogic_vector(bit_width_g - 1 downto 0);
  signal add_cout : std_ulogic;
  
begin  -- rtl

  -- purpose: shared adder instance
  -- type   : combinational
  -- inputs : side_a_i, add_b, add_cin
  -- outputs: 
  adder_inst: process (side_a_i, add_b, add_cin)
    variable res_v : unsigned(bit_width_g + 1 downto 0);
  begin  -- process adder_inst
    res_v := unsigned('0' & side_a_i & '1') +
             unsigned('0' & add_b & add_cin);
    add_res  <= std_ulogic_vector(
      res_v(res_v'high - 1 downto res_v'low + 1));
    add_cout <= res_v(res_v'high);
  end process adder_inst;  

  -- drive adder inputs
  with alu_func_i select
    add_b <=
    side_b_i                                            when alu_add_c,
    not side_b_i                                        when alu_sub_c,
    std_ulogic_vector(to_unsigned(1, add_b'length))     when alu_inc_c,
    not std_ulogic_vector(to_unsigned(1, add_b'length)) when alu_dec_c,
    (others => '-')                                     when others;
 
 -- drive adder inputs 
  with alu_func_i select
    add_cin <=
    carry_i     when alu_add_c,
    not carry_i when alu_sub_c,
    '0'         when alu_inc_c,
    '1'         when alu_dec_c,
    '-'         when others;

-- home work : add you code in this part to fulfill all the missing function of ALU  
  
end rtl;
