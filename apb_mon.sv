class apb_mon;

  // Declarations
  virtual apb_intf      mon_cb;
  mailbox     m_mon2scb;

  // Constructor
  function new();
    m_mon2scb = apb_config_db::mon2scb;
    if (m_mon2scb == null)
      $fatal("MON: mon2scb mailbox not set");
  endfunction

  // Main run task
task run();
    apb_tx tx;

    // Get handles (however you obtain them in your env)
    mon_cb    = apb_config_db::cb_intf;
    m_mon2scb = apb_config_db::mon2scb;

    if (mon_cb == null)    $fatal("MON: cb_intf not set");
    if (m_mon2scb == null) $fatal("MON: mon2scb mailbox not set");

    forever begin
        @(posedge mon_cb.pclk);

        // Observe completion phase
        if (mon_cb.psel && mon_cb.penable) begin
            tx = new();
            tx.paddr  = mon_cb.paddr;
            tx.pwrite = mon_cb.pwrite;

            if (tx.pwrite) begin
                // WRITE: data already stable in ACCESS
                tx.pwdata = mon_cb.pwdata;
            end
            else begin
                // READ: allow same-cycle combinational settle before sampling
                // This aligns monitor with DUT combinational PRDATA and BFM's #0
                #0;
                tx.prdata = mon_cb.prdata;
            end

            // Send to scoreboard and print once
            m_mon2scb.put(tx);
            $display("[%0t] MON: %s - ADDR=0x%08h DATA=0x%08h",$time,
                     tx.pwrite ? "WRITE" : "READ ",
                     tx.paddr,
                     tx.pwrite ? tx.pwdata : tx.prdata);
        end
    end
endtask
 
endclass

