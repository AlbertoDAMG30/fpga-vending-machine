`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2025 05:59:09 AM
// Design Name: 
// Module Name: divisor_reloj
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

module divisor_reloj(
    input clk,                      // Reloj de 100 MHz
    output reg clk_slow = 0,       // multiplexado
    output reg clk_anim1 = 0,      // anim1
    output reg clk_anim2 = 0,      // anim2
    output reg clk_anim3 = 0       // anim3
);
    reg [26:0] contador = 0;

    always @(posedge clk) begin
        contador <= contador + 1;
        clk_slow   <= contador[13]; 
        clk_anim1  <= contador[25];  // 1.5 Hz
        clk_anim2  <= contador[23];  // 6 Hz
        clk_anim3  <= contador[24];  // ~2 Hz (ajustar según necesidad)
    end
endmodule




