----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2023 11:01:01
-- Design Name: 
-- Module Name: datapath - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
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
end datapath;

architecture Behavioral of datapath is
signal n:integer;
signal n2:integer;
signal n3:integer;
signal n4:integer;

signal res_reg:std_logic_vector(3 downto 0);

--declarar fios
signal saida_imagema: std_logic_vector (31 DOWNTO 0);
signal  weight1_4: std_logic_vector(15 downto 0);
signal  weight2_4: std_logic_vector(31 downto 0);

--signal delay_256:std_logic;
signal delay_aux:std_logic;

signal accumulator:std_logic_vector(13 downto 0):= (others => '0');
signal accumulator_aux:signed(13 downto 0);
signal ReLu: std_logic_vector(13 downto 0);


signal accumulator2:std_logic_vector(26 downto 0):= (others => '0');
signal accumulator_aux2:signed(26 downto 0):= (others => '0');

signal accum_rst:std_logic;
signal accum_rst2:std_logic;

signal saida_imagem_temp:std_logic_vector (3 downto 0):= (others => '0');
signal saida_w1_temp:std_logic_vector (15 downto 0);
signal count_image:std_logic_vector(12 downto 0);
signal count_image_aux:std_logic_vector(12 downto 0);

signal count_rlayer1:std_logic_vector(6 downto 0);
signal count_rlayer1_aux:std_logic_vector(6 downto 0);

signal count_rlayer1_delay:std_logic_vector(6 downto 0):= (others => '0');
signal count_rlayer1delay_aux:std_logic_vector(6 downto 0):= (others => '0');

signal saida_multiplicacao_sg:signed(15 DOWNTO 0);

signal count_image_delay:std_logic_vector(12 downto 0);
signal count_image_delay_aux:std_logic_vector(12 downto 0);

signal s_image_temp: std_logic_vector (31 DOWNTO 0);
signal s_w1_temp: std_logic_vector (15 DOWNTO 0):= (others => '0');

signal soma1_sg, soma2_sg:  signed (4 downto 0) ;
signal soma3: std_logic_vector (5 downto 0); --topo da piramide
signal soma3_sg: signed (5 downto 0); 

signal saida_multiplicacao: std_logic_vector (15 DOWNTO 0);
signal saida_multiplicacao2: std_logic_vector (87 DOWNTO 0);
signal saida_multiplicacao2_sg: signed (87 DOWNTO 0);



signal soma12_sg, soma22_sg:  signed (22 downto 0) ;
signal soma32: std_logic_vector (23 downto 0); --topo da piramide
signal soma32_sg: signed (23 downto 0); 

signal image_addin:std_logic_vector(11 downto 0);

type reg_array is array (0 to 31) of std_logic_vector(13 downto 0);
signal registers: reg_array;

type reg_array2 is array (0 to 9) of std_logic_vector(26 downto 0);
signal registers2: reg_array2:= (others => (others => '0'));

signal saida_w2:std_logic_vector(31 downto 0);

signal saida_w2_sg:signed(31 downto 0);

signal test: std_logic;

signal temp_test :signed(13 downto 0);
signal temp_test_2 :signed(7 downto 0);

signal buff :std_logic;

 COMPONENT mem_acesses is
  port (
    clk: in std_logic;
    addrin_imagens: in std_logic_vector(11 downto 0);
    addrin_w1: in std_logic_vector(12 downto 0);
    addrin_w2: in std_logic_vector(6 downto 0);
    im_row: out std_logic_vector(31 downto 0);
    weight1_4: out std_logic_vector(15 downto 0);
    weight2_4: out std_logic_vector(31 downto 0)
    );
end component;
begin
image_addin<=std_logic_vector(unsigned (images_addra)+ unsigned (count_image(7 downto 3)));
-- Instantiate the memory
mem_instance: mem_acesses
port map (
    clk => clk,
    addrin_imagens =>image_addin,--  por aqui a soma
    addrin_w1 => count_image(12 downto 0),
    addrin_w2 =>count_rlayer1,
    im_row => saida_imagema,
    weight1_4 => weight1_4,
    weight2_4 => weight2_4
);


s_image_temp<= saida_imagema when en_layer1='1'else (others => '0');
s_w1_temp<=weight1_4 when en_layer1='1'else (others => '0');


