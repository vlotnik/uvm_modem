//--------------------------------------------------------------------------------------------------------------------------------
// name : raxi_base_test
//--------------------------------------------------------------------------------------------------------------------------------
class raxi_base_test #(
      RAXI_DWI
    , RAXI_DWO
) extends uvm_test;

    `uvm_component_new

    typedef uvm_component_registry #(raxi_base_test #(
          RAXI_DWI
        , RAXI_DWO
    ), "raxi_base_test") type_id;

    // functions
    extern function void build_phase(uvm_phase phase);

    // objects
    virtual raxi_bfm #(
          .DW(RAXI_DWI)
    )                                   raxi_bfm_i;
    virtual raxi_bfm #(
          .DW(RAXI_DWO)
    )                                   raxi_bfm_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void raxi_base_test::build_phase(uvm_phase phase);
    // get bfm from database
    if (!uvm_config_db #(virtual raxi_bfm #(RAXI_DWI))::get(this, "", "raxi_bfm_i", raxi_bfm_i))
        `uvm_fatal("BFM", "Failed to get raxi_bfm_i");
    if (!uvm_config_db #(virtual raxi_bfm #(RAXI_DWO))::get(this, "", "raxi_bfm_o", raxi_bfm_o))
        `uvm_fatal("BFM", "Failed to get raxi_bfm_o");
endfunction