module coinInput (SW, LEDR);
input [0:0] SW;
output [9:0] LEDR;

wire maxbetselectorBUTTON = SW[0];
wire [16:0] ogScore = 17'd10;
wire [16:0] newScore;
assign LEDR[9:5] = ogScore[4:0];
assign LEDR[4:0] = newScore[4:0];

playerCOIN L1(maxbetselectorBUTTON, ogScore, newScore);

endmodule 

module playerCOIN(maxbetselectorBUTTON, ogScore, newScore);

    // Inputs
	 
	 //button that selects if max bet or single bet
    input maxbetselectorBUTTON;
    
	 //current player score passed into function
	 input [16:0] ogScore;
    
    // Output new score
    output [16:0] newScore;
    
    // Internal wire for selected subtraction output
    wire [16:0] subtractedScore;

    // Instantiate the 2-to-1 MUX to select between max and single bet subtraction
    twotooneMUX U1 (maxbetselectorBUTTON, ogScore, subtractedScore);

    assign newScore = subtractedScore;

endmodule


module twotooneMUX(Button, inputscore, outputscore);

    // Inputs and Outputs
    input Button;
    input [16:0] inputscore;
    output [16:0] outputscore;

    // Internal wire to hold the output of the selected subtractor
    wire [16:0] outS_single, outS_max;

    // Instantiate single bet and max bet subtractors
    singlebetSubtractor M1 (inputscore, outS_single);
    maxbetsubtractor M0 (inputscore, outS_max);

    // Select output based on Button value
    assign outputscore = (Button) ? outS_max : outS_single;

endmodule


module singlebetSubtractor(is, outS);

    // Inputs and Outputs
    input [16:0] is;
    output [16:0] outS;

    // Two's complement of 1 (to subtract 1)
    wire [16:0] TwosComplement = 17'b11111111111111111;
    wire [16:0] newNUM;

    // Instantiate 17-bit adder to perform subtraction by adding two's complement of 1
    seventeenbitadder U_add (TwosComplement, is, newNUM);

    assign outS = newNUM;

endmodule


module maxbetsubtractor(is, outS);

//ASSUMING THE MAX BET IS 5

    // Inputs and Outputs
    input [16:0] is;
    output [16:0] outS;

    // Two's complement of 5 (to subtract 5) 0101 -> 1011
    wire [16:0] TwosComplement = 17'b11111111111111011;
    wire [16:0] newNUM;

    // Instantiate 17-bit adder to perform subtraction by adding two's complement of 5
    seventeenbitadder U_add (TwosComplement, is, newNUM);

    assign outS = newNUM;

endmodule

// 17-bit adder module to be used in the subtractor modules
module seventeenbitadder(TwosComplement, is, Newpscore);
    // 17-bit adder

    input [16:0] is, TwosComplement;
    output [16:0] Newpscore;

    wire [16:0] sum;                    // Sum output from each one-bit adder
    wire carryOUT1, carryOUT2, carryOUT3, carryOUT4, carryOUT5, carryOUT6, carryOUT7;
    wire carryOUT8, carryOUT9, carryOUT10, carryOUT11, carryOUT12, carryOUT13, carryOUT14;
    wire carryOUT15, carryOUT16, carryOUT17;

    // Instantiate one-bit adders for each bit
    onebitADDER U0 (is[0], TwosComplement[0], 1'b0,      sum[0],  carryOUT1);
    onebitADDER U1 (is[1], TwosComplement[1], carryOUT1, sum[1],  carryOUT2);
    onebitADDER U2 (is[2], TwosComplement[2], carryOUT2, sum[2],  carryOUT3);
    onebitADDER U3 (is[3], TwosComplement[3], carryOUT3, sum[3],  carryOUT4);
    onebitADDER U4 (is[4], TwosComplement[4], carryOUT4, sum[4],  carryOUT5);
    onebitADDER U5 (is[5], TwosComplement[5], carryOUT5, sum[5],  carryOUT6);
    onebitADDER U6 (is[6], TwosComplement[6], carryOUT6, sum[6],  carryOUT7);
    onebitADDER U7 (is[7], TwosComplement[7], carryOUT7, sum[7],  carryOUT8);
    onebitADDER U8 (is[8], TwosComplement[8], carryOUT8, sum[8],  carryOUT9);
    onebitADDER U9 (is[9], TwosComplement[9], carryOUT9, sum[9],  carryOUT10);
    onebitADDER U10 (is[10], TwosComplement[10], carryOUT10, sum[10], carryOUT11);
    onebitADDER U11 (is[11], TwosComplement[11], carryOUT11, sum[11], carryOUT12);
    onebitADDER U12 (is[12], TwosComplement[12], carryOUT12, sum[12], carryOUT13);
    onebitADDER U13 (is[13], TwosComplement[13], carryOUT13, sum[13], carryOUT14);
    onebitADDER U14 (is[14], TwosComplement[14], carryOUT14, sum[14], carryOUT15);
    onebitADDER U15 (is[15], TwosComplement[15], carryOUT15, sum[15], carryOUT16);
    onebitADDER U16 (is[16], TwosComplement[16], carryOUT16, sum[16], carryOUT17);

    // Assign final sum to output
    assign Newpscore = sum;

endmodule

// One-bit full adder module
module onebitADDER(input og, input spun, input carryin, output sum, output carryout);
    // Sum and carry-out logic for a single bit adder
    assign carryout = (og & spun) | (og & carryin) | (spun & carryin);
    assign sum = og ^ spun ^ carryin;
endmodule



