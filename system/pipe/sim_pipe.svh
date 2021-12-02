//--------------------------------------------------------------------------------------------------------------------------------
// name : sim_pipe
//--------------------------------------------------------------------------------------------------------------------------------
class sim_pipe #(
      DATA_WIDTH = 10
    , DATA_DEPTH = 256
    , PIPE_CE = 0
) extends uvm_object;
    `uvm_object_param_utils(sim_pipe #(DATA_WIDTH, DATA_DEPTH, PIPE_CE))
    `uvm_object_new

    // variables
    bit[0:DATA_DEPTH-1] pipe_v;
    bit[DATA_WIDTH-1:0] pipe_d[DATA_DEPTH];

    extern function automatic void simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function automatic void sim_pipe::simulate(raxi_seqi raxi_seqi_i, ref raxi_seqi raxi_seqi_o);
    bit[DATA_WIDTH-1:0] raxi_data_i;
    bit[DATA_WIDTH-1:0] raxi_data_o;

    if (PIPE_CE == 0) begin
        raxi_seqi_o.valid = raxi_seqi_i.valid;
        for (int ii = 0; ii < DATA_DEPTH; ii++)
            pipe_v[ii] = raxi_seqi_i.valid;
    end else begin
        raxi_seqi_o.valid = pipe_v[DATA_DEPTH-1];
        if (DATA_DEPTH <= 1) begin
            // raxi_seqi_o.valid = pipe_v[DATA_DEPTH-1];
            pipe_v[0] = raxi_seqi_i.valid;
        end else begin
            // raxi_seqi_o.valid = pipe_v[DATA_DEPTH-1];
            pipe_v = {raxi_seqi_i.valid, pipe_v[0:DATA_DEPTH-2]};
        end
    end

    raxi_data_o = pipe_d[DATA_DEPTH-1];
    raxi_seqi_o.data = {<<{raxi_data_o}};
    raxi_data_i = {<<{raxi_seqi_i.data}};

    if (DATA_DEPTH <= 1) begin
        if (raxi_seqi_i.valid == 1)
            pipe_d[0] <= raxi_data_i;
    end else begin
        // pipeline
        for (int ii = DATA_DEPTH-1; ii >= 0; ii--) begin
            if (pipe_v[ii] == 1) begin
                if (ii == 0) begin
                    pipe_d[ii] <= raxi_data_i;
                end else begin
                    pipe_d[ii] <= pipe_d[ii-1];
                end
            end
        end
    end

endfunction