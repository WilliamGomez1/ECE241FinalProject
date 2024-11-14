module winState (SW, LEDR); //top module for testing
input [0:0] SW;
output [9:0] LEDR;

wire [31:0] PlayerIn = 32'd12;
wire [11:0] PlayerSpin = 12'b111111111111;
wire [31:0] PlayerOut;
assign LEDR[9:0] = PlayerOut[9:0];

stateCalcs U1 (PlayerSpin, PlayerIn, SW[0], PlayerOut);

endmodule

module stateCalcs (PlayerSpin, PlayerIn, PlayerBet, PlayerOut, /*RAM Value Jackpot*/);
/*input Jackpot;*/ //from RAM
input [11:0] PlayerSpin; //from spinState
input [31:0] PlayerIn; //from playState
input PlayerBet; //from playState
output [31:0] PlayerOut;

wire [1:0] spinType;
//implement module that checks if it's either 777, three repeating, or nothing in that order
SpinChecker U1 (PlayerSpin[11:0], spinType[1:0]);

//implement score calculator (adds either 200 or 1000 or 0 or jackpot depending on playerbet (if mux gave 0, player score = 0))
wire [16:0] scoreToAdd;
scoreToAddCalc A1 (spinType[1:0], PlayerBet, /*RAM Value Jackpot,*/ scoreToAdd[16:0]);

//implement adder to combine score and player's score
NewScoreAdder D1(PlayerIn[16:0], scoreToAdd[16:0], PlayerOut[16:0]);
//output player

endmodule

/* ----- Spin Checker ----- */
module SpinChecker(P, spinType);
input [11:0]P;
output [1:0]spinType;

//win will determine if the player has won anything, jackpot or normal
wire win;
assign spinType[0] = win;

//jackpot will determine if the jackpot has been won or not
wire jackpot;
assign spinType[1] = jackpot;

//win = 1 if every 4th digit is the same
assign win = ((P[11] & P[7] & P[3]) | (~P[11] & ~P[7] & ~P[3])) 
& ((P[10] & P[6] & P[2]) | (~P[10] & ~P[6] & ~P[2])) 
& ((P[9] & P[5] & P[1]) | (~P[9] & ~P[5] & ~P[1])) 
& ((P[8] & P[4] & P[0]) | (~P[8] & ~P[4] & ~P[0]));

//jackpot = 1 if win = 1 and the repeating digit is 7 (0111 in binary)
assign jackpot = win & (~P[3] & P[2] & P[1] & P[0]);

endmodule


/* ----- Score calculator ----- */
module scoreToAddCalc(spinType[1:0], PlayerBet, /*RAM Value Jackpot,*/ scoreToAdd[16:0]);
//input RAM Value Jackpot;
input PlayerBet; //1 if max, 0 if single
input [1:0] spinType;
output reg [16:0] scoreToAdd;


parameter	
    Nothing = 2'b00, 
	Win = 2'b01, 
    Jackpot = 2'b11;
always@(*)
begin
    case(spinType)
    Nothing: scoreToAdd <= 17'd0;
    Win: if (PlayerBet) //This can definitely be coded better, improve if possible
        scoreToAdd <= 17'd1000;
        else 
        scoreToAdd <= 17'd200;
    //Jackpot: scoreToAdd <= jackpot;
    default: scoreToAdd <= 17'd0;
    endcase
end

endmodule


/* ----- New Score Adder ----- */
module NewScoreAdder(OGpscore, SPUNscore, Newpscore);
    // 17-bit adder

    input [16:0] OGpscore, SPUNscore;
    output [16:0] Newpscore;

    wire [16:0] sum;                  // Sum output from each one-bit adder
    wire carryOUT1, carryOUT2, carryOUT3, carryOUT4, carryOUT5, carryOUT6, carryOUT7;
    wire carryOUT8, carryOUT9, carryOUT10, carryOUT11, carryOUT12, carryOUT13, carryOUT14;
    wire carryOUT15, carryOUT16, carryOUT17;

    // Instantiate one-bit adders for each bit
    onebitADDER U0 (OGpscore[0], SPUNscore[0], 1'b0,       sum[0],  carryOUT1);
    onebitADDER U1 (OGpscore[1], SPUNscore[1], carryOUT1,  sum[1],  carryOUT2);
    onebitADDER U2 (OGpscore[2], SPUNscore[2], carryOUT2,  sum[2],  carryOUT3);
    onebitADDER U3 (OGpscore[3], SPUNscore[3], carryOUT3,  sum[3],  carryOUT4);
    onebitADDER U4 (OGpscore[4], SPUNscore[4], carryOUT4,  sum[4],  carryOUT5);
    onebitADDER U5 (OGpscore[5], SPUNscore[5], carryOUT5,  sum[5],  carryOUT6);
    onebitADDER U6 (OGpscore[6], SPUNscore[6], carryOUT6,  sum[6],  carryOUT7);
    onebitADDER U7 (OGpscore[7], SPUNscore[7], carryOUT7,  sum[7],  carryOUT8);
    onebitADDER U8 (OGpscore[8], SPUNscore[8], carryOUT8,  sum[8],  carryOUT9);
    onebitADDER U9 (OGpscore[9], SPUNscore[9], carryOUT9,  sum[9],  carryOUT10);
    onebitADDER U10 (OGpscore[10], SPUNscore[10], carryOUT10, sum[10], carryOUT11);
    onebitADDER U11 (OGpscore[11], SPUNscore[11], carryOUT11, sum[11], carryOUT12);
    onebitADDER U12 (OGpscore[12], SPUNscore[12], carryOUT12, sum[12], carryOUT13);
    onebitADDER U13 (OGpscore[13], SPUNscore[13], carryOUT13, sum[13], carryOUT14);
    onebitADDER U14 (OGpscore[14], SPUNscore[14], carryOUT14, sum[14], carryOUT15);
    onebitADDER U15 (OGpscore[15], SPUNscore[15], carryOUT15, sum[15], carryOUT16);
    onebitADDER U16 (OGpscore[16], SPUNscore[16], carryOUT16, sum[16], carryOUT17);

    // Assign final sum to output
    assign Newpscore = sum;

endmodule

/* ----- One bit Adder ----- */
module onebitADDER(input og, input spun, input carryin, output sum, output carryout);
    // Sum and carry-out logic for a single bit adder
    assign carryout = (og & spun) | (og & carryin) | (spun & carryin);
    assign sum = og ^ spun ^ carryin;
endmodule
