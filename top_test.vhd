LIBRARY ieee;
USE ieee.std_logic_1164.all;


entity top is
port
(
		ADC_CLK_10 			: in std_logic;
		MAX10_CLK1_50		: in std_logic;
		MAX10_CLK2_50		: in std_logic;


		KEY		: in std_logic_vector(1 downto 0);
		SW		: in std_logic_vector(9 downto 0);

		LEDR		: out std_logic_vector(9 downto 0);

		HEX0		: out std_logic_vector(7 downto 0);
		HEX1		: out std_logic_vector(7 downto 0);
		HEX2		: out std_logic_vector(7 downto 0);
		HEX3		: out std_logic_vector(7 downto 0);
		HEX4		: out std_logic_vector(7 downto 0);
		HEX5		: out std_logic_vector(7 downto 0);

		DRAM_CLK		: out std_logic;
		DRAM_CKE		: out std_logic;
		DRAM_ADDR		: out std_logic_vector(12 downto 0);
		DRAM_BA		: out std_logic_vector(1 downto 0);
		DRAM_DQ		: inout std_logic_vector(15 downto 0);
		DRAM_LDQM		: out std_logic;
		DRAM_UDQM		: out std_logic;
		DRAM_CS_N		: out std_logic;
		DRAM_WE_N		: out std_logic;
		DRAM_CAS_N		: out std_logic;
		DRAM_RAS_N		: out std_logic;


 		VGA_HS		: out std_logic;
		VGA_VS		: out std_logic;
		VGA_R		: out std_logic_vector(3 downto 0);
		VGA_G		: out std_logic_vector(3 downto 0);
		VGA_B		: out std_logic_vector(3 downto 0);


 		CLK_I2C_SCL		: out std_logic;
 		CLK_I2C_SDA		: inout std_logic;

 		GSENSOR_SCLK		: out std_logic;
 		GSENSOR_SDO		: inout std_logic;
 		GSENSOR_SDI		: inout std_logic;
 		GSENSOR_INT		: inout std_logic_vector(3 downto 0);
 		GSENSOR_CS_N		: out std_logic;



 		GPIO		: inout std_logic_vector(35 downto 0);
 		ARDUINO_IO		: inout std_logic_vector(15 downto 0);
 		ARDUINO_RESET_N		: inout std_logic
);
end top;

ARCHITECTURE behavior OF top IS

	component DE10_Lite is
	port
	(

			ADC_CLK_10 			: in std_logic;
			MAX10_CLK1_50		: in std_logic;
			MAX10_CLK2_50		: in std_logic;


			KEY		: in std_logic_vector(1 downto 0);
			SW		: in std_logic_vector(9 downto 0);

			LEDR		: out std_logic_vector(9 downto 0);

			HEX0		: out std_logic_vector(7 downto 0);
			HEX1		: out std_logic_vector(7 downto 0);
			HEX2		: out std_logic_vector(7 downto 0);
			HEX3		: out std_logic_vector(7 downto 0);
			HEX4		: out std_logic_vector(7 downto 0);
			HEX5		: out std_logic_vector(7 downto 0);

			DRAM_CLK		: out std_logic;
			DRAM_CKE		: out std_logic;
			DRAM_ADDR		: out std_logic_vector(12 downto 0);
			DRAM_BA		: out std_logic_vector(1 downto 0);
			DRAM_DQ		: inout std_logic_vector(15 downto 0);
			DRAM_LDQM		: out std_logic;
			DRAM_UDQM		: out std_logic;
			DRAM_CS_N		: out std_logic;
			DRAM_WE_N		: out std_logic;
			DRAM_CAS_N		: out std_logic;
			DRAM_RAS_N		: out std_logic;


			VGA_HS		: out std_logic;
			VGA_VS		: out std_logic;
			VGA_R		: out std_logic_vector(3 downto 0);
			VGA_G		: out std_logic_vector(3 downto 0);
			VGA_B		: out std_logic_vector(3 downto 0);


			CLK_I2C_SCL		: out std_logic;
			CLK_I2C_SDA		: inout std_logic;

			GSENSOR_SCLK		: out std_logic;
			GSENSOR_SDO		: inout std_logic;
			GSENSOR_SDI		: inout std_logic;
			GSENSOR_INT		: inout std_logic_vector(3 downto 0);
			GSENSOR_CS_N		: out std_logic;



			GPIO		: inout std_logic_vector(35 downto 0);
			ARDUINO_IO		: inout std_logic_vector(15 downto 0);
			ARDUINO_RESET_N		: inout std_logic
	);
