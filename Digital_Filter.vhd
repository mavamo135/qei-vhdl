----------------------------------------------------------------------------------------------------
--By Ing. Maximiliano Valencia Moctezuma 		 Date:25/05/2011
--E-Mail: mavamo135@gmail.com			     Rev 1.0		
--Description:
--A simplified Digital Noise Filter Logic. taken from Agilent-HCTL-2032-Quadrature Decoder/Counter
--Note:The filter generates a delay of 4 clock cycles, this increases the latency. 
----------------------------------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;

entity Digital_Filter is			  --Simplified Digital Noise Filter Logic
	port ( 
		CLK	: 	in std_logic:='U';	  --Clock
		ARST:   in std_logic:='U';    --Asynchronous reset='1'
		DIN :	in std_logic:='U';	  --Data In
		DOUT:	out std_logic		  --Data Filtered
		);
end Digital_Filter;
----------------------------------------------------------------------------------------------------
architecture Behavior_DF_V1 of Digital_Filter is
	
	signal      Data_Shift_Reg: std_logic_vector(3 downto 0):=(others=>'0');
	signal      FF_J: std_logic:='0';
	signal      FF_K: std_logic:='0';	 
	signal      Data_Filtered: std_logic:='0';
	
begin
	DOUT<= Data_Filtered;
	
	--Inputs for the JK-Flip Flop
	FF_J  <= Data_Shift_Reg(3) and Data_Shift_Reg(2) and Data_Shift_Reg(1);	  
	FF_K  <= not( Data_Shift_Reg(3) or Data_Shift_Reg(2) or Data_Shift_Reg(1) );
	
	Filter: process(CLK,ARST,DIN) begin
		if  ARST= '1' then
			Data_Shift_Reg  <= "0000";	 
			Data_Filtered   <='0';
		elsif rising_edge(CLK) then
			
			Data_Shift_Reg <= (Data_Shift_Reg(2) & Data_Shift_Reg(1) & Data_Shift_Reg(0) & DIN);   --Sample input and place in a shift register
			
			-- JK-Flip Flop 
			if FF_J = '1' and FF_K='0' then
				Data_Filtered <= '1';
			elsif FF_J = '0' and FF_K = '1' then
				Data_Filtered <= '0';
			end if;
		end if;
	end process Filter;
	
end Behavior_DF_V1;
----------------------------------------------------------------------------------------------------
architecture Behavior_DF_V2 of Digital_Filter is
	signal Temp: std_logic;     	
begin				 
	
	DOUT <= Temp;  
	
	process(CLK, ARST)
		variable Filter: std_logic_vector(0 to 3);
	begin
		if ARST = '1' then
			Filter := "0000";
			Temp <= '0';
		elsif rising_edge(CLK) then
			Filter(1 to 3) := Filter(0 to 2);
			Filter(0) := DIN;
			if Filter(1 to 3) = "000" then
				Temp <= '0';
			end if;
			if  Filter(1 to 3) = "111" then
				Temp <= '1';
			end if;
		end if;
	end process;
	
end Behavior_DF_V2;
---------------------------------------------------------------------------------------------------- 
architecture RTL_DF_V1 of Digital_Filter is
	
	signal DOUT1,DOUT2,DOUT3,DOUT4: std_logic:='0';
	signal JS,KS:std_logic:='0';
	
begin
	
	FFD1: entity work.FF_D_V1 port map(CLK,ARST,DIN,DOUT1);
	FFD2: entity work.FF_D_V1 port map(CLK,ARST,DOUT1,DOUT2);
	FFD3: entity work.FF_D_V1 port map(CLK,ARST,DOUT2,DOUT3); 
	FFD4: entity work.FF_D_V1 port map(CLK,ARST,DOUT3,DOUT4);
	FFJK1:entity work.FF_JK   port map(CLK,ARST,JS,KS,DOUT);
	
	JS<= DOUT2 and DOUT3 and DOUT4;
	KS<= (not(DOUT2)) and (not(DOUT3)) and (not(DOUT4));
	
	
end RTL_DF_V1;	 
---------------------------------------------------------------------------------------------------- 
configuration Digital_Filter_CFG of Digital_Filter is
	for  RTL_DF_V1
	--for  Behavior_DF_V2
	end for;
end Digital_Filter_CFG;
---------------------------------------------------------------------------------------------------- 