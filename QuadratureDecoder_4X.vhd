--By Ing. Maximiliano Valencia Moctezuma 		 Date:16/07/2011
--E-Mail: mavamo135@gmail.com			     Rev 1.0		
--Description:
--Unit for decoding an incremental encoder with a resolution increased by 4X

library ieee ;
use ieee.std_logic_1164.all;

entity QuadratureDecoder_4X is	   --Entity incremental quadrature decoder(4X)
	port ( 
		CLK	: 	in std_logic:='U';	   --Clock
		ARST	:in std_logic:='U';	   --Asynchronous reset='1'
		CHA :	in std_logic:='U';	   --Encoder channel A 
		CHB	: 	in std_logic:='U';	   --Encoder channel B
		Count : 	out std_logic;	   --Number of counts
		UpDown: 	out std_logic	   --Direction
		);
end QuadratureDecoder_4X;

architecture Behavior_QuadratureDecoder_4X_V1 of QuadratureDecoder_4X is
	
	signal Qp,Qn: std_logic_vector(1 downto 0):=(others=>'0');  
	signal UpDownSig,CountSig: std_logic:='0';
	
begin
	Count<=CountSig;
	UpDown<=UpDownSig;
	
	FF: process (CLK,ARST,CHA,CHB)	
	begin
		if ARST = '1' then 		   --Asynchronous reset
			Qp<= (others=>'0');	
			CountSig<='0';
			UpDownSig<='0';
		elsif rising_edge(CLK) then 
			case Qp is
				when "00"=>
					if CHA='1' then
						Qp<="01";
						CountSig<='1';
						UpDownSig<='1';
					elsif CHB='1' then
						Qp<="11";
						CountSig<='1';
						UpDownSig<='0';
					else
						CountSig<='0';
						UpDownSig<='0';
				end if;
				when "01"=>
					if CHB='1' then
						Qp<="10";
						CountSig<='1';
						UpDownSig<='1';
					elsif CHA='0' then
						Qp<="00";
						CountSig<='1';
						UpDownSig<='0';
					else
						CountSig<='0';
						UpDownSig<='0';
				end if;
				when "10" =>
					if CHA='0' then 
						Qp<="11";
						CountSig<='1';
						UpDownSig<='1';
					elsif CHB='0' then
						Qp<="01";
						CountSig<='1';
						UpDownSig<='0';
					else
						CountSig<='0';
						UpDownSig<='0';
				end if;
				when "11" =>
					if CHB='0' then 
						Qp<="00";
						CountSig<='1';
						UpDownSig<='1';
					elsif CHA='1' then
						Qp<="10";
						CountSig<='1';
						UpDownSig<='0';
					else
						CountSig<='0';
						UpDownSig<='0';
				end if;
				when others =>
					Qp<="00";
					CountSig<='0';
				UpDownSig<='0';
			end case; 
		end if;	
	end process FF;
	
end Behavior_QuadratureDecoder_4X_V1; 

architecture RTL_QuadratureDecoder_4X_V2 of QuadratureDecoder_4X is
	
	signal Qp0,Qn0		     : std_logic:='0';
	signal Qp1,Qn1 		     : std_logic:='0'; 	
	signal QpUpDown,QnUpDown : std_logic:='0'; 
	signal QpCount,QnCount   : std_logic:='0'; 
	signal Ups,Downs 	     : std_logic:='0'; 
	
begin
	
	Ups   <= ((not CHA) and CHB and (not Qp1)) or( (not CHA) and (not Qp1) and Qp0)or(CHA and Qp1 and Qp0)or(CHA and (not CHB) and Qp1);
	Downs <= ((not CHA) and (not CHB) and Qp1)or((not CHA) and Qp1 and (not Qp0))or(CHA and (not Qp1) and (not Qp0))or(CHA and CHB and (not Qp1));
	
	UpDown<=QpUpDown;
	Count<=QpCount;
	
	process (Ups,Downs)
	begin 
		if Ups='1' and Downs='0'then 
			QnUpDown  <='1';
			QnCount<='1';
		elsif Ups='0' and Downs='1' then
			QnUpDown  <='0';
			QnCount<='1';
		else
			QnUpDown  <='0';
			QnCount<='0';
		end if;
	end process;
	
	process(CHA,CHB,Qp0,Qp1)
	begin
		Qn0<=CHA xor CHB;
		Qn1<=CHB;
	end process;
	
	process(CLK,ARST)
	begin 
		if ARST='1' then					  --Asynchronous reset
			Qp0<='0';
			Qp1<='0'; 
			QpUpDown<='0';
			QpCount<='0';
		elsif rising_edge(CLK) then
			Qp0<=Qn0;
			Qp1<=Qn1; 
			QpUpDown<=QnUpDown;
			QpCount<=QnCount;
		end if;	
	end process;
	
end RTL_QuadratureDecoder_4X_V2; 

architecture RTL_QuadratureDecoder_4X_V3 of QuadratureDecoder_4X is
	
	signal QuadA_Delayed: std_logic:= '0';
	signal QuadB_Delayed: std_logic:= '0';	
	
	signal Count_Enable:    std_logic:='0';
	signal Count_Direction: std_logic:='0';
	
begin
	
	process (CLK,ARST,CHA,CHB)
	begin
		if ARST='1' then					   --Asynchronous reset
			QuadA_Delayed <='0';
			QuadB_Delayed <='0';
		elsif rising_edge(CLK) then
			QuadA_Delayed <= CHA;
			QuadB_Delayed <= CHB; 
			Count<= CHA xor QuadA_Delayed xor CHB xor QuadB_Delayed;
			UpDown<= CHA xor QuadB_Delayed;
		end if;
	end process;
	
end RTL_QuadratureDecoder_4X_V3; 

configuration QuadratureDecoder_4X_CFG of QuadratureDecoder_4X is
	for  RTL_QuadratureDecoder_4X_V3
	end for;
end QuadratureDecoder_4X_CFG;