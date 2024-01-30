{
	Program to calculate the probabilities of winning battles in the game of Risk
	when using different army sizes for attacking and defending.
}

program riskprobability;

uses math, unix;

var gaProbability: Array[0..200, 0..200] of real;	// array for storing results
    gaWinRolls: Array[0..3, 0..2] of real;				// odds for roll win
    gaLoseRolls: Array[0..3, 0..2] of real;				// odds for roll lose
    gaTieRolls: Array[0..3, 0..2] of real;				// odds for roll win
    giMAXNUM: integer = 100;

// Execute battle with specified amount of attacking and defending armies
function RunBattle(aAttackDice, aDefenseDice: integer): real;
var AttackDiceRoll, DefenseDiceRoll: integer;
		Delta: integer = 1;
begin
  if aAttackDice <= 0 then begin	// 0 attack armies is a lose
  	Exit(0);
  end;
  if aDefenseDice <= 0 then begin	// 0 defense armies is a win
   	Exit(1);
  end;

  // If value not yet calculated, process the battle(s)
  if gaProbability[aAttackDice, aDefenseDice] = 0.00 then begin
    // Test if more attacking dice than allowed for a roll
    if aAttackDice > 3 then begin
    	AttackDiceRoll:= 3;
    end else begin
	   	AttackDiceRoll:= aAttackDice;
    end;

    // Test if more defending dice than allowed for a roll
		if aDefenseDice > 2 then begin
    	DefenseDiceRoll:= 2
    end else begin
     	DefenseDiceRoll:= aDefenseDice;
    end;
		
    // Allow losing two dice when possible
    if (AttackDiceRoll >= 2) and (DefenseDiceRoll = 2) then begin
     	Delta:= 2;
    end;

    // Execute battle
    RunBattle:= gaWinRolls[AttackDiceRoll, DefenseDiceRoll] * RunBattle(aAttackDice, aDefenseDice-Delta)			// outcome win
    	          + gaTieRolls[AttackDiceRoll, DefenseDiceRoll] * RunBattle(aAttackDice-1, aDefenseDice-1)			// outcome tie
       	        + gaLoseRolls[AttackDiceRoll, DefenseDiceRoll] * RunBattle(aAttackDice-Delta, aDefenseDice);	// outcome lose
  // If value is already calculated, return that instead
  end else begin
    RunBattle:= gaProbability[aAttackDice, aDefenseDice];
  end;
end;

// Initialize odds for roll possibilities
// [a,d] a=attack, d=defense
procedure InitializeRolls;
begin
	gaWinRolls[1,1]:= 15/36;
  gaWinRolls[1,2]:= 55/216;
  gaWinRolls[2,1]:= 125/216;
  gaWinRolls[2,2]:= 295/1296;
  gaWinRolls[3,1]:= 855/1296;
  gaWinRolls[3,2]:= 2890/7776;
  gaLoseRolls[1,1]:= 21/36;
  gaLoseRolls[1,2]:= 161/216;
  gaLoseRolls[2,1]:= 91/216;
  gaLoseRolls[2,2]:= 581/1296;
  gaLoseRolls[3,1]:= 441/1296;
  gaLoseRolls[3,2]:= 2275/7776;
  gaTieRolls[2,2]:= 420/1296;
  gaTieRolls[3,2]:= 2611/7776;
end;

// Initialize odds for first battle outcomes
procedure InitializeBaseBattles;
begin
	gaProbability[1, 1]:= 5/12;
  gaProbability[1, 2]:= 55/216 * 5/12;
  gaProbability[2, 1]:= 125/216 + (1-(125/216)) * 5/12;
end;

// Calculate all battles in grid
procedure CalculateBattles;
var i, j: integer;
begin
	for i:= 4 to giMAXNUM*2 do begin
  	for j:= 1 to i do begin
			if ((j + (i-j)) = i) and ((j<=giMAXNUM) and ((i-j)<=giMAXNUM)) then begin
    		gaProbability[j, i-j]:= RunBattle(j, i-j);
    	end;
    end;
  end;
end;

// Print output of 20 attack/20 defense in a grid
procedure PrintProbabilities;
var i, j: integer;
begin
  writeln('      1       2       3       4       5       6       7       8       9      10      11      12      13      14      15      16      17      18      19      20');
	for i:= 1 to 20 do
  	begin
    	write(i:2, ' ');
  		for j:= 1 to 20 do
    		begin
          write(gaProbability[j, i]:0:4, '  ');
      	end;
      writeln;		
    end;
end;

begin
	unix.fpSystem('clear');	// Clear terminal

  InitializeRolls;
  InitializeBaseBattles;
  CalculateBattles;

  writeln('Probability of Risk-battles');
	writeln;
  PrintProbabilities;
end.
