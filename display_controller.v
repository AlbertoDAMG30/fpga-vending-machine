`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 10:16:56 AM
// Design Name: 
// Module Name: display_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module display_controller(
    input [3:0] digit0,
    input [3:0] digit1, 
    input [3:0] digit2,
    input [3:0] digit3,
    input [3:0] digit4,
    input [3:0] digit5,
    input [3:0] digit6,  // Nuevos displays
    input [3:0] digit7,
    input [2:0] sel,
    output reg [6:0] segmentos
);
    
    // Función para convertir un dígito a su representación en 7 segmentos
    function [6:0] digit_to_segments;
        input [3:0] digit;
        begin
            case(digit)
                4'h0: digit_to_segments = 7'b1000000; // 0
                4'h1: digit_to_segments = 7'b1111001; // 1
                4'h2: digit_to_segments = 7'b0100100; // 2
                4'h3: digit_to_segments = 7'b0110000; // 3
                4'h4: digit_to_segments = 7'b0011001; // 4
                4'h5: digit_to_segments = 7'b0010010; // 5
                4'h6: digit_to_segments = 7'b0000010; // 6
                4'h7: digit_to_segments = 7'b1111000; // 7
                4'h8: digit_to_segments = 7'b0000000; // 8
                4'h9: digit_to_segments = 7'b0010000; // 9
                4'hA: digit_to_segments = 7'b0001001; // H
                4'hB: digit_to_segments = 7'b1000110; // C
                4'hC: digit_to_segments = 7'b1000111; // L
                4'hD: digit_to_segments = 7'b0001000; // A
                4'hE: digit_to_segments = 7'b0000110; // E
                4'hF: digit_to_segments = 7'b0111111; // -
                default: digit_to_segments = 7'b1111111; // Apagado
            endcase
        end
    endfunction
    
    // Conversor de dígitos a segmentos según el dígito seleccionado
    always @* begin
        case(sel)
            3'b000: segmentos = digit_to_segments(digit0);
            3'b001: segmentos = digit_to_segments(digit1);
            3'b010: segmentos = digit_to_segments(digit2);
            3'b011: segmentos = digit_to_segments(digit3);
            3'b100: segmentos = digit_to_segments(digit4);
            3'b101: segmentos = digit_to_segments(digit5);
            3'b110: segmentos = digit_to_segments(digit6);
            3'b111: segmentos = digit_to_segments(digit7);
            default: segmentos = 7'b1111111; // Todos apagados
        endcase
    end
endmodule