saida_imagem_temp <= s_image_temp(3 downto 0) when count_image_delay(2 downto 0) = "000" else
                    s_image_temp(7 downto 4) when count_image_delay(2 downto 0) = "001" else
                    s_image_temp(11 downto 8) when count_image_delay(2 downto 0) = "010" else
                    s_image_temp(15 downto 12) when count_image_delay(2 downto 0) = "011" else
                    s_image_temp(19 downto 16) when count_image_delay(2 downto 0) = "100" else
                    s_image_temp(23 downto 20) when count_image_delay(2 downto 0) = "101" else
                    s_image_temp(27 downto 24) when count_image_delay(2 downto 0) = "110" else
                    s_image_temp(31 downto 28) when count_image_delay(2 downto 0) = "111"else (others => '0');

--multiplicações, estados indifinidos, vamos ter latches
saida_multiplicacao(3 downto 0) <= s_w1_temp(3 downto 0) and (saida_imagem_temp(0)&saida_imagem_temp(0)&saida_imagem_temp(0)&saida_imagem_temp(0))when en_layer1='1'else (others => '0');
saida_multiplicacao(7 downto 4) <= s_w1_temp(7 downto 4) and (saida_imagem_temp(1)&saida_imagem_temp(1)&saida_imagem_temp(1)&saida_imagem_temp(1))when en_layer1='1'else (others => '0');
saida_multiplicacao(11 downto 8) <= s_w1_temp(11 downto 8) and (saida_imagem_temp(2)&saida_imagem_temp(2)&saida_imagem_temp(2)&saida_imagem_temp(2))when en_layer1='1'else (others => '0');
saida_multiplicacao(15 downto 12) <= s_w1_temp(15 downto 12) and (saida_imagem_temp(3)&saida_imagem_temp(3)&saida_imagem_temp(3)&saida_imagem_temp(3))when en_layer1='1'else (others => '0');

------------------------------------------------------------------
saida_multiplicacao_sg<=signed(saida_multiplicacao)when en_layer1='1' else (others => '0');
soma1_sg<=signed(saida_multiplicacao_sg(3) & saida_multiplicacao_sg(3 downto 0))+signed(saida_multiplicacao_sg(7) &saida_multiplicacao_sg(7 downto 4))when en_layer1='1' else
                                  "00000";
soma2_sg<=signed(saida_multiplicacao_sg(11) & saida_multiplicacao_sg(11 downto 8))+signed(saida_multiplicacao_sg(15) & saida_multiplicacao_sg(15 downto 12))when en_layer1='1' else
                                   "00000";
soma3_sg <= (soma1_sg(4) & soma1_sg) + (soma2_sg(4) & soma2_sg)  when en_layer1='1' else "000000"; 


accumulator_aux<=signed(accumulator)+(soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg) when accum_rst='0'else
                (soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg(5)&soma3_sg);


accum_rst <= '1' when count_image_delay(7 downto 0)="11111111" else '0';


count_image_aux<= std_logic_vector(unsigned(count_image) + 1) when en_layer1='1' else "0000000000000";

count_image_delay_aux<=count_image when en_layer1='1'else (others => '0');

done<='1' when count_image_aux="1111111111111" else
    '0';

    
delay_aux<=count_image(8);
test<=count_image_delay(8);

n <= to_integer(unsigned(count_image(12 downto 8))) when en_layer1='1' else 31;
------------------------------Layer2-----------------------------------------



saida_w2<=weight2_4 when en_layer2='1'else (others => '0');
saida_w2_sg<=signed(saida_w2)when en_layer2='1'else (others => '0');

temp_test<=signed(registers(n2*4));
temp_test_2<=signed (saida_w2_sg(7 downto 0));
saida_multiplicacao2_sg(21 downto 0) <= signed(saida_w2_sg(7 downto 0) )* signed(registers(n2*4)) when (registers(n2*4)(13)/='1') else (others => '0');
saida_multiplicacao2_sg(43 downto 22)<=signed(saida_w2_sg(15 downto 8))*signed(registers(n2*4+1)) when (registers(n2*4+1)(13)/='1') else (others => '0');
saida_multiplicacao2_sg(65 downto 44)<=signed(saida_w2_sg(23 downto 16))*signed(registers(n2*4+2)) when (registers(n2*4+2)(13)/='1') else (others => '0');
saida_multiplicacao2_sg(87 downto 66)<=signed(saida_w2_sg(31 downto 24))*signed(registers(n2*4+3)) when (registers(n2*4+3)(13)/='1') else (others => '0');

