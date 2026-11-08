//////////////////////////////////////////////////////////////////////////////////////////////////
//Company: ITESO                                                                                //
//Engineer: Ricardo Ruiz Ambriz                                                                 //
//Module description: This module describes a finite 3 state machine for loading the A, B and   //
//operation inputs. It controls the registers and the input demultiplexer according to Load. 	//
//Date: 09/28/2026                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////
module FSM2(
//Entradas
    input   clk,
    input   rst,
    input   Load,
	 input	enable,
//Salidas
    output reg  en_A,
    output reg  en_B,
    //output reg  en_CTRL,  
	 output reg [1:0]  sel
);

    // Estados
    //parameter IDLE     = 2'b00; pobresito no lo pude usar :(
    parameter LOAD_A   = 2'b01;
    parameter LOAD_B   = 2'b10;
    parameter LOAD_OP   = 2'b11;
    //parameter LOAD_CTRL = 2'b11;pobresito no lo pude usar :(

	 
reg [1:0] current_state = LOAD_A;
reg [1:0] next_state;  

// Circuito combinacional entrada, define siguiente estado
always @(*) begin
   case(current_state)
		/*
		IDLE:
			begin
				if (1'b0 == Load && enable) 			
					next_state = LOAD_A;
				else														
					next_state = IDLE;
      	end
		*/
		LOAD_A:
			begin
				if (1'b0 == Load && enable) 			
					next_state = LOAD_B;
				else													
					next_state = LOAD_A;
      	end
		LOAD_B:
			begin
				if (1'b0 == Load && enable) 			
					next_state = LOAD_OP;
				else														
					next_state = LOAD_B;
      	end
			
		LOAD_OP:
			begin
				if (1'b0 == Load && enable) 			
					next_state = LOAD_A;
				else													
					next_state = LOAD_OP;
      	end
			
		default:
				next_state = current_state;
   endcase
end


// Registros or flop array
always@(posedge clk or negedge rst) // Circuito Secuencial en un proceso always.
begin
   if (!rst)
      current_state  <= LOAD_A;//Inicia por defecto cargando el dato A.
	else if (!Load && enable)//Aquí cambia de estado única y solamente cando se presiona LOAD y cuando el enable está en 1'b1.
		 current_state <= next_state;
end

// CTO combinacional de salida.
always@(*)begin
		en_A    = 1'b0;
		en_B    = 1'b0;
		//en_CTRL = 1'b0;
		sel     = 2'b00;
	case(current_state)
		/*
		IDLE:
			begin
			en_A    = 1'b0;
			en_B    = 1'b0;
			//en_CTRL = 1'b0;
			sel     = 2'b00;
			end
			*/
		LOAD_A:
			begin
			en_A    = 1'b1;//Prende registro A
			en_B    = 1'b0;
			//en_CTRL = 1'b0;
			sel     = 2'b00;
      	end
		LOAD_B:
			begin
			en_A    = 1'b0;
			en_B    = 1'b1;//Prende registro B
			//en_CTRL = 1'b0;
			sel     = 2'b01;
      	end
		LOAD_OP:
			begin
			en_A    = 1'b0;//Apaga los dos enable para que ya no se active el registro y se queden guardados A y B
			en_B    = 1'b0;
			sel     = 2'b10;
      	end
	endcase
end

endmodule
