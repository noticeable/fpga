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

--上面是实体，四个输入实体变量，三个输出实体变量


--下面是结构体


architecture rtl of alu is

  -- helper signals for adder
  signal add_b    : std_ulogic_vector(bit_width_g - 1 downto 0);--将side_in_b 赋值给add_b,赋值语句在后面,就是说把add_b作为中间变量在加法算法中进行操作
  signal add_cin  : std_ulogic;                                 --同理，把carry_i赋值給add_cin
  signal add_res  : std_ulogic_vector(bit_width_g - 1 downto 0);
  signal add_cout : std_ulogic;
  
  -- helper signals for xorer
  signal xor_res  : std_ulogic_vector(bit_width_g - 1 downto 0);
  signal xor_zout : std_ulogic; 
  
  --上面是对这个结构体进行一些中间量初始化，目前它只是定义了加法中需要的一些变量，我们需要在上面补充我们其他算法的变量


  --下面是结构体的算法具体操作，它只是给出了加法的实现，我们要在这块加入其他算法代码

begin  -- rtl

  -- purpose: shared adder instance
  -- type   : combinational
  -- inputs : side_a_i, add_b, add_cin
  -- outputs: 
  adder_inst: process (side_a_i, add_b, add_cin)
    variable res_v : unsigned(bit_width_g + 1 downto 0);--这里实现对加法结果存储变量的初始化，也就是总位数加一
  begin  -- process adder_inst
    
    res_v := unsigned('0' & side_a_i & '1') +
             unsigned('0' & add_b & add_cin);--加法操作，输入端的a与输入端的b再加上进位符


    add_res  <= std_ulogic_vector(
      res_v(res_v'high - 1 downto res_v'low + 1));
    add_cout <= res_v(res_v'high);--这一步是实现对加法结果的分片，因为我们的cpu只有16为，需要把它还原成16位如果有进位就把这个进位保存到add_cout

  end process adder_inst;

--下面就是老师说的一个进化后的加法器，他集成了加法，加一，减法，减一
--第一部分是对加法数add_b的操作
  -- drive adder inputs
  with alu_func_i select
    add_b <=
    side_b_i                                            when alu_add_c,
    not side_b_i                                        when alu_sub_c,
    std_ulogic_vector(to_unsigned(1, add_b'length))     when alu_inc_c,
    not std_ulogic_vector(to_unsigned(1, add_b'length)) when alu_dec_c,
    (others => '-')                                     when others;
 
 --下面是对进位的操作
 -- drive adder inputs 
  with alu_func_i select
    add_cin <=
    carry_i     when alu_add_c,
    not carry_i when alu_sub_c,
    '0'         when alu_inc_c,
    '1'         when alu_dec_c,
    '-'         when others;

-- home work : add you code in this part to fulfill all the missing function of ALU  
  -- xor
  xorer_inst: process (side_a_i, side_b_i)
    begin
      xor_res <= std_ulogic_vector(unsigned(side_a_i) XOR unsigned(side_b_i)); 
  end process xorer_inst;  

end rtl;
