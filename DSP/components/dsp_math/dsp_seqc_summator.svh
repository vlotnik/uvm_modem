//--------------------------------------------------------------------------------------------------------------------------------
// name : dsp_seqc_summator
//--------------------------------------------------------------------------------------------------------------------------------
class dsp_seqc_summator #(
        NOFCH = 1
    ) extends uvm_sequence #(datagen_seqi);
    `uvm_object_param_utils(dsp_seqc_summator #(NOFCH))
    `uvm_object_new

    // settings
    bit[NOFCH-1:0] no_more_data;
    int size_of_nar = 0;
    int ptr_ch = 0;
    int ptr_d[NOFCH];
    int ptr_v[NOFCH];
    int seqi_sz[NOFCH];
    int tr_ptr;

    int fid;
    real tr_gain = 1.0;

    // distortion
    real dist_i = 0.0;
    real dist_q = 0.0;
    real amp = 0.0;
    real ort = 0.0;
    int zsc_i = 0.0;
    int zsc_q = 0.0;

    // functions
    extern function void parse_item();
    extern task pre_body();
    extern task body();

    // objects
    datagen_seqr                    datagen_seqr_h[NOFCH];
    datagen_seqi                    datagen_seqi_i[NOFCH];
    datagen_seqi                    datagen_seqi_o;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void dsp_seqc_summator::parse_item();
    datagen_seqi_o.new_seqi(1);
    datagen_seqi_o.tr_last = datagen_seqi_i[0].tr_last;

    datagen_seqi_o.iq_i[0] = 0;
    datagen_seqi_o.iq_q[0] = 0;

    for (int ch = 0; ch < NOFCH; ch++) begin
        datagen_seqi_o.iq_i[0] += datagen_seqi_i[ch].iq_i[ptr_d[ch]-1];
        datagen_seqi_o.iq_q[0] += datagen_seqi_i[ch].iq_q[ptr_d[ch]-1];
        ptr_d[ch]++;
    end

    dist_i = datagen_seqi_o.iq_i[0] / NOFCH;
    dist_q = datagen_seqi_o.iq_q[0] / NOFCH;

    // add amplitude imbalance
    dist_i = dist_i * (1.0 + amp);
    // add non orthogonality
    dist_i = dist_i + (dist_q * $sin(ort));

    datagen_seqi_o.iq_i[0] = dist_i;

    // add zero shift
    datagen_seqi_o.iq_i[0] += zsc_i;
    datagen_seqi_o.iq_q[0] += zsc_q;
endfunction

task dsp_seqc_summator::pre_body();
    for (int ii = 0; ii < NOFCH; ii++) begin
        no_more_data[ii] = 0;
        ptr_d[ii] = 0;
        ptr_v[ii] = 0;
        seqi_sz[ii] = 0;
        tr_ptr = 0;
    end

    datagen_seqi_o = datagen_seqi::type_id::create("datagen_seqi_o");
endtask

task dsp_seqc_summator::body();
    forever begin
        for (int ch = 0; ch < NOFCH; ch++) begin
            if (ptr_d[ch] == 0) begin
                if (no_more_data[ch] == 0) begin
                    datagen_seqr_h[ch].get_next_item(datagen_seqi_i[ch]);
                    ptr_d[ch]++;
                    seqi_sz[ch] = datagen_seqi_i[ch].iq_i.size;
                end
            end
        end

        parse_item();

        start_item(datagen_seqi_o);
        finish_item(datagen_seqi_o);

        for (int ch = 0; ch < NOFCH; ch++) begin
            if (ptr_d[ch] >= (seqi_sz[ch]+1)) begin
                if (no_more_data[ch] == 0) begin
                    datagen_seqr_h[ch].item_done();
                    ptr_d[ch] = 0;

                    if (datagen_seqi_i[ch].tr_last == 1) begin
                        $display("GOT LAST TRANSACTION FOR CHANNEL %0d", ch);
                        no_more_data[ch] = 1;
                    end
                end
            end
        end
    end
endtask