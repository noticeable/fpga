------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    
-- Parts by
--  
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_i_16_pack.all;

entity datapath is

  port (
    clk_i              : in  std_ulogic;
    res_i              : in  std_ulogic;

    -- control
    op_code_o          : out op_code_t;
    -- asserted on register index decode error    
    reg_decode_error_o : out std_ulogic;
    
    sel_pc_i           : in  std_ulogic;
    sel_load_i         : in  std_ulogic;
    sel_addr_i         : in  std_ulogic;
    
    clk_en_pc_i        : in  std_ulogic;
    clk_en_reg_file_i  : in  std_ulogic;
    clk_en_op_code_i   : in  std_ulogic;

    -- alu
    alu_func_i         : in  alu_func_t;
    carry_i            : in  std_ulogic;
    carry_o            : out std_ulogic;
    zero_o             : out std_ulogic;

    -- memory
    mem_addr_o         : out data_vec_t;
    mem_data_o         : out data_vec_t;
    mem_data_i         : in  data_vec_t);

end datapath;

architecture rtl of datapath is
  
  -- registers
  signal pc       : data_vec_t;         -- program counter
  signal ir       : data_vec_t;         -- instruction register
  signal tmp_a    : data_vec_t;
  signal tmp_b    : data_vec_t;

  -- wires
  signal alu_side_a  : data_vec_t;
  signal alu_side_b  : data_vec_t;
  signal alu_result  : data_vec_t;
  signal reg_file_in : data_vec_t;
  signal a_idx       : reg_idx_t;
  signal a_val       : data_vec_t;
  signal b_idx       : reg_idx_t;
  signal b_val       : data_vec_t;

  -- purpose: decode register index
  function decode_reg_idx_f (
    constant ir_c   : in data_vec_t;
    constant high_c : in natural;
    constant low_c  : in natural)
    return reg_idx_t is
    variable res_v : reg_idx_t;
  begin  -- decode_reg_idx_f
    -- pragma synthesis_off
    if is_x(ir_c(high_c downto low_c)) then
      res_v := -1;
    else
    -- pragma synthesis_on
      if to_integer(unsigned(ir_c(high_c downto low_c))) > reg_idx_t'high then
        res_v := -1;
      else
        res_v := to_integer(unsigned(ir_c(high_c downto low_c)));
      end if;
    -- pragma synthesis_off
    end if;
    -- pragma synthesis_on
    return res_v;
  end decode_reg_idx_f;
  
begin

  alu_inst: alu
    generic map (
        bit_width_g => data_vec_t'length)
    port map (
        side_a_i   => alu_side_a,
        side_b_i   => alu_side_b,
        carry_i    => carry_i,
        alu_func_i => alu_func_i,
        result_o   => alu_result,
        carry_o    => carry_o,
        zero_o     => zero_o);

  reg_file_inst: reg_file
    generic map (
        registers_g => registers_c)
    port map (
        clk_i             => clk_i,
        res_i             => res_i,
        reg_a_idx_i       => a_idx,
        reg_b_idx_i       => b_idx,
        clk_en_reg_file_i => clk_en_reg_file_i,
        reg_i             => reg_file_in,
        reg_a_o           => a_val,
        reg_b_o           => b_val);
  
  a_idx              <= decode_reg_idx_f(ir, ra_range_t'high, ra_range_t'low);
  b_idx              <= decode_reg_idx_f(ir, rb_range_t'high, rb_range_t'low);
  reg_decode_error_o <= '1' when a_idx = -1 or b_idx = -1 else
                        '0';
  
  with sel_pc_i select
    alu_side_a <=
    tmp_a           when '0',
    pc              when '1',
    (others => 'X') when others;
  
  alu_side_b <= tmp_b;

  with sel_load_i select
    reg_file_in <=
    alu_result      when '0',
    mem_data_i      when '1',
    (others => 'X') when others;

  with sel_addr_i select
    mem_addr_o <=
    pc              when '0',
    tmp_b           when '1',
    (others => 'X') when others;
  
  op_code_o  <= ir(op_code_range_t);
  mem_data_o <= tmp_a;
  
  -- purpose: registers
  -- type   : sequential
  -- inputs : clk_i, res_i
  -- outputs: 
  state_inst: process (clk_i, res_i)
  begin  -- process state_inst
    if res_i = reset_active_nc then -- asynchronous reset (active low)
      -- start up with a nop instruction at 0xffff
      pc <= (others => '1');
      ir <= (others => '0');
      -- dft_problem: if reset_all_ffs_c then
      tmp_a    <= (others => '0');
      tmp_b    <= (others => '0');
      -- end if;
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      tmp_a <= a_val;
      tmp_b <= b_val;
      if (clk_en_op_code_i = '1') then
        ir <= mem_data_i;
      end if;
      if (clk_en_pc_i = '1') then
        case sel_pc_i is
          when '0'    => pc <= a_val;
          when '1'    => pc <= alu_result;
          when others => pc <= (others=> 'X');
        end case;
      end if;
    end if;
  end process state_inst;

end rtl;
