------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    
-- History:
-- 2017-12-3 initial version part of the risc_i_package 
-- consists of op_code_c definition, alu_func_c definition 
-- no change meeded in this file unless there is any bug
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package risc_i_16_pack is

  ----------------------------------------------------------------------
  -- clock, reset and sync regs
  constant clock_frequency_c : natural    := 5_000_000;
  -- pragma synthesis_off
  constant clock_period_c    : time       := 1 sec / clock_frequency_c;
  -- pragma synthesis_on
  constant reset_active_nc   : std_ulogic := '0';
  -- how many synchronizer FFs
  constant nr_of_sync_ffs_c  : natural    := 3;
  
  ----------------------------------------------------------------------
  -- address and data vectors
  constant data_vec_length_c : natural := 16;
  subtype data_vec_t is std_ulogic_vector(data_vec_length_c - 1 downto 0);

  ----------------------------------------------------------------------
  -- register set
  constant registers_c : natural := 8;  -- max 32
  -- -1 is 'X' or out of range
  subtype reg_idx_t is integer range -1 to registers_c - 1;

  ----------------------------------------------------------------------
  -- op codes
  subtype op_code_range_t is natural range 15 downto 10;
  subtype ra_range_t      is natural range  9 downto 5;
  subtype rb_range_t      is natural range  4 downto 0;
  
  subtype op_code_t is std_ulogic_vector(5 downto 0);
  constant opc_nop_c   : op_code_t := "000000";
  constant opc_sleep_c : op_code_t := "000001";
  constant opc_loadi_c : op_code_t := "000010";
  constant opc_load_c  : op_code_t := "000011";
  constant opc_store_c : op_code_t := "000100";
  constant opc_jump_c  : op_code_t := "001000";
  constant opc_jumpc_c : op_code_t := "001010";
  constant opc_jumpz_c : op_code_t := "001011";
  constant opc_move_c  : op_code_t := "001100";
  constant opc_and_c   : op_code_t := "010000";
  constant opc_or_c    : op_code_t := "010001";
  constant opc_xor_c   : op_code_t := "010010";
  constant opc_not_c   : op_code_t := "010011";
  constant opc_add_c   : op_code_t := "010100";
  constant opc_addc_c  : op_code_t := "010101";
  constant opc_sub_c   : op_code_t := "010110";
  constant opc_subc_c  : op_code_t := "010111";
  constant opc_comp_c  : op_code_t := "011000";
  constant opc_inc_c   : op_code_t := "011010";
  constant opc_dec_c   : op_code_t := "011011";
  constant opc_shl_c   : op_code_t := "011100";
  constant opc_shr_c   : op_code_t := "011101";
  constant opc_shlc_c  : op_code_t := "011110";
  constant opc_shrc_c  : op_code_t := "011111";

  subtype mnemonic_t is string(1 to 15);
  type mnemonic_table_t is array(0 to 2**op_code_t'length - 1) of mnemonic_t;
  constant mnemonic_table_c : mnemonic_table_t := (
    00 => "NOP            ",
    -- unfortunately, we can't use
    -- to_integer(unsigned(opc_nop_c)) => "NOP            ",
    -- because:
    -- Aggregate with multiple choices has a non-static choice.
    01 => "SLEEP          ",
    02 => "LOADI $a, imm  ",
    03 => "LOAD $a, $b    ",
    04 => "STORE $a, $b   ",
    08 => "JUMP $a        ",
    10 => "JUMPC $a       ",
    11 => "JUMPZ $a       ",
    12 => "MOVE $a, $b    ",
    16 => "AND $a, $b     ",
    17 => "OR $a, $b      ",
    18 => "XOR $a, $b     ",
    19 => "NOT $a         ",
    20 => "ADD $a, $b     ",
    21 => "ADDC $a, $b    ",
    22 => "SUB $a, $b     ",
    23 => "SUBC $a, $b    ",
    24 => "COMP $a, $b    ",
    26 => "INC $a         ",
    27 => "DEC $a         ",
    28 => "SHL $a         ",
    29 => "SHR $a         ",
    30 => "SHLC $a        ",
    31 => "SHRC $a        ",
    others => "n/a (reserved) ");
  
  ----------------------------------------------------------------------
  -- alu
  subtype alu_func_t is std_ulogic_vector(3 downto 0);
  
  constant alu_add_c    : alu_func_t := "1000";
  constant alu_inc_c    : alu_func_t := "1001";
  constant alu_sub_c    : alu_func_t := "1010";
  constant alu_dec_c    : alu_func_t := "1011";
  
  constant alu_pass_a_c : alu_func_t := "0000";
  constant alu_pass_b_c : alu_func_t := "0001";
  constant alu_and_c    : alu_func_t := "0010";
  constant alu_or_c     : alu_func_t := "0011";
  constant alu_xor_c    : alu_func_t := "0100";
  constant alu_not_c    : alu_func_t := "0101";
  constant alu_slc_c    : alu_func_t := "0110"; -- shift left w/ carry
  constant alu_src_c    : alu_func_t := "0111"; -- shift reight w/ carry


  
end risc_i_16_pack;

