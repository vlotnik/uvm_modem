class datagen_seqi extends uvm_sequence_item;
    `uvm_object_utils(datagen_seqi)
    `uvm_object_new

    // data
    rand bit                        bitstream[];

    // settings
    int                             tr_pldsz = 0;
endclass

//--------------------------------------------------------------------------------------------------------------------------------
// IMPLEMENTATION
//--------------------------------------------------------------------------------------------------------------------------------