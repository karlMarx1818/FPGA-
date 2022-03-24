`timescale 1 ps/ 1 ps
module measure (
    input clk,      input rst,
    input sig_in,
    output reg gate_out,    output reg gate,
    output reg[30:0]M,      output reg[26:0]N
);
reg [26:0]cnt;//预置闸门
//reg gate0;
//reg gate1;
//wire gate_posedge;
reg [26:0]cntclk;reg [30:0]cntsig;
//assign gate_posedge = gate0&&(!gate1);
//reg gate;
always @(posedge clk or negedge rst) begin
    if(!rst)begin cntclk<=0;N<=0; end
    else begin
        if(gate_out)cntclk<=cntclk+1;
        else begin cntclk<=0;N<=cntclk?cntclk:N;end
    end
end
always @(posedge sig_in or negedge rst) begin
    if(!rst)begin gate_out<=0; end
    else begin
    if (gate) gate_out<=1;
    else  gate_out<=0;
	end
end

always @(posedge sig_in or negedge rst) begin
	if(!rst)begin cntsig<=0;M<=0; end
	else begin
		if(gate)cntsig<=cntsig+1;//if gate
		else begin 	cntsig<=0;M<=cntsig?cntsig:M;end
	end
end
	 
always @(posedge clk or negedge rst) begin//开/关预置闸门
    if(!rst)begin cnt<=1;gate<=1; end
    else    begin
        cnt<=(cnt<100000000)?(cnt+1):0;
        gate<=(cnt>49000000)?0:1;//低电平>1s
    end
end
/*
always@(posedge clk)
begin
		frec<=50_000_000*M/N;
end*/


endmodule