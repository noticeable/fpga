------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    
-- History:
-- 2017-10-10 initial version 
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

  -- purpose: simple alu operations
  -- type   : combinational
  -- inputs : side_a_i, side_b_i, carry_i, alu_func_i, add_res, add_cout
  -- outputs: 
  alu_ops: process (side_a_i, side_b_i, carry_i, alu_func_i, add_res, add_cout)
    variable res_v   : std_ulogic_vector(bit_width_g - 1 downto 0);
  begin  -- process alu_ops
    carry_o <= '-';
    case alu_func_i is
      -- prioritize late arriving signals
      when alu_add_c | alu_inc_c |
           alu_sub_c | alu_dec_c =>
        res_v   := add_res;
        if alu_func_i = alu_sub_c or alu_func_i = alu_dec_c then
          -- handle carry correctly
          carry_o <= not add_cout;
        else
          carry_o <= add_cout;
        end if;
      when others =>
        case alu_func_i is
          when alu_pass_a_c =>
            res_v := side_a_i;
          when alu_pass_b_c =>
            res_v := side_b_i;
          when alu_and_c =>
            res_v   := side_a_i and side_b_i;
          when alu_or_c =>
            res_v   := side_a_i or side_b_i;
          when alu_xor_c =>
            res_v   := side_a_i xor side_b_i;
          when alu_not_c =>
            res_v   := not side_a_i;
          when alu_slc_c =>
            res_v   := side_a_i(side_a_i'high - 1 downto side_a_i'low) &
                       carry_i;
            carry_o <= side_a_i(side_a_i'high);
          when alu_src_c =>
            res_v   := carry_i &
                       side_a_i(side_a_i'high downto side_a_i'low + 1);
            carry_o <= side_a_i(side_a_i'low);
          when others =>
            res_v   := (others => 'X');
            carry_o <= 'X';
        end case;
    end case;
    -- drive outputs
    result_o <= res_v;
    zero_o   <= not or_reduce(res_v);
  end process alu_ops;
  
end rtl;
