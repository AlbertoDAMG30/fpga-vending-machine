`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 
// Design Name: 
// Module Name: main
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

module main(
    input clk,
    input btnc,              // Botón BTNC como reset
    input btnr,              // Nuevo botón BTNR para recoger producto
    input [9:0] sw,
    output [6:0] segmentos,
    output [7:0] anodos,
    output led0              // Nuevo LED0 para indicar dispensado
);

    // Señales internas
    wire clk_slow;
    wire clk_anim1;
    wire clk_anim2;
    wire clk_anim3;
    wire [2:0] estado_actual;
    wire [3:0] display_data_0;
    wire [3:0] display_data_1;
    wire [3:0] display_data_2;
    wire [3:0] display_data_3;
    wire [3:0] display_data_4;
    wire [3:0] display_data_5;
    wire [3:0] display_data_6;
    wire [3:0] display_data_7;
    wire enable_scroll;
    wire [1:0] producto_sel;
    
    wire [6:0] segmentos_fsm;
    wire [7:0] anodos_fsm;
    wire [6:0] segmentos_scroll;
    wire [7:0] anodos_scroll;
    
    reg [2:0] sel = 0; // 3 bits para manejar 8 displays (0-7)
    
    // Divisor de reloj
    divisor_reloj divisor(
        .clk(clk),
        .clk_slow(clk_slow),
        .clk_anim1(clk_anim1),
        .clk_anim2(clk_anim2),
        .clk_anim3(clk_anim3)
    );
    
    // Máquina de estados con botón de recoger producto y LED
    vending_machine_fsm fsm(
        .clk(clk_anim3),
        .reset(btnc),
        .btn_recoger(btnr),        // Conectar el nuevo botón BTNR
        .sw(sw),
        .estado_actual(estado_actual),
        .display_data_0(display_data_0),
        .display_data_1(display_data_1),
        .display_data_2(display_data_2),
        .display_data_3(display_data_3),
        .display_data_4(display_data_4),
        .display_data_5(display_data_5),
        .display_data_6(display_data_6),
        .display_data_7(display_data_7),
        .enable_scroll(enable_scroll),
        .producto_sel(producto_sel),
        .led0(led0)                // Conectar la señal del LED0
    );
    
    // Controlador de display normal (para estados sin scroll)
    display_controller display(
        .digit0(display_data_0),
        .digit1(display_data_1),
        .digit2(display_data_2),
        .digit3(display_data_3),
        .digit4(display_data_4),
        .digit5(display_data_5),
        .digit6(display_data_6),
        .digit7(display_data_7),
        .sel(sel[2:0]),
        .segmentos(segmentos_fsm)
    );
    
    // Multiplexado de displays normales
    always @(posedge clk_slow) begin
        sel <= sel + 1;
        if (sel == 3'b111) // Resetear después del octavo display
            sel <= 3'b000;
    end
    
    // Asignación de anodos para display normal (8 displays)
    assign anodos_fsm = (sel == 3'b000) ? 8'b11111110 :
                        (sel == 3'b001) ? 8'b11111101 :
                        (sel == 3'b010) ? 8'b11111011 :
                        (sel == 3'b011) ? 8'b11110111 :
                        (sel == 3'b100) ? 8'b11101111 :
                        (sel == 3'b101) ? 8'b11011111 :
                        (sel == 3'b110) ? 8'b10111111 :
                        (sel == 3'b111) ? 8'b01111111 : 8'b11111111;
    
    // Módulo de scroll para productos
    producto_scroll scroll(
        .clk_slow(clk_slow),
        .clk_anim(clk_anim3),
        .enable(enable_scroll),
        .producto_sel(producto_sel),
        .segmentos(segmentos_scroll),
        .anodos(anodos_scroll)
    );
    
    // Multiplexor final entre displays normales y scroll
    assign segmentos = enable_scroll ? segmentos_scroll : segmentos_fsm;
    assign anodos = enable_scroll ? anodos_scroll : anodos_fsm;
    
endmodule
