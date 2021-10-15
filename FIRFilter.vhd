library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity FIRFilter is
	port(
	clk         : in  std_logic; --clock
	rst         : in  std_logic; --reset
	switch1     : in  std_logic; --the first working mode switch
	switch2     : in  std_logic; --the second working mode switch
	input_data  : in  std_logic_vector (11 downto 0);
	output_data : out std_logic_vector (11 downto 0)
	);
end FIRFilter;

architecture one of FIRFilter is
	constant m  : integer := 12;                                            --The order 
	type   data_array   is array (0 to m) of signed (11 downto 0);          --custom calculation array type
	signal sto_data  : data_array := (others=>(others=>'0'));               --storage data array
   signal tap_coeff : data_array := (0=>"000000001111",1=>"000000011101",  --tap coeffecient array
											    2=>"000000110010",3=>"000001001001",
											    4=>"000001011110",5=>"000001101101",
											    6=>"000001110010",7=>"000001101101",
											    8=>"000001011110",9=>"000001001001",
												 10=>"000000110010",11=>"000000011101",
												 12=>"000000001111");
	signal multi     : data_array := (others=>(others=>'0'));               --multiplication data array
	signal sw   : std_logic_vector (1 downto 0) := (others=>'0');
begin
   FIR_input : process (clk,rst,input_data)                                --store input data
	begin
		if rst='1' then
			sto_data <= (others=>(others=>'0'));
		elsif rising_edge(clk) then	
			sto_data <= signed(input_data) & sto_data(0 to sto_data'length-2);
		end if;
	end process FIR_input;
	
	FIR_multi : process (clk,switch1,switch2)                               --multiply stored data and tap coefficient
	begin
		sw <= switch2 & switch1;
		case sw is
			when "01"   => tap_coeff <= (0=>"000011010011",1=>"111110001110", --High pass mode
											     2=>"111110001101",3=>"111110000010",
											     4=>"111101110101",5=>"111101101010",
											     6=>"001101100110",7=>"111101101010",
											     8=>"111101110101",9=>"111110000010",
												  10=>"111110001101",11=>"111110001110",
												  12=>"000011010011");
			when "10"   => tap_coeff <= (0=>"000000011100",1=>"000000101000", --Band pass mode
												  2=>"111111100100",3=>"111110000000",
											     4=>"111110100000",5=>"000001010010",
											     6=>"000010111111",7=>"000001010010",
											     8=>"111110100000",9=>"111110000000",
												  10=>"111111100100",11=>"000000101000",
												  12=>"000000011100");
			when "11"   => tap_coeff <= (0=>"000001011100",1=>"111110001110", --Band stop mode
											     2=>"000010001000",3=>"000010110111",
											     4=>"000000011011",5=>"111100100100",
											     6=>"001010101011",7=>"111100100100",
											     8=>"000000011011",9=>"000010110111",
												  10=>"000010001000",11=>"111110001110",
												  12=>"000001011100");
			when others => tap_coeff <= (0=>"000000001111",1=>"000000011101", --Low pass mode
											     2=>"000000110010",3=>"000001001001",
											     4=>"000001011110",5=>"000001101101",
											     6=>"000001110010",7=>"000001101101",
											     8=>"000001011110",9=>"000001001001",
												  10=>"000000110010",11=>"000000011101",
												  12=>"000000001111");
		end case;		
		if rising_edge(clk) then	
			multi(0)  <= resize(sto_data(0)  * tap_coeff(0)  / 1024,12);
			multi(1)  <= resize(sto_data(1)  * tap_coeff(1)  / 1024,12);
			multi(2)  <= resize(sto_data(2)  * tap_coeff(2)  / 1024,12);
			multi(3)  <= resize(sto_data(3)  * tap_coeff(3)  / 1024,12);
			multi(4)  <= resize(sto_data(4)  * tap_coeff(4)  / 1024,12);
			multi(5)  <= resize(sto_data(5)  * tap_coeff(5)  / 1024,12);
			multi(6)  <= resize(sto_data(6)  * tap_coeff(6)  / 1024,12);
			multi(7)  <= resize(sto_data(7)  * tap_coeff(7)  / 1024,12);
			multi(8)  <= resize(sto_data(8)  * tap_coeff(8)  / 1024,12);
			multi(9)  <= resize(sto_data(9)  * tap_coeff(9)  / 1024,12);
			multi(10) <= resize(sto_data(10) * tap_coeff(10) / 1024,12);
			multi(11) <= resize(sto_data(11) * tap_coeff(11) / 1024,12);
			multi(12) <= resize(sto_data(12) * tap_coeff(12) / 1024,12);
		end if;
	end process FIR_multi;
	
	FIR_add : process (clk,rst)                                             --add them together
	begin
		if rst='1' then
			output_data <= (others=>'0');
		elsif rising_edge(clk) then
			output_data <= std_logic_vector(multi(0)+multi(1)+multi(2)+multi(3)+multi(4)+multi(5)+multi(6)
													  +multi(7)+multi(8)+multi(9)+multi(10)+multi(11)+multi(12));
		end if;
	end process FIR_add;

end architecture one;
