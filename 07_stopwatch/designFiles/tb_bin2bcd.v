`timescale 1ns/1ps
module tb_bin2bcd;

parameter NUM_BITS = 10;
parameter NUM_DIGITS = 4;

reg [NUM_BITS-1:0] ivBinary;
wire [NUM_DIGITS*4-1:0] ovBCD;

bin2bcd #(
	.NUM_BITS(NUM_BITS),
	.NUM_DIGITS(NUM_DIGITS)
	) dut 
	(
		.ivBinary(ivBinary),
		.ovBCD(ovBCD)
	);

task print_result;
	begin
		$display("| %4d | %10b | %1d%1d%1d%1d |",
		ivBinary,
		ivBinary,
		ovBCD[15:12],
		ovBCD[11:8],
		ovBCD[7:4],
		ovBCD[3:0]);
	end//task
endtask

integer i;

initial begin

    $display("----------------------------------------------");
    $display("| DEC | TH | HU | TE | UN |");
    $display("----------------------------------------------");

    for(i=0; i<1024; i=i+1) begin

        ivBinary = i;
        #1;

        $display("| %4d | %1d | %1d | %1d | %1d |",
                 i,
                 ovBCD[15:12],
                 ovBCD[11:8],
                 ovBCD[7:4],
                 ovBCD[3:0]);
    end//for

    $stop;

end
endmodule