library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity circuito is
  port (
    image:in std_logic_vector(11 downto 0);
    clk,exec, rst: in std_logic;
    res_ref:out std_logic_vector(3 downto 0);
    res:out std_logic_vector(26 downto 0)
    
    );
end circuito;

architecture Behavioral of circuito is
  component control
    port(
    en_layer1,en_layer2: out std_logic;
    clk, rst, exec: in std_logic;
    rst_accum:out std_logic;
    done1 : in std_logic;
    done2: in std_logic
      );
  end component;
  component datapath
    port(
    rst_accum:in std_logic;
    en_layer1,en_layer2: in std_logic;
    images_addra: IN STD_LOGIC_VECTOR(11 DOWNTO 0);--adress port a
    clk: in std_logic;
    done: out std_logic;
    done2: out std_logic;
    resultado_vl:out std_logic_vector(26 downto 0);
    resultado:out std_logic_vector(3 downto 0)
      );
  end component;  
  signal enbles: std_logic_vector(1 downto 0);
  signal done_w:std_logic ;
  signal done_w2:std_logic ;
  signal rst_accum: std_logic;

  signal final_res:std_logic_vector(3 downto 0);
  
  signal final_res_vali:std_logic_vector(27 downto 0);

begin
  inst_control: control port map(
    rst_accum=>rst_accum,
    en_layer1=>enbles(0),
    en_layer2=>enbles(1),
    clk => clk,
    rst => rst,
    exec=> exec,
    done1=>done_w,
    done2=>done_w2
    );
  inst_datapath: datapath port map(
    rst_accum=>rst_accum,
    en_layer1=>enbles(0),
    en_layer2=>enbles(1),
    images_addra=>image,
    clk => clk,
    done=>done_w,
    done2=>done_w2,
    resultado=>res_ref,
    resultado_vl=>res
    );

end Behavioral;
