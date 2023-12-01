library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity disp7m is
  port (
   digit3, digit2, digit1, digit0 : in std_logic_vector(3 downto 0);
   dp3, dp2, dp1, dp0, minus_sign : in std_logic;
   clk : in std_logic;
   dactive : in std_logic_vector(3 downto 0);
   en_disp_l : out std_logic_vector(3 downto 0);
   segm_l : out std_logic_vector(6 downto 0);
   dp_l : out std_logic
  );
end disp7m;

architecture mixed of disp7m is
  signal disp, minus_segm : std_logic_vector(6 downto 0);
  signal sel_disp, ddigit : std_logic_vector(3 downto 0);
  signal ndisp : std_logic_vector(1 downto 0);
  signal clkdiv : std_logic_vector(19 downto 0);
  

begin

  process (clk)
  begin
    if rising_edge(clk) then
        clkdiv <= clkdiv + 1;
    end if;
  end process;
  ndisp <= clkdiv(19 downto 18);
  
  with ndisp select
    ddigit <= digit0 when "00",
              digit1 when "01",
              digit2 when "10",
              digit3 when others;
 
   with ddigit select
   disp <= "0000110" when "0001",   --1
           "1011011" when "0010",   --2
           "1001111" when "0011",   --3
           "1100110" when "0100",   --4
           "1101101" when "0101",   --5
           "1111101" when "0110",   --6
           "0000111" when "0111",   --7
           "1111111" when "1000",   --8
           "1101111" when "1001",   --9
           "1110111" when "1010",   --A
           "1111100" when "1011",   --b
           "0111001" when "1100",   --C
           "1011110" when "1101",   --d
           "1111001" when "1110",   --E
           "1110001" when "1111",   --F
           "0111111" when others;   --0
  minus_segm <= "1000000";
            
  segm_l <= not(minus_segm) when ((minus_sign='1') and (ndisp="11")) else not(disp);
    
  -- 4-to-1 Mux
  with ndisp select
    dp_l <= not(dp0) when "00",
            not(dp1) when "01",
            not(dp2) when "10",
            not(dp3) when others;
  
  -- 4-to-1 Mux
  with ndisp select
    sel_disp  <= "0001" when "00",
                 "0010" when "01",
                 "0100" when "10",
                 "1000" when others;

  en_disp_l(0) <= not(dactive(0) and sel_disp(0));
  en_disp_l(1) <= not(dactive(1) and sel_disp(1));
  en_disp_l(2) <= not(dactive(2) and sel_disp(2));
  en_disp_l(3) <= not(dactive(3) and sel_disp(3));

end mixed;
