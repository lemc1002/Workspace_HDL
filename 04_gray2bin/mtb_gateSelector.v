// Code your testbench here
// or browse Examples
module mtb_gateSelector();
  parameter GATE_TYPE=1;
  
  reg a,b;
  wire x;
  
  gateSelector dut(a,b,x);
  
  // Aqui hacemos drive de las entradas
  initial begin
    #10;
    {a,b} = 2'h0; // Le asigno 6b en hexadecimal 0 a las entradas
    
    forever begin
      #10 {a,b}={a,b}+2'h1;
      
      // Detenemos la sim al volver a iniciar las combinaciones
      if ({a,b}==2'h0) $stop;
    end
  end
  
 
  // Para generar formas de onda
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
   
 
endmodule
    