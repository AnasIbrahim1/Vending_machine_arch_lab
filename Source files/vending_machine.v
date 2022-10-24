module vending_machine(
    input sys_clk,
    input clk, 
    input reset,
    input coin_in_en,
    input coin_val,
    output reg pencil_out,
    output[7 : 0] enable,
    output[7 : 0] extra_money
    );
            
    reg[6 : 0] sum;
    wire clk_rising, coin_in_rising;
    risingDet r1(sys_clk, reset, clk, clk_rising);
    risingDet r2(sys_clk, reset, coin_in_en, coin_in_rising);
    reg[3 : 0] digits[3 : 0];
    
    always @(posedge sys_clk) begin
        if (reset) begin
            sum = 0;
            digits[0] = 0;
            digits[1] = 0;
            digits[2] = 0;
            digits[3] = 0;
            pencil_out = 0;
        end
        else begin
            if (clk_rising) begin
                sum = sum + 5 + (coin_val ? 5 : 0);
            end
            if (coin_in_rising) begin
                if (sum >= 15) begin
                    sum = sum - 15;
                    pencil_out = 1;
                end
            end
            digits[0] = sum % 10;
            digits[1] = sum / 10;
        end
    end
    
    wire[7:0] new_digits[3:0];
    segDisplay s1(digits[0], 1, 0, new_digits[0]);
    segDisplay s2(digits[1], 1, 0, new_digits[1]);
    segDisplay s3(digits[2], 1, 0, new_digits[2]);
    segDisplay s4(digits[3], 1, 0, new_digits[3]);
    
    digitSwitcher d(sys_clk, reset, new_digits[0], new_digits[1], 
    new_digits[2], new_digits[3],
     enable, extra_money);
endmodule
