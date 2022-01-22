//--------------------------------------------------------------------------------------------------------------------------------
// name : fir_filter
//--------------------------------------------------------------------------------------------------------------------------------
class fir_filter extends uvm_object;
    `uvm_object_utils(fir_filter)
    `uvm_object_new

    protected int filter_length;
    protected real coefficients[];

    protected int ring_buffer_i[];
    protected int ring_buffer_q[];
    protected int write_pointer;
    protected int read_pointer;

    int result_i[$];
    int result_q[$];

    // functions
    extern function void set_coefficients(real coefficients[]);
    extern function automatic void filt(ref datagen_seqi datagen_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void fir_filter::set_coefficients(real coefficients[]);
    this.filter_length = coefficients.size();
    this.coefficients = coefficients;

    this.ring_buffer_i = new[this.filter_length];
    this.ring_buffer_q = new[this.filter_length];
endfunction

function automatic void fir_filter::filt(ref datagen_seqi datagen_seqi_h);
    int input_length;
    int iq_pointer;
    real i_accum;
    real q_accum;

    input_length = datagen_seqi_h.iq_i.size();
    result_i.delete();
    result_q.delete();

    while (iq_pointer < input_length) begin
        // write data to buffer
        ring_buffer_i[write_pointer] = datagen_seqi_h.iq_i[iq_pointer];
        ring_buffer_q[write_pointer] = datagen_seqi_h.iq_q[iq_pointer];

        i_accum = 0;
        q_accum = 0;

        for (int k = 0; k < filter_length; k++) begin
            // filter product
            i_accum += coefficients[k] * $itor(ring_buffer_i[read_pointer]);
            q_accum += coefficients[k] * $itor(ring_buffer_q[read_pointer]);

            // read pointer
            if (read_pointer < 1)
                read_pointer = filter_length - 1;
            else
                read_pointer--;
        end

        if (write_pointer < (filter_length - 1))
            write_pointer++;
        else
            write_pointer = 0;

        read_pointer = write_pointer;

        result_i.push_back($rtoi(i_accum));
        result_q.push_back($rtoi(q_accum));

        iq_pointer++;
    end

    datagen_seqi_h.iq_i = result_i;
    datagen_seqi_h.iq_q = result_q;
endfunction