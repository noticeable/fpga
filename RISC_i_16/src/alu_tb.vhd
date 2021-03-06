------------------------------------------------------------------------------
-- Project: risc_i_16
-- Author:  
-- Date:    
-- Parts by
--  
------------------------------------------------------------------------------

entity alu_tb is
end alu_tb;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.risc_i_16_pack.all;

architecture beh of alu_tb is

  constant bit_width_c : integer := 16;

  signal side_a    : std_ulogic_vector(bit_width_c - 1 downto 0);
  signal side_b    : std_ulogic_vector(bit_width_c - 1 downto 0);
  signal carry_in  : std_ulogic;
  signal alu_func  : alu_func_t;
  signal result    : std_ulogic_vector(bit_width_c - 1 downto 0);
  signal carry_out : std_ulogic;
  signal zero      : std_ulogic;

begin  -- beh

  DUT: alu
    generic map (
      bit_width_g => bit_width_c)
    port map (
      side_a_i   => side_a,
      side_b_i   => side_b,
      carry_i    => carry_in,
      alu_func_i => alu_func,
      result_o   => result,
      carry_o    => carry_out,
      zero_o     => zero);

  -- purpose: test
  -- type   : combinational
  -- inputs : 
  -- outputs: 
  test_it: process

    constant time_c        : time := 30 ns;
    variable cin_v, cout_v : integer;

    -- purpose: check zero flag
    procedure check_zero_p is
    begin  -- check_zero_p
      assert (to_integer(unsigned(result)) = 0 and zero = '1') or
        (to_integer(unsigned(result)) /= 0 and zero = '0')
        report "zero detection failed" severity failure;
    end check_zero_p;

    -- purpose: calculate compare carry out
    procedure calc_cout_p is
    begin  -- calc_cout_p
      if carry_out = '1' then
        cout_v := 2**bit_width_c;
      else
        cout_v := 0;
      end if;
    end calc_cout_p;
    
  begin  -- process test_it
    
    for i in 0 to 2**bit_width_c - 1 loop
      side_a <= std_ulogic_vector(to_unsigned(i, side_a'length));

      for j in 0 to 2**bit_width_c - 1 loop
        side_b   <= std_ulogic_vector(to_unsigned(j, side_a'length));

        -- add, cin = 0
        carry_in <= '0'; cin_v := 0;
        alu_func <= alu_add_c;
        wait for time_c;
        calc_cout_p;
        assert to_integer(unsigned(result)) + cout_v = i + j + cin_v
          report "add, cin = 0" severity failure;
        check_zero_p;
        
        -- add, cin = 1
        carry_in <= '1'; cin_v := 1;
        alu_func <= alu_add_c;
        wait for time_c;
        calc_cout_p;
        assert to_integer(unsigned(result)) + cout_v = i + j + cin_v
          report "add, cin = 0" severity failure;
        check_zero_p;
        
        -- sub, cin = 0
        carry_in <= '0'; cin_v := 0;
        alu_func <= alu_sub_c;
        wait for time_c;
        calc_cout_p;
        assert to_integer(unsigned(result)) - cout_v = i - j - cin_v
          report "sub, cin = 0" severity failure;
        check_zero_p;
        
        -- sub, cin = 1
        carry_in <= '1'; cin_v := 1;
        alu_func <= alu_sub_c;
        wait for time_c;
        calc_cout_p;
        assert to_integer(unsigned(result)) - cout_v = i - j - cin_v
          report "sub, cin = 1" severity failure;
        check_zero_p;

        -- and
        alu_func <= alu_and_c;
        wait for time_c;
        assert result = (side_a and side_b) report "and" severity failure;
        check_zero_p;

        -- or
        alu_func <= alu_or_c;
        wait for time_c;
        assert result = (side_a or side_b) report "or" severity failure;
        check_zero_p;

        -- xor
        alu_func <= alu_xor_c;
        wait for time_c;
        assert result = (side_a xor side_b) report "xor" severity failure;
        check_zero_p;
        
      end loop;  -- j

      -- inc
      alu_func <= alu_inc_c;
      wait for time_c;
      calc_cout_p;
      assert to_integer(unsigned(result)) + cout_v = i + 1
          report "inc" severity failure;
      check_zero_p;

      -- dec
      alu_func <= alu_dec_c;
      wait for time_c;
      calc_cout_p;
      assert to_integer(unsigned(result)) - cout_v = i - 1
        report "dec" severity failure;
      check_zero_p;

      -- pass a
      alu_func <= alu_pass_a_c;
      wait for time_c;
      assert result = side_a report "pass a" severity failure;
      check_zero_p;

      -- pass b
      alu_func <= alu_pass_b_c;
      wait for time_c;
      assert result = side_b report "pass b" severity failure;
      check_zero_p;

      -- not a
      alu_func <= alu_not_c;
      wait for time_c;
      assert result = not side_a report "not" severity failure;
      check_zero_p;

      -- slc, cin = 0
      carry_in <= '0';
      alu_func <= alu_slc_c;
      wait for time_c;
      assert result = side_a(side_a'high - 1 downto 0) & carry_in
        report "slc" severity failure;
      check_zero_p;

      -- slc, cin = 1
      carry_in <= '1';
      alu_func <= alu_slc_c;
      wait for time_c;
      assert result = side_a(side_a'high - 1 downto 0) & carry_in
        report "slc" severity failure;
      check_zero_p;

      -- src, cin = 0
      carry_in <= '0';
      alu_func <= alu_src_c;
      wait for time_c;
      assert result = carry_in & side_a(side_a'high downto 1)
        report "src" severity failure;
      check_zero_p;
      
      -- src, cin = 1
      carry_in <= '1';
      alu_func <= alu_src_c;
      wait for time_c;
      assert result = carry_in & side_a(side_a'high downto 1)
        report "src" severity failure;
      check_zero_p;
      
    end loop;  -- i

    assert false
      report "tests passed." severity note;
    
    wait;      -- forever
    
  end process test_it;
  

end beh;
