----------------------------------------------------------------------------------------------------
--By Ing. Maximiliano Valencia Moctezuma 		 Date:17/08/2011
--E-Mail: mavamo135@gmail.com			     Rev 1.0		
--Description:
--Unit for decoding an incremental encoder with a native resolution 1X
----------------------------------------------------------------------------------------------------
library ieee ;
use ieee.std_logic_1164.all;

entity QuadratureDecoder_1X is	       --Entity incremental quadrature decoder(1X)
	port ( 
		CLK	: 	in std_logic:='U';	   --Clock
		ARST: 	in std_logic:='U';	   --Asynchronous reset='1'
		CHA :	in std_logic:='U';	   --Encoder channel A 
		CHB	: 	in std_logic:='U';	   --Encoder channel B
		Count : 	out std_logic:='0';	   --Number of counts 
		UpDown: 	out std_logic:='0'	   --Direction
		);
end QuadratureDecoder_1X;
----------------------------------------------------------------------------------------------------	
architecture RTL_QuadratureDecoder_1X_V1 of QuadratureDecoder_1X is
	signal UpDownSig: std_logic:='0'; 
begin 
	
	U1: entity work.FF_D_V1 port map(CHA,ARST,CHB,UpDownSig);			
	
	Count<= ((not UpDownSig) and (not CHA) and CHB) or (UpDownSig and CHA and (not CHB));
	UpDown<= UpDownSig;		
	
end RTL_QuadratureDecoder_1X_V1; 
----------------------------------------------------------------------------------------------------
architecture RTL_QuadratureDecoder_1X_V2 of QuadratureDecoder_1X is
	signal UpDownSig: std_logic:='0';
	signal CHA_D1,CHB_D1:std_logic:='0';
	signal CHA_D2,CHB_D2:std_logic:='0';
	signal S1,S2,S3,S4:std_logic:='0';
begin 
	
	Count<= ((not UpDownSig) and (not CHA_D2) and CHB_D2) or (UpDownSig and CHA_D2 and (not CHB_D2));
	UpDown<= UpDownSig;		
	
	S1<= CHA_D1 xor CHB;
	S2<= CHB_D1 xor CHA;
	S3<= (not S1) nor S2;
	S4<= (not S2) nor S1;
	
	U1: entity work.FF_D_V1 port map(CLK,ARST,CHA,CHA_D1);			
	U2: entity work.FF_D_V1 port map(CLK,ARST,CHB,CHB_D1);
	U3: entity work.FF_D_V1 port map(CLK,ARST,CHA_D1,CHA_D2);			
	U4: entity work.FF_D_V1 port map(CLK,ARST,CHB_D1,CHB_D2);
	U5: entity work.FF_JK   port map(CLK,ARST,S3,S4,UpDownSig);
	
end RTL_QuadratureDecoder_1X_V2; 
---------------------------------------------------------------------------------------------------- 
architecture RTL_QuadratureDecoder_1X_V3 of QuadratureDecoder_1X is
	signal UpDownSig: std_logic:='0';
	signal CW,CCW: std_logic:='0';
begin 
	
	U1: entity work.FF_D_V1 port map(CHA,not(CHB),CHB,CW);			
	U2: entity work.FF_D_V1 port map(CHB,not(CHA),CHA,CCW);
	U3: entity work.FF_D_V1 port map(CHA,ARST,CHB,UpDownSig); 
	
	Count<= CW xor CCW;
	UpDown<= UpDownSig;		
	
end RTL_QuadratureDecoder_1X_V3; 
----------------------------------------------------------------------------------------------------
architecture RTL_QuadratureDecoder_1X_V4 of QuadratureDecoder_1X is
	signal UpDownSig: std_logic:='0';
	signal CHA_D1,CHB_D1:std_logic:='0';
	signal S1,S2,S3,S4,S5,S6:std_logic:='0';
begin 
	
	U1: entity work.FF_D_V1 port map(CLK,ARST,CHA,CHA_D1);			
	U2: entity work.FF_D_V1 port map(CLK,ARST,CHB,CHB_D1);
	
	S1<= not((not(CHA))and(not(CHB))and(CHA_D1));
	S2<= not((CHA)and(not(CHA_D1))and(CHB));
	S3<= not((not(CHB))and(not(CHA_D1))and(CHA));
	S4<= not(not(CHA)and((CHA_D1))and(CHB));
	
	S5<= ((S1)and(S2)and(not(S6)));
	S6<= ((S3)and(S4)and(not(S5)));		
	UpDownSig<=(not S5);		  
	
	Count<= ((not UpDownSig) and (not CHA_D1) and CHB_D1) or (UpDownSig and CHA_D1 and (not CHB_D1));
	UpDown<= UpDownSig;	
	
end RTL_QuadratureDecoder_1X_V4; 
----------------------------------------------------------------------------------------------------
architecture Behavior_QuadratureDecoder_1X_V1 of QuadratureDecoder_1X is
	signal Qp,Qn: std_logic_vector(1 downto 0):=(others=>'0');  
	signal CHA_D1,CHB_D1:std_logic:='0';
	signal UpDownSig: std_logic:='0';
begin
	
	U1: entity work.FF_D_V1 port map(CLK,ARST,CHA,CHA_D1);			
	U2: entity work.FF_D_V1 port map(CLK,ARST,CHB,CHB_D1);
	
	Count<=((not UpDownSig) and (not CHA_D1) and CHB_D1) or (UpDownSig and CHA_D1 and (not CHB_D1)) ;
	UpDown<=UpDownSig;
	
	Direction: process(CHA,CHB,Qp)
	begin
		case Qp is
			when "00"=>
				if CHA='1' and CHB='1' then
					Qn<="01";
					UpDownSig<='0';
				elsif CHA='0' and CHB='0' then
					Qn<="11";
					UpDownSig<='1';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when "01"=>
				if  CHA='0' and CHB='1' then
					Qn<="10";
					UpDownSig<='0';
				elsif CHA='1' and CHB='0' then
					Qn<="00";
					UpDownSig<='1';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when "10" =>
				if CHA='0' and CHB='0' then 
					Qn<="11";
					UpDownSig<='0';
				elsif CHA='1' and CHB='1' then
					Qn<="01";
					UpDownSig<='1';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when "11" =>
				if CHA='1' and CHB='0' then 
					Qn<="00";
					UpDownSig<='0';
				elsif CHA='0' and CHB='1'  then
					Qn<="10";
					UpDownSig<='1';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when others =>
				Qn<="00";
			UpDownSig<='0';
		end case; 
	end process Direction;
	
	FSM: process(CLK,ARST) 
	begin
		if ARST = '1' then 		   --Asynchronous reset
			Qp<= (others=>'0');	
		elsif rising_edge(CLK) then  
			Qp<=Qn;
		end if;	
	end process FSM;
	
end Behavior_QuadratureDecoder_1X_V1; 	 
----------------------------------------------------------------------------------------------------
configuration QuadratureDecoder_1X_CFG of QuadratureDecoder_1X is
	--for  Behavior_QuadratureDecoder_1X_V1
	for  RTL_QuadratureDecoder_1X_V4
	end for;
end QuadratureDecoder_1X_CFG;