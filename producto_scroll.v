`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 02:47:14 PM
// Design Name: 
// Module Name: producto_scroll
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

module producto_scroll(
    input clk_slow,         // 190 Hz (multiplexado)
    input clk_anim,         // 2 Hz (velocidad del scroll)
    input enable,
    input [1:0] producto_sel,  // Selección de producto
    output reg [6:0] segmentos,
    output reg [7:0] anodos
);
    // ROM con mensajes de productos para el scroll
    reg [6:0] prod1_rom [0:21]; // "1.GINGER C400"
    reg [6:0] prod2_rom [0:21]; // "2.COCA C800"
    reg [6:0] prod3_rom [0:21]; // "3.POP C1100"
    reg [6:0] prod4_rom [0:21]; // "4.GRANUTS C350"
    
    initial begin
        // 1. GINGER C400 + espacios
        prod1_rom[0]  = 7'b1111001; // 1 (gfedcba)
        prod1_rom[1]  = 7'b1111110; // . (punto)
        prod1_rom[2]  = 7'b1000010; // G 
        prod1_rom[3]  = 7'b1001111; // I
        prod1_rom[4]  = 7'b0101011; // N
        prod1_rom[5]  = 7'b1000010; // G
        prod1_rom[6]  = 7'b0110000; // E
        prod1_rom[7]  = 7'b0101111; // R
        prod1_rom[8]  = 7'b1111111; // espacio
        prod1_rom[9] = 7'b1000110; // C
        prod1_rom[10] = 7'b0011001; // 4
        prod1_rom[11] = 7'b1000000; // 0
        prod1_rom[12] = 7'b1000000; // 0
        prod1_rom[13] = 7'b1111111; // espacio
        prod1_rom[14] = 7'b1111111; // espacio
        prod1_rom[15] = 7'b1111111; // espacio
        prod1_rom[16] = 7'b1111111; // espacio
        prod1_rom[17] = 7'b1111111; // espacio
        prod1_rom[18] = 7'b1111111; // espacio
        prod1_rom[19] = 7'b1111111; // espacio
        prod1_rom[20] = 7'b1111111; // espacio
        prod1_rom[21] = 7'b1111111; // espacio
        
        // 2. COCA C800 + espacios
        prod2_rom[0]  = 7'b0100100; // 2
        prod2_rom[1]  = 7'b1111110; // .
        prod2_rom[2]  = 7'b1000110; // C
        prod2_rom[3]  = 7'b1000000; // O
        prod2_rom[4]  = 7'b1000110; // C
        prod2_rom[5]  = 7'b0001000; // A
        prod2_rom[6]  = 7'b1111111; // espacio
        prod2_rom[7]  = 7'b1000110; // C
        prod2_rom[8]  = 7'b0000000; // 8
        prod2_rom[9] = 7'b1000000; // 0
        prod2_rom[10] = 7'b1000000; // 0
        prod2_rom[11] = 7'b1111111; // espacio
        prod2_rom[12] = 7'b1111111; // espacio
        prod2_rom[13] = 7'b1111111; // espacio
        prod2_rom[14] = 7'b1111111; // espacio
        prod2_rom[15] = 7'b1111111; // espacio
        prod2_rom[16] = 7'b1111111; // espacio
        prod2_rom[17] = 7'b1111111; // espacio
        prod2_rom[18] = 7'b1111111; // espacio
        prod2_rom[19] = 7'b1111111; // espacio
        prod2_rom[20] = 7'b1111111; // espacio
        prod2_rom[21] = 7'b1111111; // espacio
        
        // 3. POP C1100 + espacios
        prod3_rom[0]  = 7'b0110000; // 3
        prod3_rom[1]  = 7'b1111110; // .
        prod3_rom[2]  = 7'b0001100; // P
        prod3_rom[3]  = 7'b1000000; // O
        prod3_rom[4]  = 7'b0001100; // P
        prod3_rom[5]  = 7'b1111111; // espacio
        prod3_rom[6]  = 7'b1000110; // C
        prod3_rom[7]  = 7'b1111001; // 1
        prod3_rom[8]  = 7'b1111001; // 1
        prod3_rom[9] = 7'b1000000; // 0
        prod3_rom[10] = 7'b1000000; // 0
        prod3_rom[11] = 7'b1111111; // espacio
        prod3_rom[12] = 7'b1111111; // espacio
        prod3_rom[13] = 7'b1111111; // espacio
        prod3_rom[14] = 7'b1111111; // espacio
        prod3_rom[15] = 7'b1111111; // espacio
        prod3_rom[16] = 7'b1111111; // espacio
        prod3_rom[17] = 7'b1111111; // espacio
        prod3_rom[18] = 7'b1111111; // espacio
        prod3_rom[19] = 7'b1111111; // espacio
        prod3_rom[20] = 7'b1111111; // espacio
        prod3_rom[21] = 7'b1111111; // espacio
        
        // 4. GRANUTS C350 + espacios
        prod4_rom[0]  = 7'b0011001; // 4
        prod4_rom[1]  = 7'b1111110; // .
        prod4_rom[2]  = 7'b1000010; // G
        prod4_rom[3]  = 7'b0101111; // R
        prod4_rom[4]  = 7'b0001000; // A
        prod4_rom[5]  = 7'b0101011; // N
        prod4_rom[6]  = 7'b1000001; // U
        prod4_rom[7]  = 7'b1001110; // T
        prod4_rom[8]  = 7'b0010010; // S
        prod4_rom[9] = 7'b1111111; // espacio
        prod4_rom[10] = 7'b1000110; // C
        prod4_rom[11] = 7'b0110000; // 3
        prod4_rom[12] = 7'b0010010; // 5
        prod4_rom[13] = 7'b1000000; // 0
        prod4_rom[14] = 7'b1111111; // espacio
        prod4_rom[15] = 7'b1111111; // espacio
        prod4_rom[16] = 7'b1111111; // espacio
        prod4_rom[17] = 7'b1111111; // espacio
        prod4_rom[18] = 7'b1111111; // espacio
        prod4_rom[19] = 7'b1111111; // espacio
        prod4_rom[20] = 7'b1111111; // espacio
        prod4_rom[21] = 7'b1111111; // espacio
    end

    reg [4:0] offset = 0;  // Controla el inicio del scroll
    reg [2:0] display = 0; // Display actual
    reg [6:0] buffer [0:7]; // Buffer para 8 displays
    reg prev_clk_anim;

    // Actualizar offset con clk_anim - CAMBIO DE DIRECCIÓN DEL SCROLL
    always @(posedge clk_slow) begin
        prev_clk_anim <= clk_anim;
        
        if (enable && prev_clk_anim == 0 && clk_anim == 1) begin
            // Para scroll de derecha a izquierda, decrementamos el offset en lugar de incrementarlo
            if (offset == 21)
                offset <= 0;  // Vuelve al final cuando llega a 0
            else
                offset <= offset + 1;  // Decrementa para mover de derecha a izquierda
        end

        // Cargar buffer con desplazamiento según el producto seleccionado
        case (producto_sel)
            2'b00: begin // GINGER
                // Para desplazamiento de derecha a izquierda, invertimos el orden
                buffer[7] <= prod1_rom[(offset) % 22];
                buffer[6] <= prod1_rom[(offset + 1) % 22];
                buffer[5] <= prod1_rom[(offset + 2) % 22];
                buffer[4] <= prod1_rom[(offset + 3) % 22];
                buffer[3] <= prod1_rom[(offset + 4) % 22];
                buffer[2] <= prod1_rom[(offset + 5) % 22];
                buffer[1] <= prod1_rom[(offset + 6) % 22];
                buffer[0] <= prod1_rom[(offset + 7) % 22];
            end
            2'b01: begin // COCA
                buffer[7] <= prod2_rom[(offset) % 22];
                buffer[6] <= prod2_rom[(offset + 1) % 22];
                buffer[5] <= prod2_rom[(offset + 2) % 22];
                buffer[4] <= prod2_rom[(offset + 3) % 22];
                buffer[3] <= prod2_rom[(offset + 4) % 22];
                buffer[2] <= prod2_rom[(offset + 5) % 22];
                buffer[1] <= prod2_rom[(offset + 6) % 22];
                buffer[0] <= prod2_rom[(offset + 7) % 22];
            end
            2'b10: begin // POP
                buffer[7] <= prod3_rom[(offset) % 22];
                buffer[6] <= prod3_rom[(offset + 1) % 22];
                buffer[5] <= prod3_rom[(offset + 2) % 22];
                buffer[4] <= prod3_rom[(offset + 3) % 22];
                buffer[3] <= prod3_rom[(offset + 4) % 22];
                buffer[2] <= prod3_rom[(offset + 5) % 22];
                buffer[1] <= prod3_rom[(offset + 6) % 22];
                buffer[0] <= prod3_rom[(offset + 7) % 22];
            end
            2'b11: begin // GRANUTS
                buffer[7] <= prod4_rom[(offset) % 22];
                buffer[6] <= prod4_rom[(offset + 1) % 22];
                buffer[5] <= prod4_rom[(offset + 2) % 22];
                buffer[4] <= prod4_rom[(offset + 3) % 22];
                buffer[3] <= prod4_rom[(offset + 4) % 22];
                buffer[2] <= prod4_rom[(offset + 5) % 22];
                buffer[1] <= prod4_rom[(offset + 6) % 22];
                buffer[0] <= prod4_rom[(offset + 7) % 22];
            end
        endcase
    end

    // Multiplexar displays - USAR LOS 8 DISPLAYS
    always @(posedge clk_slow) begin
        if (enable) begin
            case (display)
                // Usando todos los displays (anodos[0:7])
                0: begin anodos = 8'b11111110; segmentos = buffer[0]; end // Anodo[0]
                1: begin anodos = 8'b11111101; segmentos = buffer[1]; end // Anodo[1]
                2: begin anodos = 8'b11111011; segmentos = buffer[2]; end // Anodo[2]
                3: begin anodos = 8'b11110111; segmentos = buffer[3]; end // Anodo[3]
                4: begin anodos = 8'b11101111; segmentos = buffer[4]; end // Anodo[4]
                5: begin anodos = 8'b11011111; segmentos = buffer[5]; end // Anodo[5]
                6: begin anodos = 8'b10111111; segmentos = buffer[6]; end // Anodo[6]
                7: begin anodos = 8'b01111111; segmentos = buffer[7]; end // Anodo[7]
            endcase
            display <= (display == 7) ? 0 : display + 1;  // Incremento hasta 7 para los 8 displays
        end else begin
            anodos <= 8'b11111111;
            segmentos <= 7'b1111111;
            display <= 0;
        end
    end
endmodule
