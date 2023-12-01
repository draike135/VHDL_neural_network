LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY rd_mems_tb IS
END rd_mems_tb;
 
ARCHITECTURE behavior OF rd_mems_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
COMPONENT images_mem
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
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

   --Inputs
   signal clk : std_logic := '0';
   signal addr_im : std_logic_vector(11 downto 0) := (others => '0');
   signal addr_w1 : std_logic_vector(12 downto 0) := (others => '0');
   signal addr_w2 : std_logic_vector(6 downto 0) := (others => '0');
   
 	--Outputs
   signal im_row : std_logic_vector(31 downto 0);
   signal w1_out : std_logic_vector(15 downto 0);
   signal w2_out : std_logic_vector(31 downto 0);

   type weight1_t is array (3 downto 0) of signed (3 downto 0);
   signal weight1 : weight1_t;   -- 4-bit
   type weight2_t is array (3 downto 0) of signed (7 downto 0);
   signal weight2 : weight2_t;   -- 8-bit

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant t_hdelay : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Units Under Test (UUT)
instance_images : images_mem
  PORT MAP (
    clka => clk,
    wea => "0",
    addra => addr_im,
    dina => (others => '0'),
    douta => im_row,
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
    addra => addr_w1,
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
    addra => addr_w2,
    dina => (others => '0'),
    douta => w2_out,
    clkb => clk,
    web => "0",
    addrb => (others => '0'),
    dinb => (others => '0'),
    doutb => open
  );    
          
   -- Clock definition
   clk <= not clk after clk_period/2;

   ex_weights1: for k in 0 to 3 generate     -- 4 weights per word;
     weight1(k) <= signed(w1_out(4*k+3 downto 4*k));
     weight2(k) <= signed(w2_out(8*k+7 downto 8*k));
   end generate;
            
   -- Simulation of address generation
   sim_rd_mem_image: process
   begin		
     -- hold reset state for 100 ns.
     wait for 100 ns;	
     wait for clk_period*10;

     -- insert stimulus here 
     -- note that input signals should never change at the positive edge of the clock
     -- synchronize input variation with positive clock edge + hdelay 
     wait until rising_edge(clk); wait for t_hdelay; 
     for imn in 0 to 119 loop   -- iterate through 120 images
       for i in 0 to 31 loop    -- iterate throug 32 rows
         addr_im <= std_logic_vector(to_unsigned (imn*32+i, addr_im'length ));
         wait for clk_period;
       end loop;
     end loop;
     wait;
   end process;

   sim_rd_mem_weights1: process
   begin		
     -- hold reset state for 100 ns.
     wait for 100 ns;	
     wait for clk_period*10;

     -- insert stimulus here 
     -- note that input signals should never change at the positive edge of the clock
     -- synchronize input variation with positive clock edge + hdelay 
     wait until rising_edge(clk); wait for t_hdelay; 
        
     for filter in 0 to 31 loop   -- iterate through 32 filters
       for i in 0 to 255 loop     -- iterate through 1024/4 positions
         addr_w1 <= std_logic_vector(to_unsigned (filter*256+i, addr_w1'length ));
         wait for clk_period;
       end loop;
     end loop;
     wait;
   end process;
   
   sim_rd_mem_weights2: process
   begin		
     -- hold reset state for 100 ns.
     wait for 100 ns;	
     wait for clk_period*10;

     -- insert stimulus here 
     -- note that input signals should never change at the positive edge of the clock
     -- synchronize input variation with positive clock edge + hdelay 
     wait until rising_edge(clk); wait for t_hdelay; 
        
     for filter in 0 to 9 loop  -- iterate through 10 filters
       for i in 0 to 7 loop     -- iterate through 32/4 positions
         addr_w2 <= std_logic_vector(to_unsigned (filter*8+i, addr_w2'length ));
         wait for clk_period;
       end loop;
     end loop;
     wait;
   end process;
   
END;
