
//  Xilinx Single Port Byte-Write Read First RAM
//  This code implements a parameterizable single-port byte-write read-first memory where when data
//  is written to the memory, the output reflects the prior contents of the memory location.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.
//  Modify the parameters for the desired RAM characteristics.

module ram_instrucciones #(
  parameter NB_COL = 4,                           // Specify number of columns (number of bytes)
  parameter COL_WIDTH = 8,                        // Specify column width (byte width, typically 8 or 9)
  parameter RAM_DEPTH = 1024,                     // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE", // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = ""                        // Specify name/location of RAM initialization file if using one (leave blank if not)
) (
  input [clogb2(RAM_DEPTH-1)-1:0] addra,  // Address bus, width determined from RAM_DEPTH
  input clka,                           // Clock
  output [(NB_COL*COL_WIDTH)-1:0] douta // RAM output data
);

  wire [NB_COL-1:0] wea = 0;               // Byte-write enable
  wire ena = 1;                            // RAM Enable, for additional power savings, disable port when not in use
  wire rsta = 0;                           // Output reset (does not affect memory contents)
  wire regcea = 1;                         // Output register enable
  wire [(NB_COL*COL_WIDTH)-1:0] dina = 0;  // RAM input data

  reg [(NB_COL*COL_WIDTH)-1:0] BRAM [RAM_DEPTH-1:0];
  reg [(NB_COL*COL_WIDTH)-1:0] ram_data = {(NB_COL*COL_WIDTH){1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemh(INIT_FILE, BRAM, 0, RAM_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = {(NB_COL*COL_WIDTH){1'b0}};
    end
  endgenerate

  always @(negedge clka)
    if (ena) begin
      ram_data <= BRAM[addra];
    end

  generate
  genvar i;
     for (i = 0; i < NB_COL; i = i+1) begin: byte_write
       always @(posedge clka)
         if (ena)
           if (wea[i])
             BRAM[addra][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= dina[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
      end
  endgenerate

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign douta = ram_data;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [(NB_COL*COL_WIDTH)-1:0] douta_reg = {(NB_COL*COL_WIDTH){1'b0}};

      always @(posedge clka)
        if (rsta)
          douta_reg <= {(NB_COL*COL_WIDTH){1'b0}};
        else if (regcea)
          douta_reg <= ram_data;

      assign douta = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule

// The following is an instantiation template for xilinx_single_port_byte_write_ram_read_first
/*
  //  Xilinx Single Port Byte-Write Read First RAM
  xilinx_single_port_byte_write_ram_read_first #(
    .NB_COL(4),                           // Specify number of columns (number of bytes)
    .COL_WIDTH(9),                        // Specify column width (byte width, typically 8 or 9)
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .addra(addra),     // Address bus, width determined from RAM_DEPTH
    .dina(dina),       // RAM input data, width determined from NB_COL*COL_WIDTH
    .clka(clka),       // Clock
    .wea(wea),         // Byte-write enable, width determined from NB_COL
    .ena(ena),         // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rsta),       // Output reset (does not affect memory contents)
    .regcea(regcea),   // Output register enable
    .douta(douta)      // RAM output data, width determined from NB_COL*COL_WIDTH
  );
*/
              
              