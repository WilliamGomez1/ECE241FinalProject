module spinState (CLOCK_50, KEY, HEX5, HEX4, HEX3);

input CLOCK_50;
input [3:0] KEY;
output [6:0] HEX3, HEX4, HEX5;

wire [11:0] PlayerSpin;
wire StopKey = KEY[0];
wire state1, state2, state3, displayOff;

hexadecimalDecoder U0 (PlayerSpin[11:8], HEX5);
hexadecimalDecoder U1 (PlayerSpin[7:4], HEX4);
hexadecimalDecoder U2 (PlayerSpin[3:0], HEX3);


//FSM that records each StopKey press, gets number for each press 
//On third press, echo done back to spinstate output (should now leave spinstate)
spinFSM A1(StopKey, state1, state2, state3, displayOff);

getNUMBAH E1 (CLOCK_50, StopKey, PlayerSpin, state1, state2, state3, displayOff);
//Given a specific hotstate, what should the function do?

endmodule

module getNUMBAH(CLOCK_50, StopKey, PlayerSpin, state1, state2, state3, displayOff);
input CLOCK_50;
input StopKey;
//fsm states determine which part of the function is "looked at"
input state1, state2, state3, displayOff;
output reg [11:0] PlayerSpin;

reg [3:0]Clawk;

initial begin
		PlayerSpin <= 12'b0;
		Clawk <= 4'b0;
	end

