`timescale 1 ps/ 1 ps
module f_measure (
    input clk,          input rst,
    input [7:0]sw,      input signal_in,
    output signal_out,  output gate_out,
    output [30:0]M,     output [26:0]N,
    output [54:0]frec,output gate
);
wire [30:0]M1;wire [30:0]M2;
reg sigdiv16;reg [3:0]cnt;
    clk_div	clk_div_i1
(
	.clk_50M(clk),  .rst(rst),
	.sw(sw),        .signal(signal_out)
	);
    measure  measure_i1
(
    .clk(clk),          .rst(rst),
    .sig_in(signal_in), .gate_out(gate_out),
    .M(M1),              .N(N),	.gate(gate)
);

always @(posedge signal_in or negedge rst )
begin
	if(!rst)
		begin
			sigdiv16 <= 0;cnt <= 0;
		end
	else begin
		cnt<= (cnt==7)?0:(cnt+1);
		sigdiv16<=(cnt)?sigdiv16:(~sigdiv16);
	end
end
    measure  measure_i2
(
    .clk(clk),          .rst(rst),
    .sig_in(sigdiv16), //.gate_out(gate_out),
    .M(M2)//,              .N(N)
);
assign M=((M1>31'd0)&&(M1<31'd10_000_000))?M1:(M2*16);
assign frec=50_000_000*M/N;

endmodule