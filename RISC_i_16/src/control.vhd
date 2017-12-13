------------------------------------------------------------------------------
-- Project: 
-- Author:  
-- Date:    
-- Parts by
--  
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.risc_i_16_pack.all;

entity control is
  
  port (
    clk_i              : in  std_ulogic;
    res_i              : in  std_ulogic;
    
    -- datapath
    op_code_i          : in  op_code_t;
    reg_decode_error_i : in  std_ulogic;
    
    sel_pc_o           : out std_ulogic;
    sel_load_o         : out std_ulogic;
    sel_addr_o         : out std_ulogic;
    
    clk_en_pc_o        : out std_ulogic;
    clk_en_reg_file_o  : out std_ulogic;
    clk_en_op_code_o   : out std_ulogic;

    -- alu
    alu_func_o         : out alu_func_t;
    carry_o            : out std_ulogic;
    carry_i            : in  std_ulogic;
    zero_i             : in  std_ulogic;

    -- memory
    mem_rd_stb_o       : out std_ulogic;
    mem_wr_stb_o       : out std_ulogic;

    -- error flag (invalid opcode or register decode error)
    illegal_inst_o     : out std_ulogic;
    -- sleep instruction encountered
    cpu_halt_o         : out std_ulogic);

end control;

architecture rtl of control is

  subtype cycle_t is natural range 0 to 2;
  signal cycle, next_cycle : cycle_t;

  signal carry, next_carry : std_ulogic;
  signal zero, next_zero   : std_ulogic;

  signal illegal_inst : std_ulogic;
  signal cpu_halt     : std_ulogic;
  
  signal mem_rd_stb : std_ulogic;
  signal mem_wr_stb : std_ulogic;
  
