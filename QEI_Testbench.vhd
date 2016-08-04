library	IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Test_QEI is
	generic (
		N    :integer:= 32;		   -- Number of bits of the Encoder Unit
		Fdn  :integer:= N;		   -- Fixed Point Format of the Input Signal - D(k))
		Fdf  :integer:= 0; 
		Fk1n :integer:= 18;        -- Fixed Point Format of the Constant K1 
		Fk1f :integer:= 5;		   -- Recommended to be multiples of 9 for full use of multipliers
		Fk2n :integer:= 18;        -- Fixed Point Format of the Constant K2 
		Fk2f :integer:= 15;		   -- Recommended to be multiples of 9 for full use of multipliers
		Fwn  :integer:= 32;		   -- Fixed Point Format of the Output Signal - W(k)
		Fwf  :integer:= 5;
		Fyn  :integer:= 27;		   -- Fixed Point Format of the Output Signal  - Y(k)
		Fyf  :integer:= 0	
		);
end Test_QEI;

architecture Testbench_QEI of Test_QEI is
	
	signal RST,CLK  	: std_logic:='0';
	signal CHA,CHB      : std_logic:='0';
	signal Fault,DS,Ts  : std_logic; 
	signal Status		: std_logic_vector(3 downto 0);
	signal Count        : signed(N-1 downto 0):=(others=>'0'); 
	signal Ready        :std_logic:='U';    --Data Ready
	signal Velocity     :signed(Fyn-1 downto 0):=(others=>'0');	 --Velocity in counts/sec 
	signal Position     :signed(N-1 downto 0):=(others=>'0');	 --Number of counts/rev 
		
	shared variable EndSim        :boolean := false;
	shared variable EncoderEnable :boolean := false;
	shared variable CLK_Period    :time := 20 ns;
	shared variable Period_Encoder:time := 250 us;
		
begin
	DS<='1';
	QEI_1: entity work.QEI generic map(N,Fdn,Fdf,Fk1n,Fk1f,Fk2n,Fk2f,Fwn,Fwf,Fyn,Fyf) port map(CLK,RST,CHA,CHB,'0',DS,Ts,'0','0','0','0',Fault,Ready,Status,Velocity,Position);
	
	Tsamplig: process
	begin
		Ts <= '0';
		wait for 1ms;
		wait for CLK_Period;
		Ts <= '1';
		wait for CLK_Period;
	end process Tsamplig;	
	
	Clock: process
	begin	   
		if EndSim= false then
			CLK <= '0';
			wait for CLK_Period/2;
			CLK <= '1';
			wait for CLK_Period/2;
		else
			CLK<='0';
			wait;
		end if;
	end process Clock;
	
	Reset: process
	begin  
		if EndSim= false then
			RST <= '1';
			wait for 50ns;
			RST <= '0';	
			wait for 500ns;
			EncoderEnable:=true;
			wait; 
		else
			RST<='0';
			wait;
		end if;
	end process Reset;
	
	Encoder: process		 --Generar Señales de encoder
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
			std.env.stop;
		else
			CHA <= '0';
			CHB <= '0';
			wait for 1 us;
		end if;
	end process;
		
end Testbench_QEI;