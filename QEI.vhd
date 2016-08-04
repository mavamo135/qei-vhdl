----------------------------------------------------------------------------------------------------
--By Ing. Maximiliano Valencia Moctezuma 		 Date:06/09/2012
--E-Mail: mavamo135@gmail.com			     Rev 1.0		
--Description: Enhanced QEI
--
----------------------------------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity QEI is	       --Entity QEI
	generic (
		N    :integer:= 32;		   -- Number of bits of the Encoder Unit
		Fdn  :integer:= 32;		   -- Fixed Point Format of the Input Signal - D(k))
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
	port ( 
		CLK	: 	in std_logic:='U';	       --Clock
		ARST: 	in std_logic:='U';	       --Asynchronous reset='1'
		CHA :	in std_logic:='U';	       --Encoder channel A 
		CHB	: 	in std_logic:='U';	    --Encoder channel B
		CHI	: 	in std_logic:='U';	    --Encoder channel I 
		DS	:	in std_logic:='U';	       --Decoding Selection 1X or 4X 
		Ts  :   in std_logic:='U';	       --Sampling period
		FA,FB,FI,FD: in std_logic:='U';   --Failure detection 
		Fault:    out std_logic:='U';	    --Failure alarm
		Ready:    out std_logic:='U';     --Data Ready
		Status:   out std_logic_vector(3 downto 0):=(others=>'0'); --Status of the encoder signals
		Velocity: out signed(Fyn-1 downto 0):=(others=>'0');	     --Velocity in counts/sec 
		Position: out signed(N-1 downto 0)  :=(others=>'0')	     --Number of counts/rev 
		);
end QEI;
----------------------------------------------------------------------------------------------------	
architecture RTL_QEI_V1 of QEI is 
	constant K1: signed(Fk1n-1 downto 0):="000101000000010011"; --000101000000010011
	constant K2: signed(Fk2n-1 downto 0):="000101011100000000";	--000101011100000000
	signal CHAs,CHBs,CHIs: std_logic:='0';
	signal Faults,UpDown_1X,UpDown_4X,Count_1X,Count_4X,Counts,UpDowns:std_logic:='0'; 	
	signal Count_1Xs,UpDown_1Xs:std_logic:='0';
	signal Counters:signed(N-1 downto 0):=(others=>'0');
	signal Positions: std_logic_vector(N-1 downto 0):=(others=>'0'); 
	signal FaultReg: std_logic_vector(Status'length-1 downto 0):=(others=>'0');

begin
	
	Faults<= FA or FB or FI or FD;			-- General Fault 
	Fault<=Faults; 							 
	FaultReg<=FD&FI&FB&FA;					-- Code for Faults inputs
	
	S1: entity work.RegisterLD                generic map(Status'length) port map(CLK,ARST,Faults,FaultReg,Status);	  -- Fault alarm's register 
	-- Digital Filters 
	F1: entity work.Digital_Filter(RTL_DF_V1) port map(CLK,ARST,CHA,CHAs);
	F2: entity work.Digital_Filter(RTL_DF_V1) port map(CLK,ARST,CHB,CHBs);
	F3: entity work.Digital_Filter(RTL_DF_V1) port map(CLK,ARST,CHI,CHIs);
	-- Quadrature Decoder Unit for 1X y 4X
	U1: entity work.QuadratureDecoder_1X(Behavior_QuadratureDecoder_1X_V1) port map(CLK,ARST,CHAs,CHBs,Count_1X,UpDown_1X);
	U2: entity work.Rising_Edge_Detector      port map(CLK,ARST,Count_1X,Count_1Xs);
	U3: entity work.Rising_Edge_Detector      port map(CLK,ARST,UpDown_1X,UpDown_1Xs);
	U4: entity work.QuadratureDecoder_4X(RTL_QuadratureDecoder_4X_V3)      port map(CLK,ARST,CHAs,CHBs,Count_4X,UpDown_4X);			
	U5: entity work.MUX2_1                    port map(UpDown_1Xs,not UpDown_4X,DS,UpDowns);
	U6: entity work.MUX2_1                    port map(Count_1Xs,Count_4X,DS,Counts);
	-- Counter 	
	U7: entity work.UpDown_Counter            generic map(N) port map(CLK,ARST,UpDowns,Counts,Counters);
	U8: entity work.RegisterLD                generic map(N) port map(CLK,ARST,Ts,std_logic_vector(Counters),Positions);	
	
	Position<=signed(Positions);
	
	U9: entity work.Derivative_LPF generic map(Fdn,Fdf,Fk1n,Fk1f,Fk2n,Fk2f,Fwn,Fwf,Fyn,Fyf) port map(CLK,ARST,Ts,K1,K2,Counters,Ready,Velocity);
	
end RTL_QEI_V1; 
----------------------------------------------------------------------------------------------------
configuration QEI_CFG of QEI is
	for RTL_QEI_V1
	end for;
end QEI_CFG; 