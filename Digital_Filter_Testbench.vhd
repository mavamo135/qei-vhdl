library	IEEE;
use IEEE.std_logic_1164.all;

entity Test_Digital_Filter is
end Test_Digital_Filter;

architecture Testbench_DF of Test_Digital_Filter is
	
	signal ARST,CLK  	      : std_logic:='0';
	signal CHA,CHA_Filtered   : std_logic:='0';
	
	shared variable EncoderEnable :boolean := false;
	shared variable CLK_Period    :time := 20 ns;
	shared variable Period_Encoder:time := 300 ns; 
	
begin
	
	DF_1: entity Digital_Filter(RTL_DF_V1) port map(CLK,ARST,CHA,CHA_Filtered);
	
	Clock: process
	begin	   
		CLK <= '0';
		wait for CLK_Period/2;
		CLK <= '1';
		wait for CLK_Period/2;
	end process Clock;
	
	Reset: process
	begin  
		ARST <= '1';
		wait for 60ns;
		ARST <= '0';	
		EncoderEnable:=true;
		wait; 
	end process Reset;
	
	Encoder: process		
	begin
		if EncoderEnable= true then
			wait for CLK_Period;
			CHA <= '0';
			wait for Period_Encoder; 
			CHA <= '1'; wait for 10 ns; CHA <= '0'; wait for 10 ns;--Glitch  
			CHA <= '1'; wait for 30 ns; CHA <= '0'; wait for 30 ns;--Glitch
			CHA <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			wait for Period_Encoder; --1 cycle CW
			CHA <= '0';
			wait for Period_Encoder;
			CHA <= '1'; wait for 20 ns; CHA <= '0'; wait for 20 ns; --Glitch  
			CHA <= '1'; wait for 30 ns; CHA <= '0'; wait for 30 ns; --Glitch
			CHA <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			wait for Period_Encoder;
			CHA <= '1'; wait for 50 ns; CHA <= '0'; wait for 20 ns; --Glitch  
			CHA <= '1';
			wait for Period_Encoder;
			CHA <= '0';	
			wait for Period_Encoder;
			std.env.stop;
		else
			CHA <= '0';	
			wait for 100 ns;
		end if;
	end process;
	
	
end Testbench_DF;