soma12_sg<=(saida_multiplicacao2_sg(21) & saida_multiplicacao2_sg(21 downto 0))+(saida_multiplicacao2_sg(43) &saida_multiplicacao2_sg(43 downto 22));
soma22_sg<=(saida_multiplicacao2_sg(65) & saida_multiplicacao2_sg(65 downto 44))+(saida_multiplicacao2_sg(86) & saida_multiplicacao2_sg(86 downto 66));
soma32_sg <= (soma12_sg(22) & soma12_sg) + (soma22_sg(22) & soma22_sg);

accum_rst2<='1' when count_rlayer1(3 downto 0)="1001" else '0';

accumulator_aux2<=signed(accumulator2)+(soma32_sg(23)&soma32_sg(23)&soma32_sg(23)&soma32_sg)when accum_rst2='0' and en_layer2='1' else
                 (soma32_sg(23)&soma32_sg(23)&soma32_sg(23)&soma32_sg)when accum_rst2='1'else
                 "000000000000000000000000000";


delay_aux<=count_image_delay(3) when en_layer2='1';

count_rlayer1_aux<=std_logic_vector(unsigned(count_rlayer1) + 1)when en_layer2='1' or count_image_aux="1111111111111" else count_rlayer1;
n2 <= to_integer(unsigned(count_rlayer1_delay(2 downto 0)));

count_rlayer1delay_aux<=count_rlayer1 when en_layer2='1'else(others => '0');

n3<=to_integer(unsigned(count_rlayer1_delay(6 downto 3)));

done2<='1' when count_rlayer1_delay="1010001" else
    '0';
buff<='1' when count_rlayer1_delay="1010001" else
    '0';
