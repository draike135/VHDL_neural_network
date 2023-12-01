library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
  port (
    en_layer1,en_layer2: out std_logic;
    clk, rst, exec: in std_logic;
    rst_accum:out std_logic;
    done1 : in std_logic;
    done2: in std_logic
        );
end control;

architecture Behavioral of control is
  type fsm_states is ( s_initial, s_end, s_layer_1, s_layer_2);
  signal currstate, nextstate: fsm_states;

begin
  state_reg: process (clk)
  begin 
    if clk'event and clk = '1' then
      if rst = '1' then
        currstate <= s_initial ;
      else
        currstate <= nextstate ;
      end if ;
    end if ;
  end process;

  state_comb: process (currstate,exec,done1,done2)
  begin  --  process
    -- by default, does not change the state.
    nextstate<=currstate;

    case currstate is
      when s_initial =>
      rst_accum<='1';
      en_layer1<='0';
      en_layer2<='0';
        if exec='1' then
          nextstate <= s_layer_1 ;
        end if;

      when s_layer_1 =>
        rst_accum<='0';
        en_layer1<='1';
        en_layer2<='0';
        if done1 = '1' then
        nextstate <= s_layer_2;
        end if;

      when s_layer_2 =>
        rst_accum<='0';
        en_layer1<='0';
        en_layer2<='1';
        if done2 = '1' then
        nextstate <= s_end;
        end if;


      when s_end =>
        rst_accum<='0';
        en_layer1<='0';
        en_layer2<='0';
        nextstate <= s_end;

        en_layer1<='0';
        en_layer2<='0';

    end case;
  end process;

end Behavioral;