begin  -- rtl

  -- purpose: dedect invalid op code
  -- type   : combinational
  -- inputs : op_code_i, reg_decode_error_i
  -- outputs: 
  check_op_code: process (op_code_i, reg_decode_error_i)
  begin  -- process check_op_code
    case op_code_i is
      when  opc_nop_c | opc_sleep_c | opc_loadi_c | opc_load_c |
        opc_store_c | opc_jump_c | opc_jumpc_c | opc_jumpz_c |
        opc_move_c | opc_and_c | opc_or_c | opc_xor_c | opc_not_c |
        opc_add_c | opc_addc_c | opc_sub_c | opc_subc_c |
        opc_comp_c | opc_inc_c | opc_dec_c | opc_shl_c |
        opc_shr_c | opc_shlc_c | opc_shrc_c => 
        illegal_inst <= reg_decode_error_i;
      when others =>
        illegal_inst <= '1';
    end case;
  end process check_op_code;
  
  -- purpose: decode op_code
  -- type   : combinational
  -- inputs : cycle, op_code_i, illegal_inst,
  --          carry_i, carry, zero_i, zero
  -- outputs: 
  decode_op: process (cycle, op_code_i, illegal_inst,
                      carry_i, carry, zero_i, zero)
  begin  -- process decode_op
    next_carry        <= carry;
    next_zero         <= zero;
    cpu_halt          <= '0';
    mem_rd_stb        <= '0';
    mem_wr_stb        <= '0';
    sel_pc_o          <= '0';
    sel_load_o        <= '0';
    sel_addr_o        <= '0';
    clk_en_pc_o       <= '0';
    clk_en_reg_file_o <= '0';
    clk_en_op_code_o  <= '0';
    alu_func_o        <= (others => '-');
    carry_o           <= '0';
    case cycle is
      when 0 =>
        next_cycle  <= cycle + 1;
        sel_pc_o    <= '1';
        alu_func_o  <= alu_inc_c;
        clk_en_pc_o <= '1';
        case op_code_i is
          when opc_jump_c =>
            sel_pc_o <= '0';
          when opc_jumpc_c =>
            sel_pc_o <= not carry;
          when opc_jumpz_c =>
            sel_pc_o <= not zero;
          when others =>
            null;
        end case;
        if op_code_i = opc_store_c then
          mem_wr_stb <= '1';
        else                    
          mem_rd_stb <= '1';
        end if;
      when 1 =>
        next_cycle       <= 0;
        clk_en_op_code_o <= '1';
        if illegal_inst = '1' then
          -- treat as nop
          null;
        else
          case op_code_i is
            when opc_sleep_c =>
              cpu_halt          <= '1';
              clk_en_op_code_o  <= '0';
            when opc_loadi_c =>
              sel_pc_o          <= '1';
              alu_func_o        <= alu_inc_c;
              clk_en_pc_o       <= '1';
              sel_load_o        <= '1';
              clk_en_reg_file_o <= '1';
              mem_rd_stb        <= '1';
              clk_en_op_code_o  <= '0';
              next_cycle        <= 2;
            when opc_load_c  =>
              sel_addr_o        <= '1';
              sel_load_o        <= '1';
              clk_en_reg_file_o <= '1';
              mem_rd_stb        <= '1';
              clk_en_op_code_o  <= '0';
              next_cycle        <= 2;
            when opc_store_c =>
              sel_addr_o        <= '1';
              mem_rd_stb        <= '1';
              clk_en_op_code_o  <= '0';
              next_cycle        <= 2;
            when opc_move_c |
              opc_and_c | opc_or_c | opc_xor_c | opc_not_c |
              opc_add_c | opc_addc_c | opc_sub_c | opc_subc_c |
              opc_comp_c | opc_inc_c | opc_dec_c |
              opc_shl_c | opc_shlc_c | opc_shr_c | opc_shrc_c =>
              next_carry        <= carry_i;
              next_zero         <= zero_i;
              clk_en_reg_file_o <= '1';
              case op_code_i is
                when opc_move_c =>
                  alu_func_o        <= alu_pass_b_c;
                  next_carry        <= carry;
                  next_zero         <= zero;
                when opc_and_c  =>
                  alu_func_o        <= alu_and_c;
                  next_carry        <= '0';
                when opc_or_c   =>
                  alu_func_o        <= alu_or_c;
                  next_carry        <= '0';
                when opc_xor_c  =>
                  alu_func_o        <= alu_xor_c;
                  next_carry        <= '0';
                when opc_not_c  =>
                  alu_func_o        <= alu_not_c;
                  next_carry        <= '0';
                when opc_add_c  =>
                  alu_func_o        <= alu_add_c;
                when opc_addc_c =>
                  alu_func_o        <= alu_add_c;
                  carry_o           <= carry;
                when opc_sub_c  =>
                  alu_func_o        <= alu_sub_c;
                when opc_subc_c =>
                  alu_func_o        <= alu_sub_c;
                  carry_o           <= carry;
                when opc_comp_c =>
                  alu_func_o        <= alu_sub_c;
                  clk_en_reg_file_o <= '0';
                when opc_inc_c  =>
                  alu_func_o        <= alu_inc_c;
                when opc_dec_c  =>
                  alu_func_o        <= alu_dec_c;
                when opc_shl_c  =>
                  alu_func_o        <= alu_slc_c;
                when opc_shlc_c =>
                  alu_func_o        <= alu_slc_c;
                  carry_o           <= carry;
                when opc_shr_c  =>
                  alu_func_o        <= alu_src_c;
                when opc_shrc_c =>
                  alu_func_o        <= alu_src_c;
                  carry_o           <= carry;
                when others     =>
                  null;
              end case;
            when others =>
              null;
          end case;
        end if;
      when 2 =>
        clk_en_op_code_o <= '1';
        next_cycle       <= 0;
    end case;
  end process decode_op;

  -- purpose: update state
  -- type   : sequential
  -- inputs : clk_i, res_i
  -- outputs: 
  update_state: process (clk_i, res_i)
  begin  -- process update_state
    if res_i = reset_active_nc then -- asynchronous reset (active low)
      cycle          <= 0;
      carry          <= '0';
      zero           <= '0';
      illegal_inst_o <= '0';
      cpu_halt_o     <= '0';
      mem_rd_stb_o   <= '0';
      mem_wr_stb_o   <= '0';
    elsif clk_i'event and clk_i = '1' then  -- rising clock edge
      cycle          <= next_cycle;
      carry          <= next_carry;
      zero           <= next_zero;
      illegal_inst_o <= illegal_inst;
      cpu_halt_o     <= cpu_halt;
      mem_rd_stb_o   <= mem_rd_stb;
      mem_wr_stb_o   <= mem_wr_stb;
    end if;
  end process update_state;
  
end rtl;
