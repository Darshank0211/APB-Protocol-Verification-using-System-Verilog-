class apb_scb;

  // Declarations
  localparam int MEM_DEPTH = 1024;
  bit [31:0]   ref_mem [0:MEM_DEPTH-1];
  mailbox  m_mon2scb;
  int           pass_count = 0;
  int           fail_count = 0;

  // Constructor
  function new();
    m_mon2scb = apb_config_db::mon2scb;
    if (m_mon2scb == null)
      $fatal("SCB: mon2scb mailbox not set");
    foreach (ref_mem[i])
      ref_mem[i] = 32'h0;
    $display("[%0t] SCB: Initialized reference memory", $time);
  endfunction

  // Run task
  task run();
    apb_tx mon_tx;
    forever begin
      m_mon2scb.get(mon_tx);
      if (mon_tx.pwrite) begin
        ref_mem[mon_tx.paddr] = mon_tx.pwdata;
        $display("[%0t] SCB: WRITE  [0x%08h] <= 0x%08h",
                 $time, mon_tx.paddr, mon_tx.pwdata);
        pass_count++;
      end else begin
        bit [31:0] expected = ref_mem[mon_tx.paddr];
        $display("[%0t] SCB: READ   [0x%08h] exp=0x%08h got=0x%08h",
                 $time, mon_tx.paddr, expected, mon_tx.prdata);
        if (mon_tx.prdata === expected) begin
          $display("[%0t] SCB: ✅ READ PASS", $time);
          pass_count++;
        end else begin
          $display("[%0t] SCB: ❌ READ FAIL", $time);
          fail_count++;
        end
      end
      $display("[%0t] SCB STATS: Pass=%0d Fail=%0d", $time, pass_count, fail_count);
    end
  endtask

  // Final report
  task final_report();
    $display("\n=== SCB FINAL REPORT ===");
    $display("Total Pass: %0d", pass_count);
    $display("Total Fail: %0d", fail_count);
    if (pass_count + fail_count > 0) begin
      real rate = 100.0 * pass_count / (pass_count + fail_count);
      $display("Success Rate: %0.2f%%", rate);
    end
    $display("========================\n");
  endtask

endclass

