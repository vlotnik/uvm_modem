//-------------------------------------------------------------------------------------------------------------------------------
// name : file_io
//
// #bw - byte width
//-------------------------------------------------------------------------------------------------------------------------------
class file_io #(int bw = 3);
    string                          path;
    integer                         fid;

    typedef reg [bw*8/2-1:0] byte_da_t[1:0];

    // Function: new
    //
    // Constructor
    // argument ~path~ containes path to the file
    // argument ~mode~ containes open mode ()
    extern function new(string path, string mode);

    // Function: read_riff
    //
    // Reads and returns RIFF volume from the file
    extern function reg[367:0] read_riff();

    // Function: write_riff
    //
    // Writes RIFF volume to the file
    extern function void write_riff(reg[367:0] riff);

    // Function: read
    //
    // Reads and returns data from the file
    extern function reg[bw*8-1:0] read();

    // Function: read_rev
    //
    // Reads and returns data from the file
    extern function reg[bw*8-1:0] read_rev();

    // Function: write
    //
    // Writes data to the file
    extern function void write(reg[bw*8-1:0] data);

    // Function: read_iq
    //
    // Reads i/q samples from the file
    extern function byte_da_t read_iq();

    // Function: write_iq
    //
    // Writes i/q samples to the file
    extern function void write_iq(byte_da_t iq);
endclass

//-------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//-------------------------------------------------------------------------------------------------------------------------------
function file_io::new(string path, string mode);
    this.path = path;
    this.fid = $fopen(path, mode);
endfunction

function reg[367:0] file_io::read_riff();
    integer                         r;
    reg[367:0]                      riff;

    r = $fread(riff, fid);

    return riff;
endfunction

function void file_io::write_riff(reg[367:0] riff);
    byte                            data_array [45:0];

    {>>{data_array}} = riff;
    for (int i = 45; i >= 0; i--)
        $fwrite(fid, "%c", data_array[i]);
endfunction

function reg[file_io::bw*8-1:0] file_io::read();
    integer                         r;
    reg [bw*8-1:0]                  data;
    reg [bw*8-1:0]                  data_rev;

    r = $fread(data, fid);
    data_rev = {<<8{data}};

    return data_rev;
endfunction

function reg[file_io::bw*8-1:0] file_io::read_rev();
    integer                         r;
    reg [bw*8-1:0]                  data;
    reg [bw*8-1:0]                  data_rev;

    r = $fread(data, fid);
    data_rev = {<<8{data}};

    return data;
endfunction

function void file_io::write(reg[bw*8-1:0] data);
    byte                            data_array [bw-1:0];

    {>>{data_array}} = data;
    for (int i = 0; i < bw; i++)
        $fwrite(fid, "%c", data_array[i]);
endfunction

function file_io::byte_da_t file_io::read_iq();
    integer                         r;
    reg[bw*8-1:0]                   data;
    reg[bw*8-1:0]                   data_rev;
    reg[bw*8/2-1:0]                 data_out[1:0];

    r = $fread(data, fid);
    data_rev = {<<8{data}};
    data_out[0] = data_rev[bw*8/2-1:0];
    data_out[1] = data_rev[bw*8-1:bw*8/2];

    return data_out;
endfunction

function void file_io::write_iq(file_io::byte_da_t iq);
    reg[bw*8-1:0]                   data;
    reg[bw*8-1:0]                   data_rev;
    byte                            data_array [bw-1:0];

    data = {iq[1], iq[0]};
    {>>{data_array}} = data;
    for (int i = 0; i < bw; i++)
        $fwrite(fid, "%c", data_array[i]);
endfunction