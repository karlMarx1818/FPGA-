
module clk_div
(
	input clk_50M,
	input rst,
	input [7:0] sw,
	output reg signal
	);
	
	reg	sig1,sig2;wire sig100,sig200,sig300;
	reg [24:0]cnt;reg [3:0]cnt2;

	always @(posedge clk_50M or negedge rst )//2*n分频,cnt belong [0,n-1]
	begin	
		if(!rst)begin	sig1 <= 0;cnt <= 0;	end
		else begin
		case(sw)
			default:begin	cnt<= (cnt<4)?(cnt+1):0;  sig1<=(cnt<2)?1:0;		end	/*10Mhz*/
			1 :begin cnt<= (cnt==24999999)?0:(cnt+1); sig1<=(cnt)?sig1:(~sig1);	end	/*1Hz*/
			2 :begin cnt<= (cnt==24999)?0:(cnt+1);	  sig1<=(cnt)?sig1:(~sig1);	end	/*1kHz*/
			4 :begin cnt<= (cnt==56689)?0:(cnt+1);	  sig1<=(cnt)?sig1:(~sig1);	end	/*441hz,T/2=1133ns*/
			8 :begin cnt<= (cnt==23999999)?0:(cnt+1); sig1<=(cnt)?sig1:(~sig1);	end	/*25/24hz*/
			16:begin cnt<= (cnt==24)?0:(cnt+1);		  sig1<=(cnt)?sig1:(~sig1);	end	/*1Mhz*/
			32:begin sig1<=~sig1;	end	/*25Mhz*/
		endcase
		end
	end
	always @(negedge clk_50M or negedge rst )
	begin
		if(!rst)begin sig2 <= 0;cnt2 <= 0;	end
		else if(sw==0)//10M
		begin
			cnt2<= (cnt2<4)?(cnt2+1):0;
			sig2<=(cnt2<2)?1:0;
		end
	end
	pll_200M	pll_200M_i1
	(
	.inclk0(clk_50M),  .c0(sig100),
	.c1(sig200),        .c2(sig300)
	);
	always @(*) 
	begin
		case(sw)
		0:		signal=sig1|sig2;
		64:		signal=sig100;
		128:	signal=sig200;
		192:	signal=sig300;
		default:signal=sig1;
		endcase
	end
endmodule
	