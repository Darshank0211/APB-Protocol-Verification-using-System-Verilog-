`define IDLE   0
`define SETUP  1
`define ACCESS 2

module apb_dut #(parameter DEPTH = 1024) (
    input  logic         pclk,
    input  logic         presetn,
    input  logic         psel,
    input  logic         pwrite,
    input  logic         penable,
    input  logic [31:0]  paddr,
    input  logic [31:0]  pwdata,
    output logic [31:0]  prdata,
    output logic         pready,
    output logic         pslverr
);

    logic [31:0] mem [0:DEPTH-1];
    logic [1:0]  _state, _next_state;

    // Sequential: reset, write, ready/error
    always_ff @(posedge pclk or negedge presetn) begin
        if (!presetn) begin
            _state  <= `IDLE;
            pready  <= 1'b1;
            pslverr <= 1'b0;
            for (int i = 0; i < DEPTH; i++) mem[i] <= 32'h0;
            $display("[%0t] DUT: Reset complete, memory cleared", $time);
        end else begin
            _state  <= _next_state;
            pready  <= 1'b1; // no wait-states
            pslverr <= 1'b0;

            if (psel && penable && pwrite) begin
                mem[paddr[9:0]] <= pwdata;
                $display("[%0t] DUT WRITE: mem[0x%03h] <= 0x%08h",
                         $time, paddr[9:0], pwdata);
            end
        end
    end

    // Combinational: immediate read on completion cycle
    always_comb begin
        prdata = 32'h0;
        if (psel && penable && !pwrite && pready) begin
            prdata = mem[paddr[9:0]];
            $display("[%0t] DUT READ : mem[0x%03h] -> 0x%08h",
                     $time, paddr[9:0], prdata);
        end
    end

    // FSM (optional protocol tracking)
    always_comb begin
        unique case (_state)
            `IDLE:   _next_state = (psel && !penable)  ? `SETUP  : `IDLE;
            `SETUP:  _next_state = (psel &&  penable)  ? `ACCESS : `SETUP;
            `ACCESS: _next_state = (!psel || !penable) ? `IDLE   : `ACCESS;
            default: _next_state = `IDLE;
        endcase
    end

    // Final (simulation-only)
    final begin
        automatic int count = 0;
        $display("\n=== FINAL DUT MEMORY ===");
        for (int i = 0; i < 64; i++) begin
            if (mem[i] != 32'h0) begin
                $display("mem[0x%02h] = 0x%08h", i, mem[i]);
                count++;
            end
        end
        if (count == 0) $display("No data stored");
        else            $display("Total entries written: %0d", count);
        $display("========================\n");
    end

endmodule

