class apb_gen;
    bit [31:0] last_written_addr;
    bit [31:0] last_written_data;
    bit write_done = 0;
    
    task run();
        repeat(10) begin
            apb_tx tx = new(); 
            
            if (!write_done) begin // First transaction: WRITE
                assert(tx.randomize() with {
                    op == write;
                    paddr inside {[0:31]};  // Small range
                });
                
                last_written_addr = tx.paddr;
                last_written_data = tx.pwdata;
                write_done = 1;
                
                $display("✅ WRITE: Addr=0x%h Data=0x%h", tx.paddr, tx.pwdata);
                
            end else begin
                // Second transaction: READ from same address
                assert(tx.randomize() with {
                    op == read;
                    paddr == last_written_addr;  // ✅ Same address as write
                });
                
                write_done = 0;  // Reset for next pair
                
                $display("✅ READ:  Addr=0x%h (expecting 0x%h)", tx.paddr, last_written_data);
            end
            
            tx.print();
            apb_config_db::gen2bfm.put(tx);
        end
    endtask
endclass

