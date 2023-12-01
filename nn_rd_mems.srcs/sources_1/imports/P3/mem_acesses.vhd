library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_acesses is
  port (
    clk: in std_logic;
    addrin_imagens: in std_logic_vector(11 downto 0);
    addrin_w1: in std_logic_vector(12 downto 0);
    addrin_w2: in std_logic_vector(6 downto 0);
    im_row: out std_logic_vector(31 downto 0);
    weight1_4: out std_logic_vector(15 downto 0);
    weight2_4: out std_logic_vector(31 downto 0)
    );
end mem_acesses;

architecture Behavioral of mem_acesses is
COMPONENT images_mem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0); --write enable
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0); --adress port a
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0); --data in
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); --data out
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;
COMPONENT weights1
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) 
  );
END COMPONENT;
COMPONENT weights2
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;

  signal zeros : std_logic_vector(15 downto 0);
  signal im_out, w2_out : std_logic_vector(31 downto 0);
  signal w1_out : std_logic_vector(15 downto 0);
  signal addr_w1 : std_logic_vector(12 downto 0);

begin
zeros <= (others => '0');

instance_images : images_mem
  PORT MAP (
    clka => clk,
    wea => "0",
    addra => addrin_imagens,
    dina => (others => '0'),
    douta => im_out,
    clkb => clk,
    web => "0",
    addrb => (others => '0'),
    dinb => (others => '0'),
    doutb => open
  );

instance_weights1 : weights1
  PORT MAP (
    clka => clk,
    wea => "0",
    addra =>  addrin_w1,
    dina => (others => '0'),
    douta => w1_out,
    clkb => clk,
    web => "0",
    addrb => (others => '0'),
    dinb => (others => '0'),
    doutb => open
  );
  
  instance_weights2 : weights2
  PORT MAP (
    clka => clk,
    wea => "0",
    addra => addrin_w2,
    dina => (others => '0'),
    douta => w2_out,
    clkb => clk,
    web => "0",
    addrb => (others => '0'),
    dinb => (others => '0'),
    doutb => open
  );    
  
  im_row <= im_out(31 downto 0);
  weight1_4 <= w1_out(15 downto 0);
  weight2_4 <= w2_out(31 downto  0);
   
end Behavioral;

