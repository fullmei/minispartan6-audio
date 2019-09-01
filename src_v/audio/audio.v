//-----------------------------------------------------------------
//                      Audio Controller
//                           V0.1
//                     Ultra-Embedded.com
//                     Copyright 2012-2019
//
//                 Email: admin@ultra-embedded.com
//
//                         License: GPL
// If you would like a version with a more permissive license for
// use in closed source commercial applications please contact me
// for details.
//-----------------------------------------------------------------
//
// This file is open source HDL; you can redistribute it and/or 
// modify it under the terms of the GNU General Public License as 
// published by the Free Software Foundation; either version 2 of 
// the License, or (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public 
// License along with this file; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
//-----------------------------------------------------------------

//-----------------------------------------------------------------
//                          Generated File
//-----------------------------------------------------------------

`include "audio_defs.v"

//-----------------------------------------------------------------
// Module:  Audio Controller
//-----------------------------------------------------------------
module audio
(
    // Inputs
     input          clk_i
    ,input          rst_i
    ,input          cfg_awvalid_i
    ,input  [31:0]  cfg_awaddr_i
    ,input          cfg_wvalid_i
    ,input  [31:0]  cfg_wdata_i
    ,input  [3:0]   cfg_wstrb_i
    ,input          cfg_bready_i
    ,input          cfg_arvalid_i
    ,input  [31:0]  cfg_araddr_i
    ,input          cfg_rready_i

    // Outputs
    ,output         cfg_awready_o
    ,output         cfg_wready_o
    ,output         cfg_bvalid_o
    ,output [1:0]   cfg_bresp_o
    ,output         cfg_arready_o
    ,output         cfg_rvalid_o
    ,output [31:0]  cfg_rdata_o
    ,output [1:0]   cfg_rresp_o
    ,output         audio_l_o
    ,output         audio_r_o
    ,output         intr_o
);

//-----------------------------------------------------------------
// Retime write data
//-----------------------------------------------------------------
reg [31:0] wr_data_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    wr_data_q <= 32'b0;
else
    wr_data_q <= cfg_wdata_i;

//-----------------------------------------------------------------
// Request Logic
//-----------------------------------------------------------------
wire read_en_w  = cfg_arvalid_i & cfg_arready_o;
wire write_en_w = cfg_awvalid_i & cfg_awready_o;

//-----------------------------------------------------------------
// Accept Logic
//-----------------------------------------------------------------
assign cfg_arready_o = ~cfg_rvalid_o;
assign cfg_awready_o = ~cfg_bvalid_o && ~cfg_arvalid_i; 
assign cfg_wready_o  = cfg_awready_o;


//-----------------------------------------------------------------
// Register audio_cfg
//-----------------------------------------------------------------
reg audio_cfg_wr_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_wr_q <= 1'b0;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_wr_q <= 1'b1;
else
    audio_cfg_wr_q <= 1'b0;

// audio_cfg_int_threshold [internal]
reg [15:0]  audio_cfg_int_threshold_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_int_threshold_q <= 16'd`AUDIO_CFG_INT_THRESHOLD_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_int_threshold_q <= cfg_wdata_i[`AUDIO_CFG_INT_THRESHOLD_R];

wire [15:0]  audio_cfg_int_threshold_out_w = audio_cfg_int_threshold_q;


// audio_cfg_byte_swap [internal]
reg        audio_cfg_byte_swap_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_byte_swap_q <= 1'd`AUDIO_CFG_BYTE_SWAP_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_byte_swap_q <= cfg_wdata_i[`AUDIO_CFG_BYTE_SWAP_R];

wire        audio_cfg_byte_swap_out_w = audio_cfg_byte_swap_q;


// audio_cfg_ch_swap [internal]
reg        audio_cfg_ch_swap_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_ch_swap_q <= 1'd`AUDIO_CFG_CH_SWAP_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_ch_swap_q <= cfg_wdata_i[`AUDIO_CFG_CH_SWAP_R];

wire        audio_cfg_ch_swap_out_w = audio_cfg_ch_swap_q;


// audio_cfg_target [internal]
reg [1:0]  audio_cfg_target_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_target_q <= 2'd`AUDIO_CFG_TARGET_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_target_q <= cfg_wdata_i[`AUDIO_CFG_TARGET_R];

wire [1:0]  audio_cfg_target_out_w = audio_cfg_target_q;


// audio_cfg_vol_ctrl [internal]
reg [2:0]  audio_cfg_vol_ctrl_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_vol_ctrl_q <= 3'd`AUDIO_CFG_VOL_CTRL_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_vol_ctrl_q <= cfg_wdata_i[`AUDIO_CFG_VOL_CTRL_R];

wire [2:0]  audio_cfg_vol_ctrl_out_w = audio_cfg_vol_ctrl_q;


// audio_cfg_buffer_rst [auto_clr]
reg        audio_cfg_buffer_rst_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_cfg_buffer_rst_q <= 1'd`AUDIO_CFG_BUFFER_RST_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CFG))
    audio_cfg_buffer_rst_q <= cfg_wdata_i[`AUDIO_CFG_BUFFER_RST_R];
else
    audio_cfg_buffer_rst_q <= 1'd`AUDIO_CFG_BUFFER_RST_DEFAULT;

wire        audio_cfg_buffer_rst_out_w = audio_cfg_buffer_rst_q;


//-----------------------------------------------------------------
// Register audio_status
//-----------------------------------------------------------------
reg audio_status_wr_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_status_wr_q <= 1'b0;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_STATUS))
    audio_status_wr_q <= 1'b1;
else
    audio_status_wr_q <= 1'b0;




//-----------------------------------------------------------------
// Register audio_clk_div
//-----------------------------------------------------------------
reg audio_clk_div_wr_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_clk_div_wr_q <= 1'b0;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CLK_DIV))
    audio_clk_div_wr_q <= 1'b1;
else
    audio_clk_div_wr_q <= 1'b0;

// audio_clk_div_whole_cycles [internal]
reg [15:0]  audio_clk_div_whole_cycles_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_clk_div_whole_cycles_q <= 16'd`AUDIO_CLK_DIV_WHOLE_CYCLES_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CLK_DIV))
    audio_clk_div_whole_cycles_q <= cfg_wdata_i[`AUDIO_CLK_DIV_WHOLE_CYCLES_R];

wire [15:0]  audio_clk_div_whole_cycles_out_w = audio_clk_div_whole_cycles_q;


//-----------------------------------------------------------------
// Register audio_clk_frac
//-----------------------------------------------------------------
reg audio_clk_frac_wr_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_clk_frac_wr_q <= 1'b0;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CLK_FRAC))
    audio_clk_frac_wr_q <= 1'b1;
else
    audio_clk_frac_wr_q <= 1'b0;

// audio_clk_frac_numerator [internal]
reg [15:0]  audio_clk_frac_numerator_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_clk_frac_numerator_q <= 16'd`AUDIO_CLK_FRAC_NUMERATOR_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CLK_FRAC))
    audio_clk_frac_numerator_q <= cfg_wdata_i[`AUDIO_CLK_FRAC_NUMERATOR_R];

wire [15:0]  audio_clk_frac_numerator_out_w = audio_clk_frac_numerator_q;


// audio_clk_frac_denominator [internal]
reg [15:0]  audio_clk_frac_denominator_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_clk_frac_denominator_q <= 16'd`AUDIO_CLK_FRAC_DENOMINATOR_DEFAULT;
else if (write_en_w && (cfg_awaddr_i[7:0] == `AUDIO_CLK_FRAC))
    audio_clk_frac_denominator_q <= cfg_wdata_i[`AUDIO_CLK_FRAC_DENOMINATOR_R];

wire [15:0]  audio_clk_frac_denominator_out_w = audio_clk_frac_denominator_q;


//-----------------------------------------------------------------
// Register audio_fifo_write
//-----------------------------------------------------------------
reg audio_fifo_write_wr_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    audio_fifo_write_wr_q <= 1'b0;
else if (write_en_w && (cfg_awaddr_i[7:0] >= `AUDIO_FIFO_WRITE && cfg_awaddr_i[7:0] < (`AUDIO_FIFO_WRITE + 8'd32)))
    audio_fifo_write_wr_q <= 1'b1;
else
    audio_fifo_write_wr_q <= 1'b0;

// audio_fifo_write_ch_b [external]
wire [15:0]  audio_fifo_write_ch_b_out_w = wr_data_q[`AUDIO_FIFO_WRITE_CH_B_R];


// audio_fifo_write_ch_a [external]
wire [15:0]  audio_fifo_write_ch_a_out_w = wr_data_q[`AUDIO_FIFO_WRITE_CH_A_R];


wire [15:0]  audio_status_level_in_w;
wire        audio_status_full_in_w;
wire        audio_status_empty_in_w;


//-----------------------------------------------------------------
// Read mux
//-----------------------------------------------------------------
reg [31:0] data_r;

always @ *
begin
    data_r = 32'b0;

    case (cfg_araddr_i[7:0])

    `AUDIO_CFG:
    begin
        data_r[`AUDIO_CFG_INT_THRESHOLD_R] = audio_cfg_int_threshold_q;
        data_r[`AUDIO_CFG_BYTE_SWAP_R] = audio_cfg_byte_swap_q;
        data_r[`AUDIO_CFG_CH_SWAP_R] = audio_cfg_ch_swap_q;
        data_r[`AUDIO_CFG_TARGET_R] = audio_cfg_target_q;
        data_r[`AUDIO_CFG_VOL_CTRL_R] = audio_cfg_vol_ctrl_q;
    end
    `AUDIO_STATUS:
    begin
        data_r[`AUDIO_STATUS_LEVEL_R] = audio_status_level_in_w;
        data_r[`AUDIO_STATUS_FULL_R] = audio_status_full_in_w;
        data_r[`AUDIO_STATUS_EMPTY_R] = audio_status_empty_in_w;
    end
    `AUDIO_CLK_DIV:
    begin
        data_r[`AUDIO_CLK_DIV_WHOLE_CYCLES_R] = audio_clk_div_whole_cycles_q;
    end
    `AUDIO_CLK_FRAC:
    begin
        data_r[`AUDIO_CLK_FRAC_NUMERATOR_R] = audio_clk_frac_numerator_q;
        data_r[`AUDIO_CLK_FRAC_DENOMINATOR_R] = audio_clk_frac_denominator_q;
    end
    default :
        data_r = 32'b0;
    endcase
end

//-----------------------------------------------------------------
// RVALID
//-----------------------------------------------------------------
reg rvalid_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    rvalid_q <= 1'b0;
else if (read_en_w)
    rvalid_q <= 1'b1;
else if (cfg_rready_i)
    rvalid_q <= 1'b0;

assign cfg_rvalid_o = rvalid_q;

//-----------------------------------------------------------------
// Retime read response
//-----------------------------------------------------------------
reg [31:0] rd_data_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    rd_data_q <= 32'b0;
else if (!cfg_rvalid_o || cfg_rready_i)
    rd_data_q <= data_r;

assign cfg_rdata_o = rd_data_q;
assign cfg_rresp_o = 2'b0;

//-----------------------------------------------------------------
// BVALID
//-----------------------------------------------------------------
reg bvalid_q;

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
    bvalid_q <= 1'b0;
else if (write_en_w)
    bvalid_q <= 1'b1;
else if (cfg_bready_i)
    bvalid_q <= 1'b0;

assign cfg_bvalid_o = bvalid_q;
assign cfg_bresp_o  = 2'b0;


wire audio_fifo_write_wr_req_w = audio_fifo_write_wr_q;

`define TARGET_W      2
`define TARGET_I2S    2'd0
`define TARGET_SPDIF  2'd1
`define TARGET_ANALOG 2'd2

//-----------------------------------------------------------------
// Write samples
//-----------------------------------------------------------------   
reg [15:0] sample_a_r;
reg [15:0] sample_b_r;

always @ *
begin
    sample_a_r = audio_fifo_write_ch_a_out_w;
    sample_b_r = audio_fifo_write_ch_b_out_w;

    if (audio_cfg_ch_swap_out_w)
    begin
        if (audio_cfg_byte_swap_out_w)
        begin
            sample_a_r = {audio_fifo_write_ch_b_out_w[7:0], audio_fifo_write_ch_b_out_w[15:8]};
            sample_b_r = {audio_fifo_write_ch_a_out_w[7:0], audio_fifo_write_ch_a_out_w[15:8]};
        end
        else
        begin
            sample_a_r = audio_fifo_write_ch_b_out_w;
            sample_b_r = audio_fifo_write_ch_a_out_w;
        end
    end
    else
    begin
        if (audio_cfg_byte_swap_out_w)
        begin
            sample_a_r = {audio_fifo_write_ch_a_out_w[7:0], audio_fifo_write_ch_a_out_w[15:8]};
            sample_b_r = {audio_fifo_write_ch_b_out_w[7:0], audio_fifo_write_ch_b_out_w[15:8]};
        end
        else
        begin
            sample_a_r = audio_fifo_write_ch_a_out_w;
            sample_b_r = audio_fifo_write_ch_b_out_w;
        end
    end
end


wire        fifo_valid_w;
wire [31:0] fifo_data_w;
reg         fifo_pop_r;
wire        fifo_accept_w;

audio_fifo
u_fifo
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.flush_i(audio_cfg_buffer_rst_out_w)

    ,.push_i(audio_fifo_write_wr_q)
    ,.data_in_i({sample_b_r, sample_a_r})
    ,.accept_o(fifo_accept_w)

    ,.valid_o(fifo_valid_w)
    ,.data_out_o(fifo_data_w)
    ,.pop_i(fifo_pop_r)
);

reg [15:0] fifo_level_q;

always @ (posedge clk_i )
if (rst_i)
    fifo_level_q <= 16'b0;
else if (audio_cfg_buffer_rst_out_w)
    fifo_level_q <= 16'b0;
// Count up
else if ((audio_fifo_write_wr_q & fifo_accept_w) & ~(fifo_pop_r & fifo_valid_w))
    fifo_level_q <= fifo_level_q + 16'd1;
// Count down
else if (~(audio_fifo_write_wr_q & fifo_accept_w) & (fifo_pop_r & fifo_valid_w))
    fifo_level_q <= fifo_level_q - 16'd1;

assign audio_status_level_in_w = fifo_level_q;
assign audio_status_full_in_w  = ~fifo_accept_w;
assign audio_status_empty_in_w = ~fifo_valid_w;

//-----------------------------------------------------------------
// Interrupt Output
//-----------------------------------------------------------------  
reg irq_q;

always @ (posedge clk_i )
if (rst_i)
    irq_q <= 1'b0;
else
    irq_q <= (audio_status_level_in_w <= audio_cfg_int_threshold_out_w);

assign intr_o = irq_q;

//-----------------------------------------------------------------
// Clock Generator
//-----------------------------------------------------------------  
reg        clk_out_q;
reg [15:0] clk_div_q;
reg [15:0] clk_div_r;
reg [31:0] fraction_q;
reg [31:0] fraction_r;

/* verilator lint_off WIDTH */
always @ *
begin
    clk_div_r = clk_div_q;
    fraction_r = fraction_q;

    case (clk_div_q)
    0 :
    begin
        clk_div_r = clk_div_q + 16'd1;
    end
    audio_clk_div_whole_cycles_out_w - 16'd1:
    begin
        if (fraction_q < (audio_clk_frac_denominator_out_w - audio_clk_frac_numerator_out_w))
        begin
            fraction_r = fraction_q + audio_clk_frac_numerator_out_w;
            clk_div_r  = 16'd0;
        end
        else
        begin
            fraction_r = fraction_q + audio_clk_frac_numerator_out_w - audio_clk_frac_denominator_out_w;
            clk_div_r = clk_div_q + 16'd1;
        end
    end
    audio_clk_div_whole_cycles_out_w:
    begin
        clk_div_r = 16'd0;
    end

    default:
    begin
        clk_div_r = clk_div_q + 16'd1;
    end
    endcase
end
/* verilator lint_on WIDTH */

always @ (posedge clk_i )
if (rst_i)
    clk_div_q <= 16'd0;
else
    clk_div_q <= clk_div_r;

always @ (posedge clk_i )
if (rst_i)
    fraction_q <= 32'd0;
else
    fraction_q <= fraction_r;

always @ (posedge clk_i )
if (rst_i)
    clk_out_q <= 1'b0;
else
    clk_out_q <= (clk_div_q == 16'd0);

//-----------------------------------------------------------------
// vol_adjust: Reduce 16-bit sample amplitude by some ammount.
// Inputs: x = input, y = volume control
// Return: Volume adjusted value
//-----------------------------------------------------------------
function [15:0] vol_adjust;
    input  [15:0] x;
    input  [2:0] y;
    reg [15:0] val;
begin 

    case (y)
   //-------------------------------
   // Max volume (Vol / 0)
   //-------------------------------
   0 : 
   begin
         val = x;
   end
   //-------------------------------
   // Volume / 2
   //-------------------------------
   1 : 
   begin
        // x >> 1
        if (x[15] == 1'b1)
             val = {1'b1,x[15:1]};
        else
             val = {1'b0,x[15:1]};
   end   
   //-------------------------------
   // Volume / 4
   //-------------------------------
   2 : 
   begin
        // x >> 2
        if (x[15] == 1'b1)
             val = {2'b11,x[15:2]};
        else
             val = {2'b00,x[15:2]};
   end
   //-------------------------------
   // Volume / 8
   //-------------------------------
   3 : 
   begin
        // x >> 3
        if (x[15] == 1'b1)
             val = {3'b111,x[15:3]};
        else
             val = {3'b000,x[15:3]};
   end
   //-------------------------------
   // Volume / 16
   //-------------------------------
   4 : 
   begin
        // x >> 4
        if (x[15] == 1'b1)
             val = {4'b1111,x[15:4]};
        else
             val = {4'b0000,x[15:4]};
   end   
   //-------------------------------
   // Volume / 32
   //-------------------------------
   5 : 
   begin
        // x >> 5
        if (x[15] == 1'b1)
             val = {5'b11111,x[15:5]};
        else
             val = {5'b00000,x[15:5]};
   end    
   //-------------------------------
   // Volume / 64
   //-------------------------------
   6 : 
   begin
        // x >> 6
        if (x[15] == 1'b1)
             val = {6'b111111,x[15:6]};
        else
             val = {6'b000000,x[15:6]};         
   end
   //-------------------------------
   // Volume / 128
   //-------------------------------
   7 : 
   begin
        // x >> 7
        if (x[15] == 1'b1)
             val = {7'b1111111,x[15:7]};
        else
             val = {7'b0000000,x[15:7]};         
   end   
   default : 
        val = x;
   endcase

   vol_adjust = val;
end
endfunction

//-----------------------------------------------------------------
// Output
//-----------------------------------------------------------------
wire [15:0] output_b_w = vol_adjust(fifo_data_w[31:16], audio_cfg_vol_ctrl_out_w);
wire [15:0] output_a_w = vol_adjust(fifo_data_w[15:0],  audio_cfg_vol_ctrl_out_w);



//-----------------------------------------------------------------
// Analog (sigma delta DAC)
//-----------------------------------------------------------------
wire analog_accept_w;

audio_dac
u_dac
(
     .clk_i(clk_i)
    ,.rst_i(rst_i)

    ,.audio_clk_i(clk_out_q && (audio_cfg_target_out_w == `TARGET_ANALOG))

    ,.inport_tvalid_i(fifo_valid_w && (audio_cfg_target_out_w == `TARGET_ANALOG))
    ,.inport_tdata_i({output_b_w, output_a_w})
    ,.inport_tstrb_i(4'hF)
    ,.inport_tdest_i(4'b0)
    ,.inport_tlast_i(1'b0)
    ,.inport_tready_o(analog_accept_w)

    ,.audio_l_o(audio_l_o)
    ,.audio_r_o(audio_r_o)
);


always @ *
begin
    fifo_pop_r = 1'b0;

    case (audio_cfg_target_out_w)
    `TARGET_ANALOG: fifo_pop_r = analog_accept_w;
    default:        fifo_pop_r = 1'b0;
    endcase
end


endmodule
