`include "top.v"

module testbench();
  reg          clk;
  reg          reset;

  wire [31:0] WriteData, DataAdr;
  wire         MemWrite;
  top dut(clk, reset, WriteData, DataAdr, MemWrite);
  // initialize test
  initial
  begin
    reset = 1'b1; #22; reset = 1'b0;
  end

  always
  begin
    clk = 1'b1; #5;
    clk = 1'b0; #5;
  end

  // check results
  always @(negedge clk)
  begin
    if(MemWrite) begin
      if(DataAdr === 32'd100 && WriteData === 32'd25) begin
        $display("Simulation succeeded");
        $stop;
      end else if (DataAdr !== 32'd96) begin
        $display("Simulation failed: MemWrite to DataAdr %h with WriteData %h", DataAdr, WriteData);
        $stop;
      end
    end
  end
endmodule