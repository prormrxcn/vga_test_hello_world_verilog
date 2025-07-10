module vga_controller(
    input wire clk,         // 100 MHz clock from Basys 3
    input wire rst,
    output wire hsync,
    output wire vsync,
    output wire [3:0] red,
    output wire [3:0] green,
    output wire [3:0] blue
);
    // VGA 640x480 @ 60Hz Timing Parameters
    localparam H_DISPLAY = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC_PULSE = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_TOTAL = H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH; // 800
    
    localparam V_DISPLAY = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC_PULSE = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_TOTAL = V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH; // 525
    
    // Pixel clock generation (25 MHz from 100 MHz)
    reg [1:0] clk_div = 0;
    always @(posedge clk) begin
        if (rst)
            clk_div <= 0;
        else
            clk_div <= clk_div + 1;
    end
    wire pix_clk = clk_div[1];
    
    // Horizontal and vertical counters
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;
    
    always @(posedge pix_clk) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else
                h_count <= h_count + 1;
        end
    end
    
    // Sync signal generation with proper timing
    assign hsync = ~((h_count >= (H_DISPLAY + H_FRONT_PORCH)) && 
                     (h_count < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE)));
    assign vsync = ~((v_count >= (V_DISPLAY + V_FRONT_PORCH)) && 
                     (v_count < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE)));
    
    // Video enable signal
    wire video_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    
    // Character bitmap lookup table - Fixed syntax
    function [7:0] char_bitmap;
        input [3:0] char_code;
        input [2:0] row;
        begin
            case (char_code)
                4'd0: begin // H
                    case(row)
                        3'd0: char_bitmap = 8'b01100110;
                        3'd1: char_bitmap = 8'b01100110;
                        3'd2: char_bitmap = 8'b01100110;
                        3'd3: char_bitmap = 8'b01111110;
                        3'd4: char_bitmap = 8'b01100110;
                        3'd5: char_bitmap = 8'b01100110;
                        3'd6: char_bitmap = 8'b01100110;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd1: begin // E
                    case(row)
                        3'd0: char_bitmap = 8'b01111110;
                        3'd1: char_bitmap = 8'b01100000;
                        3'd2: char_bitmap = 8'b01100000;
                        3'd3: char_bitmap = 8'b01111100;
                        3'd4: char_bitmap = 8'b01100000;
                        3'd5: char_bitmap = 8'b01100000;
                        3'd6: char_bitmap = 8'b01111110;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd2: begin // L
                    case(row)
                        3'd0: char_bitmap = 8'b01100000;
                        3'd1: char_bitmap = 8'b01100000;
                        3'd2: char_bitmap = 8'b01100000;
                        3'd3: char_bitmap = 8'b01100000;
                        3'd4: char_bitmap = 8'b01100000;
                        3'd5: char_bitmap = 8'b01100000;
                        3'd6: char_bitmap = 8'b01111110;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd3: begin // O
                    case(row)
                        3'd0: char_bitmap = 8'b00111100;
                        3'd1: char_bitmap = 8'b01100110;
                        3'd2: char_bitmap = 8'b01100110;
                        3'd3: char_bitmap = 8'b01100110;
                        3'd4: char_bitmap = 8'b01100110;
                        3'd5: char_bitmap = 8'b01100110;
                        3'd6: char_bitmap = 8'b00111100;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd4: begin // W
                    case(row)
                        3'd0: char_bitmap = 8'b11000011;
                        3'd1: char_bitmap = 8'b11000011;
                        3'd2: char_bitmap = 8'b11000011;
                        3'd3: char_bitmap = 8'b11011011;
                        3'd4: char_bitmap = 8'b11011011;
                        3'd5: char_bitmap = 8'b11111111;
                        3'd6: char_bitmap = 8'b01100110;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd5: begin // R
                    case(row)
                        3'd0: char_bitmap = 8'b01111100;
                        3'd1: char_bitmap = 8'b01100110;
                        3'd2: char_bitmap = 8'b01100110;
                        3'd3: char_bitmap = 8'b01111100;
                        3'd4: char_bitmap = 8'b01101100;
                        3'd5: char_bitmap = 8'b01100110;
                        3'd6: char_bitmap = 8'b01100110;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd6: begin // D
                    case(row)
                        3'd0: char_bitmap = 8'b01111000;
                        3'd1: char_bitmap = 8'b01101100;
                        3'd2: char_bitmap = 8'b01100110;
                        3'd3: char_bitmap = 8'b01100110;
                        3'd4: char_bitmap = 8'b01100110;
                        3'd5: char_bitmap = 8'b01101100;
                        3'd6: char_bitmap = 8'b01111000;
                        3'd7: char_bitmap = 8'b00000000;
                    endcase
                end
                4'd7: begin // space
                    char_bitmap = 8'b00000000;
                end
                default: char_bitmap = 8'b00000000;
            endcase
        end
    endfunction
    
    // Text string: "HELLO WORLD"
    wire [3:0] text_string [0:10];
    assign text_string[0] = 4'd0;  // H
    assign text_string[1] = 4'd1;  // E
    assign text_string[2] = 4'd2;  // L
    assign text_string[3] = 4'd2;  // L
    assign text_string[4] = 4'd3;  // O
    assign text_string[5] = 4'd7;  // space
    assign text_string[6] = 4'd4;  // W
    assign text_string[7] = 4'd3;  // O
    assign text_string[8] = 4'd5;  // R
    assign text_string[9] = 4'd2;  // L
    assign text_string[10] = 4'd6; // D
    
    // Character scaling for better visibility (4x scale)
    localparam SCALE = 4;
    localparam CHAR_WIDTH = 8 * SCALE;
    localparam CHAR_HEIGHT = 8 * SCALE;
    localparam TEXT_WIDTH = 11 * CHAR_WIDTH;
    localparam TEXT_HEIGHT = CHAR_HEIGHT;
    
    // Center the text on screen
    localparam TEXT_START_X = (H_DISPLAY - TEXT_WIDTH) / 2;
    localparam TEXT_START_Y = (V_DISPLAY - TEXT_HEIGHT) / 2;
    
    // Text rendering logic
    wire [9:0] text_x = h_count - TEXT_START_X;
    wire [9:0] text_y = v_count - TEXT_START_Y;
    wire text_region = (h_count >= TEXT_START_X) && (h_count < TEXT_START_X + TEXT_WIDTH) &&
                       (v_count >= TEXT_START_Y) && (v_count < TEXT_START_Y + TEXT_HEIGHT);
    
    wire [3:0] char_index = text_x / CHAR_WIDTH;
    wire [2:0] pixel_x = (text_x % CHAR_WIDTH) / SCALE;
    wire [2:0] pixel_y = (text_y % CHAR_HEIGHT) / SCALE;
    
    wire [7:0] char_data = char_bitmap(text_string[char_index], pixel_y);
    wire char_pixel = char_data[7 - pixel_x];
    
    // Beautiful gradient background
    wire [7:0] bg_red = h_count[7:4];
    wire [7:0] bg_green = v_count[7:4] ^ h_count[7:4];
    wire [7:0] bg_blue = v_count[7:4];
    
    // Color animation based on position
    reg [3:0] text_red, text_green, text_blue;
    always @(*) begin
        case (char_index % 3)
            0: begin // Cyan text
                text_red = 4'h0;
                text_green = 4'hF;
                text_blue = 4'hF;
            end
            1: begin // Yellow text
                text_red = 4'hF;
                text_green = 4'hF;
                text_blue = 4'h0;
            end
            2: begin // Magenta text
                text_red = 4'hF;
                text_green = 4'h0;
                text_blue = 4'hF;
            end
            default: begin
                text_red = 4'hF;
                text_green = 4'hF;
                text_blue = 4'hF;
            end
        endcase
    end
    
    // Final color output with beautiful gradients
    assign red = video_on ? (text_region && char_pixel ? text_red : bg_red[7:4]) : 4'h0;
    assign green = video_on ? (text_region && char_pixel ? text_green : bg_green[7:4]) : 4'h0;
    assign blue = video_on ? (text_region && char_pixel ? text_blue : bg_blue[7:4]) : 4'h0;

endmodule