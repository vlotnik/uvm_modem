//--------------------------------------------------------------------------------------------------------------------------------
// name : pkg_modem
//--------------------------------------------------------------------------------------------------------------------------------
package pkg_modem;
    `include "file_io.svh"

    // base types
    typedef real t_real_array[];

    typedef struct{
        int i;
        int q;
    } t_iq;

    // modulations
    typedef enum{
          BPSK
        , QPSK
        , PSK8
    } t_modulation;

    typedef struct{
        string name;
        int symbol_size;
    } t_modulation_settings;

    function t_modulation_settings get_modulation_settings(t_modulation modulation);
        t_modulation_settings result;
        case (modulation)
            // name, symbol_size
            BPSK : result = '{"BPSK", 1};
            QPSK : result = '{"QPSK", 2};
            PSK8 : result = '{"PSK8", 3};
            default : result = '{"BPSK",  1};
        endcase
        return result;
    endfunction
endpackage