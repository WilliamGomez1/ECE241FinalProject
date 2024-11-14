module NewScoreAdder(uppscore, SPUNscore, Newpscore);
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


module onebitADDER(input og, input spun, input carryin, output sum, output carryout);
    // Sum and carry-out logic for a single bit adder
    assign carryout = (og & spun) | (og & carryin) | (spun & carryin);
    assign sum = og ^ spun ^ carryin;
endmodule
