class apb_bfm;

apb_tx tx;
virtual apb_intf bintf;

task run();
    forever begin
        bintf = apb_config_db::cb_intf;
        apb_config_db::gen2bfm.get(tx);
        
        $display("bfm print start");
        tx.print();
        $display("bfm print end");
        
        driver_logic(tx);
        
    end
endtask

task driver_logic(apb_tx tx);
    if(tx.op == write) begin
        write_w(tx);
    end
    else if(tx.op == read) begin
        read_r(tx);
    end
endtask

// ✅ FIXED WRITE TASK
task write_w(apb_tx tx);
    $display("[%0t] BFM: Starting WRITE to addr 0x%h, data 0x%h", $time, tx.paddr, tx.pwdata);
    
    // SETUP PHASE (T1)
    @(posedge bintf.pclk);
    bintf.bfm_cb.paddr   <= tx.paddr;
    bintf.bfm_cb.pwdata  <= tx.pwdata;
    bintf.bfm_cb.pwrite  <= 1'b1;
    bintf.bfm_cb.psel    <= 1'b1;        // ✅ Force to 1
    bintf.bfm_cb.penable <= 1'b0;
    
    $display("[%0t] BFM: WRITE SETUP phase complete", $time);
    
    // ACCESS PHASE (T2) 
    @(posedge bintf.pclk);
    bintf.bfm_cb.penable <= 1'b1;        // ✅ Enable access phase
    
    $display("[%0t] BFM: WRITE ACCESS phase, waiting for pready...", $time);
    
    // ✅ CRITICAL: Wait for PREADY while keeping signals stable
    while(!bintf.bfm_cb.pready) begin
        @(posedge bintf.pclk);
        // ✅ KEEP SIGNALS STABLE during wait
        bintf.bfm_cb.psel <= 1'b1;
        bintf.bfm_cb.penable <= 1'b1;
        $display("[%0t] BFM: Still waiting for pready...", $time);
    end
    
    $display("[%0t] BFM: PREADY received! Write complete.", $time);
    
    // ✅ HOLD SIGNALS FOR ONE MORE CYCLE
    @(posedge bintf.pclk);
    // Transaction complete, now safe to deassert
    
    // IDLE PHASE - Clean up signals  
    @(posedge bintf.pclk);
    bintf.bfm_cb.penable <= 1'b0;
    bintf.bfm_cb.psel    <= 1'b0;
    bintf.bfm_cb.paddr   <= 32'h0;
    bintf.bfm_cb.pwdata  <= 32'h0;
    bintf.bfm_cb.pwrite  <= 1'b0;
   
    $display("[%0t] COMPLETE: Write transaction finished for addr 0x%h", $time, tx.paddr);
endtask

task read_r(apb_tx tx);
    $display("[%0t] BFM: Starting READ from addr 0x%h", $time, tx.paddr);

    // SETUP PHASE (T1)
    @(posedge bintf.pclk);
    bintf.paddr   = tx.paddr;
    bintf.pwrite  = 1'b0;
    bintf.psel    = 1'b1;
    bintf.penable = 1'b0;
    $display("[%0t] BFM: READ SETUP phase complete", $time);

    // ACCESS PHASE (T2)
    @(posedge bintf.pclk);
    bintf.penable = 1'b1;
    $display("[%0t] BFM: READ ACCESS phase", $time);

    // Same-cycle settle, then sample
    #0;
    if (bintf.pready) begin
        tx.prdata = bintf.prdata;
        $display("[%0t] BFM: READ complete, captured data = 0x%h", $time, tx.prdata);
    end else begin
        // Wait for PREADY with stable signals
        do begin
            @(posedge bintf.pclk);
            bintf.psel    = 1'b1;
            bintf.penable = 1'b1;
            $display("[%0t] BFM: Still waiting for pready...", $time);
        end while (!bintf.pready);
        // Sample immediately when pready observed high
        tx.prdata = bintf.prdata;
        $display("[%0t] BFM: READ complete after wait, data = 0x%h", $time, tx.prdata);
    end

    // Hold one cycle, then IDLE
    @(posedge bintf.pclk);
    bintf.penable = 1'b0;
    bintf.psel    = 1'b0;
    bintf.paddr   = 32'h0;
    bintf.pwrite  = 1'b0;
    $display("[%0t] COMPLETE: Read transaction finished", $time);
endtask



endclass