res_reg <= "0000" when (--nao e assim que se faz quase de certeza
    buff = '1'and 
    signed(registers2(0)) > signed(registers2(1)) and 
    signed(registers2(0)) > signed(registers2(2)) and 
    signed(registers2(0)) > signed(registers2(3)) and 
    signed(registers2(0)) > signed(registers2(4)) and 
    signed(registers2(0)) > signed(registers2(5)) and 
    signed(registers2(0)) > signed(registers2(6)) and 
    signed(registers2(0)) > signed(registers2(7)) and 
    signed(registers2(0)) > signed(registers2(8)) and 
    signed(registers2(0)) > signed(registers2(9))) else
    "0001" when(
     buff = '1'and 
    signed(registers2(1)) > signed(registers2(0)) and 
    signed(registers2(1)) > signed(registers2(2)) and 
    signed(registers2(1)) > signed(registers2(3)) and 
    signed(registers2(1)) > signed(registers2(4)) and 
    signed(registers2(1)) > signed(registers2(5)) and 
    signed(registers2(1)) > signed(registers2(6)) and 
    signed(registers2(1)) > signed(registers2(7)) and 
    signed(registers2(1)) > signed(registers2(8)) and 
    signed(registers2(1)) > signed(registers2(9)))
    else
    "0010" when(
     buff = '1'and 
    signed(registers2(2)) > signed(registers2(0)) and 
    signed(registers2(2)) > signed(registers2(1)) and 
    signed(registers2(2)) > signed(registers2(3)) and 
    signed(registers2(2)) > signed(registers2(4)) and 
    signed(registers2(2)) > signed(registers2(5)) and 
    signed(registers2(2)) > signed(registers2(6)) and 
    signed(registers2(2)) > signed(registers2(7)) and 
    signed(registers2(2)) > signed(registers2(8)) and 
    signed(registers2(2)) > signed(registers2(9)))else
    "0011" when(
     buff = '1'and 
    signed(registers2(3)) > signed(registers2(0)) and 
    signed(registers2(3)) > signed(registers2(1)) and 
    signed(registers2(3)) > signed(registers2(2)) and 
    signed(registers2(3)) > signed(registers2(4)) and 
    signed(registers2(3)) > signed(registers2(5)) and 
    signed(registers2(3)) > signed(registers2(6)) and 
    signed(registers2(3)) > signed(registers2(7)) and 
    signed(registers2(3)) > signed(registers2(8)) and 
    signed(registers2(3)) > signed(registers2(9)))else
    "0100" when(
     buff = '1'and 
    signed(registers2(4)) > signed(registers2(0)) and 
    signed(registers2(4)) > signed(registers2(1)) and 
    signed(registers2(4)) > signed(registers2(2)) and 
    signed(registers2(4)) > signed(registers2(3)) and 
    signed(registers2(4)) > signed(registers2(5)) and 
    signed(registers2(4)) > signed(registers2(6)) and 
    signed(registers2(4)) > signed(registers2(7)) and 
    signed(registers2(4)) > signed(registers2(8)) and 
    signed(registers2(4)) > signed(registers2(9)))else
    "0101" when(
     buff = '1' and 
    signed(registers2(5)) > signed(registers2(0)) and 
    signed(registers2(5)) > signed(registers2(1)) and 
    signed(registers2(5)) > signed(registers2(2)) and 
    signed(registers2(5)) > signed(registers2(4)) and 
    signed(registers2(5)) > signed(registers2(3)) and 
    signed(registers2(5)) > signed(registers2(6)) and 
    signed(registers2(5)) > signed(registers2(7)) and 
    signed(registers2(5)) > signed(registers2(8)) and 
    signed(registers2(5)) > signed(registers2(9)))else
    "0110" when(
     buff = '1' and 
    signed(registers2(6)) > signed(registers2(0)) and 
    signed(registers2(6)) > signed(registers2(1)) and 
    signed(registers2(6)) > signed(registers2(2)) and 
    signed(registers2(6)) > signed(registers2(4)) and 
    signed(registers2(6)) > signed(registers2(5)) and 
    signed(registers2(6)) > signed(registers2(3)) and 
    signed(registers2(6)) > signed(registers2(7)) and 
    signed(registers2(6)) > signed(registers2(8)) and 
    signed(registers2(6)) > signed(registers2(9)))else
    "0111" when(
     buff = '1' and 
    signed(registers2(7)) > signed(registers2(0)) and 
    signed(registers2(7)) > signed(registers2(1)) and 
    signed(registers2(7)) > signed(registers2(2)) and 
    signed(registers2(7)) > signed(registers2(3)) and 
    signed(registers2(7)) > signed(registers2(4)) and 
    signed(registers2(7)) > signed(registers2(5)) and 
    signed(registers2(7)) > signed(registers2(6)) and 
    signed(registers2(7)) > signed(registers2(8)) and 
    signed(registers2(7)) > signed(registers2(9)))else
    "1000" when(
     buff = '1' and 
    signed(registers2(8)) > signed(registers2(0)) and 
    signed(registers2(8)) > signed(registers2(1)) and 
    signed(registers2(8)) > signed(registers2(2)) and 
    signed(registers2(8)) > signed(registers2(3)) and 
    signed(registers2(8)) > signed(registers2(4)) and 
    signed(registers2(8)) > signed(registers2(5)) and 
    signed(registers2(8)) > signed(registers2(6)) and 
    signed(registers2(8)) > signed(registers2(7)) and 
    signed(registers2(8)) > signed(registers2(9)))else
    "1001" when(
     buff = '1' and 
    signed(registers2(9)) > signed(registers2(0)) and 
    signed(registers2(9)) > signed(registers2(1)) and 
    signed(registers2(9)) > signed(registers2(2)) and 
    signed(registers2(9)) > signed(registers2(3)) and 
    signed(registers2(9)) > signed(registers2(4)) and 
    signed(registers2(9)) > signed(registers2(5)) and 
    signed(registers2(9)) > signed(registers2(6)) and 
    signed(registers2(9)) > signed(registers2(7)) and 
    signed(registers2(9)) > signed(registers2(8)))else (others => '1');--(fazer pa todos)
   
n4 <= to_integer(unsigned(res_reg));

process(clk)
begin
    if rising_edge(clk) then
        if rst_accum = '1' then
            count_image <= (others => '0');
            count_rlayer1<= (others => '0');
            count_image_delay<=("0000000000000");
        else
            count_image_delay<=count_image_delay_aux;
            count_image<=count_image_aux;
            accumulator<=std_logic_vector(accumulator_aux);
            accumulator2<=std_logic_vector(accumulator_aux2);
            
--            delay_256<=test;
            
            registers(n)<=std_logic_vector(accumulator_aux);--quando guardar enable needed
            count_rlayer1<=count_rlayer1_aux;
            count_rlayer1_delay<=count_rlayer1delay_aux;
            registers2(n3)<=std_logic_vector(accumulator_aux2); 
            if buff='1' then
                resultado<=res_reg;
                resultado_vl<=registers2(n4);
            end if;
        end if;
    end if;
end process;


end Behavioral;
