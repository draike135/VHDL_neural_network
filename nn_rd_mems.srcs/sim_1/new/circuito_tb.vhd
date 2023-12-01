-------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:31:45 09/10/2014
-- Design Name:   
-- Module Name:   C:/xup/vhdl/introLab/tb_circuito.vhd
-- Project Name:  introLab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: circuito
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY circuito_tb IS
END circuito_tb;
 
ARCHITECTURE behavior OF circuito_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)


    COMPONENT circuito
    port (
    image:in std_logic_vector(11 downto 0);
    clk,exec, rst: in std_logic;
    res_ref:out std_logic_vector(3 downto 0);
    res:out std_logic_vector(26 downto 0)
    
    
    );
    END COMPONENT;
    

   --Inputs
   signal clk, exex, rst : std_logic := '0';
   signal image: std_logic_vector(11 downto 0):="000000000000";
   signal resul:std_logic_vector(3 downto 0);
   signal resul_value:std_logic_vector(27 downto 0);
   -- Clock period definitions
   constant clk_period : time := 30 ns;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: circuito PORT MAP (
          clk => clk,
          exec=>exex,
          rst=>rst,
          image=>image
        );

   -- Clock definition
   clk <= not clk after clk_period/2;

    -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      wait for clk_period*10;
    rst <= '1' after 0 ns;
    exex<= '1' after 0 ns;
    wait for 120 ns;
    exex<= '0' after 10 ns;
    rst <= '0' after 0 ns;
      -- insert stimulus here 
      -- note that input signals should never change at the positive edge of the clock
   
      wait;
   end process;

END;
