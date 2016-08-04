library	IEEE;
use IEEE.std_logic_1164.all;

entity QuadratureDecoder_1X_Testbench is
end QuadratureDecoder_1X_Testbench;

architecture Testbench_QuadratureDecoder of QuadratureDecoder_1X_Testbench is
	
	signal RST,CLK  	: std_logic:='0';
	signal CHA,CHB      : std_logic:='0';
	signal UpDown,Count : std_logic:='0'; 
	
	shared variable EncoderEnable :boolean := false;
	shared variable CLK_Period    :time := 20 ns;
	shared variable Period_Encoder:time := 0.5 us; 
	
begin
	
	QEI_1: entity  QuadratureDecoder_1X(Behavior_QuadratureDecoder_1X_V1) port map(CLK,RST,CHA,CHB,Count,UpDown);       	
	--QEI_1: entity  QuadratureDecoder_1X(RTL_QuadratureDecoder_1X_V1) port map(CLK,RST,CHA,CHB,Count,UpDown);    	
	--QEI_1: entity  QuadratureDecoder_1X(RTL_QuadratureDecoder_1X_V2) port map(CLK,RST,CHA,CHB,Count,UpDown);    	
	--QEI_1: entity  QuadratureDecoder_1X(RTL_QuadratureDecoder_1X_V3) port map(CLK,RST,CHA,CHB,Count,UpDown);    	
	--QEI_1: entity  QuadratureDecoder_1X(RTL_QuadratureDecoder_1X_V4) port map(CLK,RST,CHA,CHB,Count,UpDown);    	
	
	Clock: process
	begin	   
		CLK <= '0';
		wait for CLK_Period/2;
		CLK <= '1';
		wait for CLK_Period/2;
	end process Clock;
	
	Reset: process
	begin  
		RST <= '1';
		wait for 50ns;
		RST <= '0';	
		wait for 500ns;
		EncoderEnable:=true;
		wait; 
	end process Reset;
	
	Encoder: process		 --Quadrature signal generation
	begin
		if EncoderEnable= true then
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder; --1 cycle CW
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';	
			wait for Period_Encoder; --CCW
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder; --2 cycle CW
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';	  
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';	  
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';	 
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '1';
			wait for Period_Encoder;
			CHA <= '1';
			CHB <= '0';
			wait for Period_Encoder;
			CHA <= '0';
			CHB <= '0';	 
			wait for Period_Encoder;
			--std.env.finish(0);	
			std.env.stop;
		else
			CHA <= '0';
			CHB <= '0';
			wait for 1 us;
		end if;
	end process;
	
	
end Testbench_QuadratureDecoder;
