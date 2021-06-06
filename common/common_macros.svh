//--------------------------------------------------------------------------------------------------------------------------------
// name : common_macros
//--------------------------------------------------------------------------------------------------------------------------------
`ifndef print_logo
    `define print_logo \
        int logo_sel; \
        initial begin \
            logo_sel = $urandom_range(0, pkg_logo::nof_logo - 1); \
            pkg_logo::print_logo(logo_sel); \
        end
`endif

`ifndef uvm_object_new
    `define uvm_object_new \
        function new (string name=""); \
            super.new(name); \
        endfunction
`endif

`ifndef uvm_object_create
    `define uvm_object_create(_type_name_, _inst_name_, _id_ = 0) \
        _inst_name_ = _type_name_::type_id::create($sformatf({`"_inst_name_`", "_%0d"}, _id_));
`endif

`ifndef uvm_component_new
    `define uvm_component_new \
        function new (string name="", uvm_component parent=null); \
            super.new(name, parent); \
        endfunction
`endif

`ifndef uvm_component_create
    `define uvm_component_create(_type_name_, _inst_name_, _id_ = 0) \
        _inst_name_ = _type_name_::type_id::create($sformatf({`"_inst_name_`", "_%0d"}, _id_), this);
`endif

// dump data to file
`ifndef dsp_dump_to_file
    `define dsp_dump_to_file(_nofbytes_, _name_, _v_, _d_, _clk_, _folder_ = "", _id_ = 0, _use_id_ = 0) \
    file_io #(_nofbytes_) file_``_name_; \
    initial begin \
        if (_use_id_ == 1) \
            file_``_name_ = new({_folder_, $sformatf({`"_name_`", "_%0d"}, _id_), ".bin"}, "wb"); \
        else \
            file_``_name_ = new({_folder_, `"_name_`", ".bin"}, "wb"); \
    end \
    always @(posedge _clk_) \
    begin : _name_ \
        if (_v_ == 1) begin \
            file_``_name_.write(_d_); \
        end \
    end
`endif