wire reset;
assign reset = (Clawk == 4'b0)?1:0;

//Every time Clawk hits 0, it resets to 16.
//If Clawk != 0, subtract 1 from Clawk
always @(posedge CLOCK_50)
	begin
		if (reset)
			Clawk <= 4'b1111;
		else
            Clawk <= Clawk - 1'b1;
    end

parameter	
    ZERO = 4'b0000, 
	ONE = 4'b0001, 
    TWO = 4'b0010, 
	THREE = 4'b0011, 
	FOUR = 4'b0100,
	FIVE = 4'b0101, 
	SIX = 4'b0110, 
	SEVEN = 4'b0111, 
	ATE = 4'b1000,
    NINE = 4'b1001,
    A = 4'b1010,
    B = 4'b1011,
    C = 4'b1100,
    D = 4'b1101,
    E = 4'b1110,
    F = 4'b1111;
//input 50MHz clock, split it into 16 different parts
always @(posedge StopKey)
	begin
        case (Clawk)
			ZERO: if(state1) PlayerSpin[11:8] <= ZERO;
			else if(state2) PlayerSpin[7:4] <= ZERO;
			else if(state3) PlayerSpin[3:0] <= ZERO;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            ONE: if(state1) PlayerSpin[11:8] <= ONE;
			else if(state2) PlayerSpin[7:4] <= ONE;
			else if(state3) PlayerSpin[3:0] <= ONE;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            TWO: if(state1) PlayerSpin[11:8] <= TWO;
			else if(state2) PlayerSpin[7:4] <= TWO;
			else if(state3) PlayerSpin[3:0] <= TWO;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            THREE: if(state1) PlayerSpin[11:8] <= THREE;
			else if(state2) PlayerSpin[7:4] <= THREE;
			else if(state3) PlayerSpin[3:0] <= THREE;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            FOUR: if(state1) PlayerSpin[11:8] <= FOUR;
			else if(state2) PlayerSpin[7:4] <= FOUR;
			else if(state3) PlayerSpin[3:0] <= FOUR;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            FIVE: if(state1) PlayerSpin[11:8] <= FIVE;
			else if(state2) PlayerSpin[7:4] <= FIVE;
			else if(state3) PlayerSpin[3:0] <= FIVE;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            SIX: if(state1) PlayerSpin[11:8] <= SIX;
			else if(state2) PlayerSpin[7:4] <= SIX;
			else if(state3) PlayerSpin[3:0] <= SIX;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            SEVEN: if(state1) PlayerSpin[11:8] <= SEVEN;
			else if(state2) PlayerSpin[7:4] <= SEVEN;
			else if(state3) PlayerSpin[3:0] <= SEVEN;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            ATE: if(state1) PlayerSpin[11:8] <= ATE;
			else if(state2) PlayerSpin[7:4] <= ATE;
			else if(state3) PlayerSpin[3:0] <= ATE;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            NINE: if(state1) PlayerSpin[11:8] <= NINE;
			else if(state2) PlayerSpin[7:4] <= NINE;
			else if(state3) PlayerSpin[3:0] <= NINE;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            A: if(state1) PlayerSpin[11:8] <= A;
			else if(state2) PlayerSpin[7:4] <= A;
			else if(state3) PlayerSpin[3:0] <= A;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            B: if(state1) PlayerSpin[11:8] <= B;
			else if(state2) PlayerSpin[7:4] <= B;
			else if(state3) PlayerSpin[3:0] <= B;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            C: if(state1) PlayerSpin[11:8] <= C;
			else if(state2) PlayerSpin[7:4] <= C;
			else if(state3) PlayerSpin[3:0] <= C;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            D: if(state1) PlayerSpin[11:8] <= D;
			else if(state2) PlayerSpin[7:4] <= D;
			else if(state3) PlayerSpin[3:0] <= D;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            E: if(state1) PlayerSpin[11:8] <= E;
			else if(state2) PlayerSpin[7:4] <= E;
			else if(state3) PlayerSpin[3:0] <= E;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
            F: if(state1) PlayerSpin[11:8] <= F;
			else if(state2) PlayerSpin[7:4] <= F;
			else if(state3) PlayerSpin[3:0] <= F;
			else if(displayOff) PlayerSpin[11:0] <= 12'b000000000000;
        default: PlayerSpin[11:0] = 12'b000000000000;
        endcase
    end

endmodule

module spinFSM (StopKey, state1, state2, state3, displayOff);
input StopKey;
output state1, state2, state3, displayOff;

reg [3:0] y_Q, Y_D; // y_Q = current state, Y_D = next state

initial begin
		y_Q <= 4'b0;
	end

parameter [3:0]	None = 4'b0001, Once = 4'b0010, Twice = 4'b0100, Done = 4'b1000;
always@(y_Q)
	begin
		case (y_Q)
			None: Y_D = Once;
			Once: Y_D = Twice;
			Twice: Y_D = Done;
			Done: Y_D = None; //you should never stay here!
        default: Y_D = None;
    endcase
end
//cant assign a reg to more than one always block

	always @(negedge StopKey)
		begin
		y_Q<=Y_D;
		end

assign state1 = y_Q[1];
assign state2 = y_Q[2];
assign state3 = y_Q[3];
assign displayOff = y_Q[0];

endmodule

module hexadecimalDecoder(input [3:0] c, output [6:0] hex);

    wire [6:0] h;
    assign h[0] = (~c[2]&~c[0]) | (c[1]&c[2]) | (c[1]&~c[3]) | (c[0]&~c[3]&c[2]) | (~c[1]&~c[0]&c[3]) | (c[3]&~c[2]&~c[1]);
    assign h[1] = (~c[2] & ~c[0]) | (~c[3] & ~c[2]) | (~c[1] & c[0] & c[3]) | (~c[0] & ~c[1] & ~c[3]) | (c[1] & c[0] & ~c[3]);
    assign h[2] = (c[3] & ~c[2]) | (~c[3] & c[2]) | (c[0] & ~c[3]) | (~c[1] & ~c[3]) | (c[0] & ~c[1]);
    assign h[3] = (~c[1] & ~c[0] & c[3]) | (~c[0] & ~c[1] & ~c[2]) | (c[1] & ~c[2] & ~c[3]) | (c[0] & ~c[1] & c[2]) | (~c[0] & c[1] & c[2]) | (c[0] & c[1] & ~c[2]);
    assign h[4] = (~c[0] & ~c[2]) | (c[2] & c[3]) | (~c[0] & c[1]) | (c[1] & c[3]);
    assign h[5] = (~c[0] & ~c[1]) | (~c[2] & c[3]) | (c[1] & c[3]) | (~c[0] & c[1] & c[2]) | (~c[1] & c[2] & ~c[3]);
    assign h[6] = (~c[0] & c[1]) | (c[1] & ~c[2]) | (c[3] & ~c[2]) | (c[0] & c[3]) | (c[2] & ~c[1] & ~c[3]);

    assign hex = ~h;

endmodule
