---------------------------------------------------------------------------------------
--By Ing. Maximiliano Valencia Moctezuma 		 Date:17/08/2011
--E-Mail: mavamo135@gmail.com			     Rev 1.0		
--Description:
--Unit for decoding an incremental encoder with a resolution increased by 2X
---------------------------------------------------------------------------------------

library ieee ;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------------

entity QuadratureDecoder_2X is	       --Entity incremental quadrature decoder(2X)
	port ( 
		CLK	: 	in std_logic:='U';	   --Clock
		ARST	: 	in std_logic:='U'; --Asynchronous reset='0'
		CHA :	in std_logic:='U';	   --Encoder channel A 
		CHB	: 	in std_logic:='U';	   --Encoder channel B
		Count : 	out std_logic:='0';	   --Number of counts
		UpDown: 	out std_logic:='0'	   --Direction
		);
end QuadratureDecoder_2X;

---------------------------------------------------------------------------------------
architecture Behavior_QuadratureDecoder_V1 of QuadratureDecoder_2X is
begin
	Count<=CHA xor CHB;
	
	FF_D: process
	begin 
		wait until(CHA='1');
		UpDown<=CHB;
	end process FF_D;
	
end Behavior_QuadratureDecoder_V1; 

---------------------------------------------------------------------------------------

architecture Behavior_QuadratureDecoder_V2 of QuadratureDecoder_2X is
	signal Qp,Qn: std_logic_vector(1 downto 0):=(others=>'0');  
	signal UpDownSig: std_logic:='0';
begin
	Count<=CHA xor CHB;
	UpDown<=UpDownSig;
	
	Direction: process(CHA,CHB,Qp)
	begin
		case Qp is
			when "00"=>
				if CHA='0' and CHB='1' then
					Qn<="01";
					UpDownSig<='1';
				elsif CHA='1' and CHB='0' then
					Qn<="10";
					UpDownSig<='0';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when "01"=>
				if CHA='1'and CHB='1' then
					Qn<="11";
					UpDownSig<='1';
				elsif CHA='0' and CHB='0' then
					Qn<="00";
					UpDownSig<='0';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when "10" =>
				if CHA='0' and CHB='0' then 
					Qn<="00";
					UpDownSig<='1';
				elsif CHA='1' and CHB='1' then
					Qn<="11";
					UpDownSig<='0';
				else
					Qn<=Qp;
					UpDownSig<='0';
			end if;
			when "11" =>
				if CHA='0' and CHB='1' then 
					Qn<="01";
					UpDownSig<='0';
				elsif CHA='1' and CHB='0' then
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
	
end Behavior_QuadratureDecoder_V2; 	 

---------------------------------------------------------------------------------------

configuration QuadratureDecoder_2X_CFG of QuadratureDecoder_2X is
	for  Behavior_QuadratureDecoder_V1
	end for;
end QuadratureDecoder_2X_CFG;