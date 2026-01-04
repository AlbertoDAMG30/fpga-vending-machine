`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2025 10:12:18 AM
// Design Name: 
// Module Name: vending_machine_fsm
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

module vending_machine_fsm(
    input clk,                  // Usaremos clk_anim3 (aprox. 2 Hz)
    input reset,                // Ahora conectado a btnc
    input btn_recoger,          // Nuevo botón BTNR para recoger producto
    input [9:0] sw,             // Switches para selección de producto
    output reg [2:0] estado_actual,
    output reg [3:0] display_data_0,
    output reg [3:0] display_data_1,
    output reg [3:0] display_data_2,
    output reg [3:0] display_data_3,
    output reg [3:0] display_data_4,
    output reg [3:0] display_data_5,
    output reg [3:0] display_data_6,  // Nuevos displays
    output reg [3:0] display_data_7,
    output reg enable_scroll = 0,     // Señal para habilitar animación
    output reg [1:0] producto_sel = 0, // Producto seleccionado
    output reg led0 = 0               // Nuevo LED para indicar dispensado
);
    // Definición de estados
    parameter INICIO = 3'b000;
    parameter SELECCION = 3'b001;
    parameter PAGO = 3'b010;
    parameter DISPENSANDO = 3'b011;
    parameter CAMBIO = 3'b100;
    
    // Variables para el manejo de pagos
    reg [10:0] precio_producto = 0;     // Precio del producto seleccionado
    reg [10:0] monto_pagado = 0;        // Dinero ingresado hasta ahora
    reg [10:0] cambio_a_devolver = 0;   // Cambio a devolver
    
    // Variables para detección de flancos
    reg sw0_anterior = 0;
    reg sw5_anterior = 0;
    reg sw6_anterior = 0;
    reg sw7_anterior = 0;
    reg btnr_anterior = 0;              // Para detectar flanco de BTNR
    
    wire sw0_flanco_positivo;
    wire sw5_flanco_positivo;
    wire sw6_flanco_positivo;
    wire sw7_flanco_positivo;
    wire btnr_flanco_positivo;          // Flanco positivo de BTNR
    
    assign sw0_flanco_positivo = sw[0] && !sw0_anterior;
    assign sw5_flanco_positivo = sw[5] && !sw5_anterior;
    assign sw6_flanco_positivo = sw[6] && !sw6_anterior;
    assign sw7_flanco_positivo = sw[7] && !sw7_anterior;
    assign btnr_flanco_positivo = btn_recoger && !btnr_anterior;
    
    // Contador para el tiempo de espera
    reg [3:0] contador = 0;
    
    // Variable para parpadeo del LED
    reg parpadeo = 0;
    
    // Variable para detectar si hay algún switch activo
    wire alguno_activo;
    assign alguno_activo = sw[1] || sw[2] || sw[3] || sw[4];
    
    // Estado actual
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estado_actual <= INICIO;
            contador <= 0;
            display_data_0 <= 4'hF; // -
            display_data_1 <= 4'hF; // -
            display_data_2 <= 4'hF; // -
            display_data_3 <= 4'hF; // -
            display_data_4 <= 4'hF; // -
            display_data_5 <= 4'hF; // -
            display_data_6 <= 4'hF; // -
            display_data_7 <= 4'hF; // -
            enable_scroll <= 0;
            producto_sel <= 0;
            precio_producto <= 0;
            monto_pagado <= 0;
            cambio_a_devolver <= 0;
            sw0_anterior <= 0;
            sw5_anterior <= 0;
            sw6_anterior <= 0;
            sw7_anterior <= 0;
            btnr_anterior <= 0;    // Inicializar estado anterior de BTNR
            led0 <= 0;             // Inicializar LED apagado
            parpadeo <= 0;         // Inicializar parpadeo
        end else begin
            // Actualizar registros de estado anterior para detección de flancos
            sw0_anterior <= sw[0];
            sw5_anterior <= sw[5];
            sw6_anterior <= sw[6];
            sw7_anterior <= sw[7];
            btnr_anterior <= btn_recoger;  // Actualizar estado anterior de BTNR
            
            case (estado_actual)
                INICIO: begin
                    // Mostrar "HOLA" en el display
                    display_data_0 <= 4'hD; // A    
                    display_data_1 <= 4'hC; // L    
                    display_data_2 <= 4'h0; // O    
                    display_data_3 <= 4'hA; // H
                    display_data_4 <= 4'hF; // - (apagado)
                    display_data_5 <= 4'hF; // - (apagado)
                    display_data_6 <= 4'hF; // - (apagado)
                    display_data_7 <= 4'hF; // - (apagado)
                    enable_scroll <= 0;
                    led0 <= 0;      // Asegurarse de que el LED está apagado
                    
                    // Incrementar contador
                    if (contador < 4) begin
                        contador <= contador + 1;
                    end else begin
                        // Después de ~2 segundos, pasar al siguiente estado
                        contador <= 0;
                        estado_actual <= SELECCION;
                    end
                end
                
                SELECCION: begin
                    // Inicializar todos los displays
                    display_data_0 <= 4'hF; // -
                    display_data_1 <= 4'hF; // -
                    display_data_2 <= 4'hF; // -
                    display_data_3 <= 4'hF; // -
                    display_data_4 <= 4'hF; // -
                    display_data_5 <= 4'hF; // -
                    display_data_6 <= 4'hF; // -
                    display_data_7 <= 4'hF; // -
                    led0 <= 0;      // Asegurarse de que el LED está apagado
                    
                    // Determinar si mostramos mensaje estático o scroll de producto
                    if (!alguno_activo) begin
                        // Mostrar "ESCOGA" cuando no hay ningún switch activo
                        display_data_0 <= 4'hE; // E
                        display_data_1 <= 4'h6; // G (usando el número 6)
                        display_data_2 <= 4'h1; // I (usando el número 1)
                        display_data_3 <= 4'hC; // L
                        display_data_4 <= 4'hE; // E 
                        enable_scroll <= 0;     // Desactivar scroll
                    end else begin
                        // Habilitar scroll para mostrar productos
                        enable_scroll <= 1;
                        
                        // Selección de producto basado en switches
                        if (sw[1]) begin
                            producto_sel <= 2'b00;      // 1. GINGER C400
                            precio_producto <= 400;     // Precio: ₡400
                        end else if (sw[2]) begin
                            producto_sel <= 2'b01;      // 2. COCA C800
                            precio_producto <= 800;     // Precio: ₡800
                        end else if (sw[3]) begin
                            producto_sel <= 2'b10;      // 3. POP C1100
                            precio_producto <= 1100;    // Precio: ₡1100
                        end else if (sw[4]) begin
                            producto_sel <= 2'b11;      // 4. GRANUTS C350
                            precio_producto <= 350;     // Precio: ₡350
                        end
                    end
                    
                    // Si se presiona el botón de confirmación, avanzar al estado de pago
                    if (sw0_flanco_positivo && alguno_activo) begin
                        estado_actual <= PAGO;
                        enable_scroll <= 0;
                        monto_pagado <= 0;  // Inicializar monto pagado
                        contador <= 0;      // Reiniciar contador
                    end
                end
                
                PAGO: begin
                            // En estado de pago, no mostrar scroll
                            enable_scroll <= 0;
                            
                            // Detectar inserción de monedas mediante flancos positivos
                            if (sw5_flanco_positivo) begin
                                monto_pagado <= monto_pagado + 50;
                            end
                            
                            if (sw6_flanco_positivo) begin
                                monto_pagado <= monto_pagado + 100;
                            end
                            
                            if (sw7_flanco_positivo) begin
                                monto_pagado <= monto_pagado + 500;
                            end
                            
                            // Displays 7,6,5,4: Mostrar el precio en millar, centenas, decenas, unidades
                            display_data_7 <= (precio_producto / 1000) % 10; // Millar
                            display_data_6 <= (precio_producto / 100) % 10;  // Centenas
                            display_data_5 <= (precio_producto / 10) % 10;   // Decenas
                            display_data_4 <= precio_producto % 10;          // Unidades
                            
                            // Displays 3,2,1,0: Mostrar el monto pagado en millar, centenas, decenas, unidades
                            display_data_3 <= (monto_pagado / 1000) % 10; // Millar
                            display_data_2 <= (monto_pagado / 100) % 10;  // Centenas
                            display_data_1 <= (monto_pagado / 10) % 10;   // Decenas
                            display_data_0 <= monto_pagado % 10;          // Unidades
                            
                            // Verificar si el monto pagado es suficiente
                            if (monto_pagado >= precio_producto) begin
                                // Calcular cambio si existe
                                if (monto_pagado > precio_producto) begin
                                    cambio_a_devolver <= monto_pagado - precio_producto;
                                end else begin
                                    cambio_a_devolver <= 0; // No hay cambio
                                end
                                
                                contador <= 0;  // Reiniciar contador
                                estado_actual <= DISPENSANDO; // Siempre ir a DISPENSANDO primero
                            end
                            
                            // Opción para cancelar y volver a SELECCION
                            if (sw0_flanco_positivo) begin
                                estado_actual <= SELECCION;
                                monto_pagado <= 0;
                            end
                        end 
                
                DISPENSANDO: begin
                    // Mostrar mensaje "LISTO"
                    display_data_7 <= 4'hF; // - (espacio vacío)
                    display_data_6 <= 4'hF; // - (espacio vacío)
                    display_data_5 <= 4'hF; // - (espacio vacío)
                    display_data_4 <= 4'hC; // L
                    display_data_3 <= 4'h1; // I (usando el número 1)
                    display_data_2 <= 4'h5; // S (usando el número 5)
                    display_data_1 <= 4'h7; // T (usando el número 7)
                    display_data_0 <= 4'h0; // O (usando el número 0)
                    
                    // Cambiar estado del LED para parpadeo
                    parpadeo <= ~parpadeo;
                    led0 <= parpadeo;
                    
                    // Esperar a que se presione el botón de recoger producto
                    if (btnr_flanco_positivo) begin
                        contador <= 0;
                        
                        // Verificar si hay cambio que devolver
                        if (cambio_a_devolver > 0) begin
                            // Si hay cambio, ir al estado de CAMBIO
                            estado_actual <= CAMBIO;
                        end else begin
                            // Si no hay cambio, volver a SELECCION
                            estado_actual <= SELECCION;
                            monto_pagado <= 0;
                        end
                        
                        led0 <= 0;  // Apagar LED cuando se recoge el producto
                    end
                end
                
               CAMBIO: begin
                        // Mostrar mensaje "CAMBIO" en los displays superiores
                        display_data_7 <= 4'hB; // C
                        display_data_6 <= 4'hD; // A
                        display_data_5 <= 4'hF; // M (usando -)
                        display_data_4 <= 4'hF; // B (usando -)
                        
                        // Mostrar el cambio en los displays inferiores (0-3) como en PAGO
                        display_data_3 <= (cambio_a_devolver / 1000) % 10; // Millar
                        display_data_2 <= (cambio_a_devolver / 100) % 10;  // Centenas
                        display_data_1 <= (cambio_a_devolver / 10) % 10;   // Decenas
                        display_data_0 <= cambio_a_devolver % 10;          // Unidades
                        
                        // En lugar de usar un contador, esperar a que se presione el botón BTNR
                        if (btnr_flanco_positivo) begin
                            // Cuando el usuario presiona el botón, volver al estado de selección
                            contador <= 0;
                            estado_actual <= SELECCION;
                            monto_pagado <= 0;
                            cambio_a_devolver <= 0; // Reiniciar el cambio a devolver
                        end 
                    end 
                
                default: estado_actual <= INICIO;
            endcase
        end
    end
endmodule
