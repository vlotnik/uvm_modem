//--------------------------------------------------------------------------------------------------------------------------------
// name : fir_resampler
//--------------------------------------------------------------------------------------------------------------------------------
class fir_resampler extends uvm_object;
    `uvm_object_utils(fir_resampler);
    `uvm_object_new

    protected int filter_length;
    protected int num_of_phases;
    protected real coefficients[][];
    protected real ratio;
    protected real ratio_accumulator;

    protected int ring_buffer_i[];
    protected int ring_buffer_q[];
    protected int write_ptr;
    protected int read_ptr;
    protected real ram_addr;
    protected bit next_sample;

    int result_i[$];
    int result_q[$];

    extern function void set_coefficients(real coefficients[], int filter_length, int num_of_phases);
    extern function void set_resampler_ratio(real i_frequency, real o_frequency);
    extern function int add_ratio();
    extern function automatic void resample(ref datagen_seqi datagen_seqi_h);
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------
function void fir_resampler::set_coefficients(real coefficients[], int filter_length, int num_of_phases);
    // create filter_length x num_of_phases array with coefficients
    this.filter_length = filter_length;
    this.num_of_phases = num_of_phases;
    this.coefficients = new[num_of_phases];

    for (int i = 0; i < num_of_phases; i++) begin
        this.coefficients[i] = new[filter_length];
        for (int j = 0; j < filter_length; j++) begin
            this.coefficients[i][j] = coefficients[num_of_phases * j + i];
        end
    end

    // create ring buffers
    this.ring_buffer_i = new[filter_length];
    this.ring_buffer_q = new[filter_length];

    // init accumulator
    this.ratio_accumulator = - 0.5;
endfunction

function void fir_resampler::set_resampler_ratio(real i_frequency, real o_frequency);
    this.ratio = i_frequency / o_frequency;
endfunction

function int fir_resampler::add_ratio();
    real eps;

    eps = $sqrt($pow(2, -52));
    if ((ratio_accumulator) < (0.5 - eps)) begin
        ratio_accumulator += ratio;
        if (ratio_accumulator > (0.5 - eps)) begin
            ratio_accumulator = ratio_accumulator - 1.0;
            return 1; // next sample
        end
        else begin
            return 0;
        end
    end
endfunction

function automatic void fir_resampler::resample(ref datagen_seqi datagen_seqi_h);
    real i_accum;
    real q_accum;
    int input_length;
    int iq_pointer;

    set_resampler_ratio(datagen_seqi_h.tr_sym_f, datagen_seqi_h.tr_rsmp_f);
    datagen_seqi_h.tr_sym_f = datagen_seqi_h.tr_rsmp_f;
    input_length = datagen_seqi_h.iq_i.size();

    result_i.delete();
    result_q.delete();

    while (iq_pointer < input_length) begin
        ring_buffer_i[write_ptr] = datagen_seqi_h.iq_i[iq_pointer];
        ring_buffer_q[write_ptr] = datagen_seqi_h.iq_q[iq_pointer];

        i_accum = 0.0;
        q_accum = 0.0;

        ram_addr = ratio_accumulator + 0.5;

        for (int k = 0; k < filter_length; k++) begin
            // filter product
            i_accum += coefficients[$rtoi(ram_addr * num_of_phases)][k] * ring_buffer_i[read_ptr];
            q_accum += coefficients[$rtoi(ram_addr * num_of_phases)][k] * ring_buffer_q[read_ptr];
            // read pointer
            if (read_ptr < 1)
                read_ptr = filter_length - 1;
            else
                read_ptr--;
        end

        next_sample = add_ratio();

        if (next_sample == 1) begin
            iq_pointer++;
            if (write_ptr < (filter_length - 1))
                write_ptr++;
            else
                write_ptr = 0;
        end
        read_ptr = write_ptr;

        result_i.push_back(i_accum * num_of_phases);
        result_q.push_back(q_accum * num_of_phases);
    end

    datagen_seqi_h.iq_i = result_i;
    datagen_seqi_h.iq_q = result_q;
endfunction