end component;


	component pmod_dac2 is
	generic(
		  clk_freq    : INTEGER := 50;  --system clock frequency in MHz
		  spi_clk_div : INTEGER := 1);  --spi_clk_div = clk_freq/60 (answer rounded up));
	
	
	port
	(
		  clk        : IN      STD_LOGIC;                      --system clock
		  reset_n    : IN      STD_LOGIC;                      --active low asynchronous reset
		  dac_tx_ena : IN      STD_LOGIC;                      --enable transaction with DACs
		  dac_data_a : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC A
		  dac_data_b : IN      STD_LOGIC_VECTOR(11 DOWNTO 0);  --data value to send to DAC B
		  busy       : OUT     STD_LOGIC;                      --indicates when transactions with DACs can be initiated
		  mosi_a     : OUT     STD_LOGIC;                      --SPI bus to DAC A: master out, slave in (DIN A)
		  mosi_b     : OUT     STD_LOGIC;                      --SPI bus to DAC B: master out, slave in (DIN B)
		  sclk       : BUFFER  STD_LOGIC;                      --SPI bus to DAC: serial clock (SCLK)
		  ss_n       : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0))  --SPI bus to DAC: slave select (~SYNC)
	);
	end component pmod_dac2 ;


begin



	DE10_Lite_inst: DE10_Lite 
	port map
	(

			ADC_CLK_10 			=>ADC_CLK_10,
			MAX10_CLK1_50 		=>MAX10_CLK1_50,
			MAX10_CLK2_50		=>MAX10_CLK2_50,


			KEY		=>KEY,
			SW		=>SW,

			LEDR		=>LEDR,

			HEX0		=>HEX0,
			HEX1		=>HEX1,
			HEX2		=>HEX2,
			HEX3		=>HEX3,
			HEX4		=>HEX4,
			HEX5		=>HEX5,

			DRAM_CLK		=>DRAM_CLK,
			DRAM_CKE		=>DRAM_CKE,
			DRAM_ADDR		=>DRAM_ADDR,
			DRAM_BA		=>DRAM_BA,
			DRAM_DQ		=>DRAM_DQ,
			DRAM_LDQM		=>DRAM_LDQM,
			DRAM_UDQM		=>DRAM_UDQM,
			DRAM_CS_N		=>DRAM_CS_N,
			DRAM_WE_N		=>DRAM_WE_N,
			DRAM_CAS_N		=>DRAM_CAS_N,
			DRAM_RAS_N		=>DRAM_RAS_N,


			VGA_HS		=>VGA_HS,
			VGA_VS		=>VGA_VS,
			VGA_R		=>VGA_R,
			VGA_G		=>VGA_G,
			VGA_B		=>VGA_B,


			CLK_I2C_SCL		=>CLK_I2C_SCL,
			CLK_I2C_SDA		=>CLK_I2C_SDA,

			GSENSOR_SCLK	=>GSENSOR_SCLK,
			GSENSOR_SDO		=>GSENSOR_SDO,
			GSENSOR_SDI		=>GSENSOR_SDI,
			GSENSOR_INT		=>GSENSOR_INT,
			GSENSOR_CS_N	=>GSENSOR_CS_N,



			GPIO		=>GPIO,
			ARDUINO_IO		=>ARDUINO_IO,
			ARDUINO_RESET_N		=>ARDUINO_RESET_N
	);

end behavior;

	pmod_dac2_inst : pmod_dac2
	port map
	(
		  clk        => clk,                      --system clock
		  reset_n    => ResetN,                      --active low asynchronous reset
		  dac_tx_ena => '1',                      --enable transaction with DACs
		  dac_data_a => DacDataIn,  --data value to send to DAC A
		  dac_data_b => DacDataIn,  --data value to send to DAC B
		  busy       => DacBusy,                      --indicates when transactions with DACs can be initiated
		  mosi_a     => dac_mosi_a,                      --SPI bus to DAC A: master out, slave in (DIN A)
		  mosi_b     => dac_mosi_b,                      --SPI bus to DAC B: master out, slave in (DIN B)
		  sclk       => dac_sclk,                      --SPI bus to DAC: serial clock (SCLK)
		  ss_n       => dac_cs  --SPI bus to DAC: slave select (~SYNC)	
	);
