{
	Program to calculate the probabilities of winning battles in the game of Risk
	when using different army sizes for attacking and defending.
}
program riskprobability;

uses math, unix;

var	Answer: real = 0;
    AttArmies, DefArmies: integer;
    RollAtt, RollDef: real;
    ProbArray: Array[0..10, 0..10] of real;

// Base battle [1,1]
function BaseBattle(aAttArmies, aDefArmies: integer): real;
var i: integer;
begin
	BaseBattle:= 0;
	for i:= 5 downto 1 do
  begin
		BaseBattle:= BaseBattle + (i/6);  	
  end;
  BaseBattle:= BaseBattle/6;
end;

// Roll with more attacking armies
function MoreAttack(aAttArmies, aDefArmies: integer): real;
var i: integer;
begin
	MoreAttack:= 0;
	for i:= 1 to 5 do
  begin
    MoreAttack:= MoreAttack + Power((1/6), 3) * (2*(Sqr(i)) + i);
	end;
end;

// Roll with more defending armies
function MoreDefense(aAttArmies: integer; aDefArmies: integer): real;
var i: integer;
begin
	MoreDefense:= 0;
  for i:= 2 to 6 do
  begin
  	MoreDefense:= MoreDefense + Power((1/6), 3) * Sqr(i-1);
  end;
end;

// Battle with more attacking armies
function AttBattle(aAttArmies, aDefArmies: integer): real;
var TempMoreAttack, TempBaseBattle: real;
begin
	AttBattle:= 0;
  TempMoreAttack:= MoreAttack(aAttArmies, aDefArmies);
  TempBaseBattle:= BaseBattle(1, 1);
	AttBattle:= TempMoreAttack * TempBaseBattle					// win both battles
  						+ (1-TempMoreAttack) * TempBaseBattle		// lose/tie first, win second
              + TempMoreAttack * (1-TempBaseBattle);	// win first, lose/tie second
end;

// Battle with more defending armies
function DefBattle(aAttArmies, aDefArmies: integer): real;
begin
  DefBattle:= MoreDefense(aAttArmies, aDefArmies) * BaseBattle(1, 1);
end;                                                                	

// Print probability of roll
procedure PrintRollProbability(aAttArmies, aDefArmies: integer; aAnswer: real);
begin
  writeln('  P(R|[', aAttArmies, ',', aDefArmies, ']): ', aAnswer:0:4);
end;

// Print probability of batlle
procedure PrintBattleProbability(aAttArmies, aDefArmies: integer; aAnswer: real);
begin
  writeln('  P(B|[', aAttArmies, ',', aDefArmies, ']): ', aAnswer:0:4);
end;

procedure PrintProbArray;
var i, j: integer;
begin
	writeln;
  writeln('      1       2       3       4       5       6       7       8       9      10');
	for i:= 1 to 10 do
  	begin
    	write(i:2, ' ');
  		for j:= 1 to 10 do
    		begin
          write(ProbArray[j, i]:0:4, '  ');
      	end;
      writeln;		
    end;
end;

begin
	unix.fpSystem('clear');	// Clear terminal

  AttArmies:=1;
  DefArmies:=1;
  //RollBase:= BaseBattle(AttArmies, DefArmies);
  ProbArray[1, 1]:= BaseBattle(AttArmies, DefArmies);
  AttArmies:=2;
  DefArmies:=1;
  RollAtt:= MoreAttack(AttArmies, DefArmies);
  //RollAttBattle:= AttBattle(AttArmies, DefArmies);
  ProbArray[2, 1]:= AttBattle(AttArmies, DefArmies);
  AttArmies:=1;
  DefArmies:=2;
  RollDef:= MoreDefense(AttArmies, DefArmies);
  //RollDefBattle:= DefBattle(AttArmies, DefArmies);
  ProbArray[1, 2]:= DefBattle(AttArmies, DefArmies);

  writeln('Probability of Risk-battles');
  writeln('  Roll:   P(R|[a,d])');
  writeln('  Battle: P(B|[a,d])');
  writeln('  a=attacker, d=defender');
	writeln;

  AttArmies:= 1;
  DefArmies:= 1;
	PrintRollProbability(AttArmies, DefArmies, ProbArray[1, 1]);
  PrintBattleProbability(AttArmies, DefArmies, ProbArray[1, 1]);
  writeln;

  AttArmies:= 2;
  DefArmies:= 1;
  PrintRollProbability(AttArmies, DefArmies, RollAtt);
  PrintBattleProbability(AttArmies, DefArmies, ProbArray[2, 1]);
	writeln;

  AttArmies:= 1;
  DefArmies:= 2;
  PrintRollProbability(AttArmies, DefArmies, RollDef);
  PrintBattleProbability(AttArmies, DefArmies, ProbArray[1, 2]);
	
  PrintProbArray;
end.
