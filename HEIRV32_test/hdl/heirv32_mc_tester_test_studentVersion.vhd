LIBRARY std;
  USE std.textio.ALL;

LIBRARY ieee;
  USE ieee.std_logic_textio.ALL;

LIBRARY Common_test;
  USE Common_test.testutils.all;
  
ARCHITECTURE studentVersion OF heirv32_mc_tester IS

  constant clockPeriod  : time := 1.0/g_clockFrequency * 1 sec;
  signal sClock         : std_uLogic := '1';
  signal sReset         : std_uLogic ;

  signal testInfo       : string(1 to 40) := (others => ' ');

  signal adr_u          : unsigned(31 downto 0);
  signal adr            : std_ulogic_vector(31 downto 0);
  signal ALUControl     : std_ulogic_vector(2 downto 0);
  signal ALUSrcA, ALUSrcB, immSrc, resultSrc : std_ulogic_vector(1 downto 0);
  signal IRWrite, PCWrite, adrSrc, memWrite, regwrite : std_ulogic;

  -- This tests for equivalence
  procedure checkProc(
    msg :           string;
    AdrArg :        unsigned(31 downto 0);
    ALUControlArg : std_ulogic_vector(2 downto 0);
    ALUSrcAArg :    std_ulogic_vector(1 downto 0);
    ALUSrcBArg :    std_ulogic_vector(1 downto 0);
    IRWriteArg :    std_ulogic;
    PCWriteArg :    std_ulogic;
    adrSrcArg :     std_ulogic;
    immSrcArg :     std_ulogic_vector(1 downto 0);
    memWriteArg :   std_ulogic;
    regwriteArg :   std_ulogic;
    resultSrcArg :  std_ulogic_vector(1 downto 0)) is
  begin
    wait for 0.8*clockPeriod;
    std.textio.write(std.textio.output, LF & "===================" & LF);
    std.textio.write(std.textio.output, "Testing " & msg  & LF);
    assert (adr_u = AdrArg)
      report ("Adr error - expected " & to_hstring(adr_u)) severity error;
    assert (ALUControl = ALUControlArg)
      report ("ALUControl error - expected " & to_string(ALUControlArg)) severity error;
    assert (ALUSrcA = ALUSrcAArg)
      report ("ALUSrcA error - expected " & to_string(ALUSrcAArg)) severity error;
    assert (ALUSrcB = ALUSrcBArg)
      report ("ALUSrcB error - expected " & to_string(ALUSrcBArg)) severity error;
    assert (IRWrite = IRWriteArg)
      report ("IRWrite error - expected " & to_string(IRWriteArg)) severity error;
    assert (PCWrite = PCWriteArg)
      report ("PCWrite error - expected " & to_string(PCWriteArg)) severity error;
    assert (adrSrc = adrSrcArg)
      report ("adrSrc error - expected " & to_string(adrSrcArg)) severity error;
    assert (immSrc = immSrcArg)
      report ("immSrc error - expected " & to_string(immSrcArg)) severity error;
    assert (memWrite = memWriteArg)
      report ("memWrite error - expected " & to_string(memWriteArg)) severity error;
    assert (regwrite = regwriteArg)
      report ("regwrite error - expected " & to_string(regwriteArg)) severity error;
    assert (resultSrc = resultSrcArg)
      report ("resultSrc error - expected " & to_string(resultSrcArg)) severity error;
    if (adr_u = AdrArg) AND (ALUControl = ALUControlArg) AND (ALUSrcA = ALUSrcAArg) AND (ALUSrcB = ALUSrcBArg) AND
      (IRWrite = IRWriteArg) AND (PCWrite = PCWriteArg) AND (adrSrc = adrSrcArg) AND (immSrc = immSrcArg) AND
      (memWrite = memWriteArg) AND (regwrite = regwriteArg) AND (resultSrc = resultSrcArg) then
      report " ** Ok" severity note;
    end if;
    std.textio.write(std.textio.output, "===================" & LF);
    wait until clk'event and clk = '1';
  end procedure checkProc;

BEGIN

 ------------------------------------------------------------------------------
                                                              -- reset and clock
  rst <= sReset;

  sClock <= not sClock after clockPeriod/2;
  clk <= transport sClock after 0.9*clockPeriod;

  btns <= (others => '0');

 ------------------------------------------------------------------------------
                                                              -- test signals

  (adr, ALUControl, ALUSrcA, ALUSrcB, IRWrite, PCWrite, adrSrc, immSrc, memWrite, regwrite, resultSrc) <= test;
  adr_u <= unsigned(adr);

  process
    -- Wait list
    -- 3 clk for beq
    -- 4 clk for others
    -- 5 clk for lw
  begin
    en <= '0';
    sReset <= '1';
    testInfo <= pad("Wait reset done", testInfo'length);
    wait for 3.5*clockPeriod;
    wait until clk'event and clk = '1';
    wait for 0.1*clockPeriod;
    sReset <= '0';

    -- First addi has not the same immSrc (based upon last instr.)
    -- Depends if you used '--' for some blocks or forced signals to 0
    -- If so, modify this line and the last from the loop
    testInfo <= pad("Addi, addr. 0x00", testInfo'length);
    en <= '1';
    checkProc("Addi, addr. 0x00 - fetch", x"00000000", "000", "00", "10", '1', '1', '0', "--", '0', '0', "10");

    while true loop

      testInfo <= pad("Addi, addr. 0x00", testInfo'length);
      checkProc("Addi, addr. 0x00 - decode", x"00000004", "000", "01", "01", '0', '0', '0', "00", '0', '0', "00");
      checkProc("Addi, addr. 0x00 - executeI", x"00000004", "000", "10", "01", '0', '0', '0', "00", '0', '0', "00");
      checkProc("Addi, addr. 0x00 - aluWB", x"00000004", "000", "00", "00", '0', '0', '0', "00", '0', '1', "00");

      testInfo <= pad("Addi, addr. 0x04", testInfo'length);
      checkProc("Addi, addr. 0x04 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Addi, addr. 0x04 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Addi, addr. 0x04 - executeI", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Addi, addr. 0x04 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Addi, addr. 0x08", testInfo'length);
      checkProc("Addi, addr. 0x08 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Addi, addr. 0x08 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Addi, addr. 0x08 - executeI", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Addi, addr. 0x08 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Or, addr. 0x0C", testInfo'length);
      checkProc("Or, addr. 0x0C - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Or, addr. 0x0C - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Or, addr. 0x0C - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Or, addr. 0x0C - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("And, addr. 0x10", testInfo'length);
      checkProc("And, addr. 0x10 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("And, addr. 0x10 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("And, addr. 0x10 - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("And, addr. 0x10 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Add, addr. 0x14", testInfo'length);
      checkProc("Add, addr. 0x14 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x14 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x14 - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x14 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Beq, addr. 0x18", testInfo'length);
      checkProc("Beq, addr. 0x18 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Beq, addr. 0x18 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Beq, addr. 0x18 - BEQ", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Slt, addr. 0x1C", testInfo'length);
      checkProc("Slt, addr. 0x1C - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Slt, addr. 0x1C - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Slt, addr. 0x1C - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Slt, addr. 0x1C - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Beq, addr. 0x20", testInfo'length);
      checkProc("Beq, addr. 0x20 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Beq, addr. 0x20 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Beq, addr. 0x20 - BEQ", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      --testInfo <= pad("Addi, addr. 0x24", testInfo'length);

      testInfo <= pad("Slt, addr. 0x28", testInfo'length);
      checkProc("Slt, addr. 0x28 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Slt, addr. 0x28 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Slt, addr. 0x28 - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Slt, addr. 0x28 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Add, addr. 0x2C", testInfo'length);
      checkProc("Add, addr. 0x2C - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x2C - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x2C - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x2C - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Sub, addr. 0x30", testInfo'length);
      checkProc("Sub, addr. 0x30 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sub, addr. 0x30 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sub, addr. 0x30 - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sub, addr. 0x30 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Sw, addr. 0x34", testInfo'length);
      checkProc("Sw, addr. 0x34 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sw, addr. 0x34 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sw, addr. 0x34 - memAdr", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sw, addr. 0x34 - memWr", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Lw, addr. 0x38", testInfo'length);
      checkProc("Lw, addr. 0x38 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Lw, addr. 0x38 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Lw, addr. 0x38 - memAdr", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Lw, addr. 0x38 - memRd", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Lw, addr. 0x38 - memWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Add, addr. 0x3C", testInfo'length);
      checkProc("Add, addr. 0x3C - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x3C - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x3C - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x3C - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Jal, addr. 0x40", testInfo'length);
      checkProc("Jal, addr. 0x40 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Jal, addr. 0x40 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Jal, addr. 0x40 - JAL", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Jal, addr. 0x40 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      --testInfo <= pad("Addi, addr. 0x44", testInfo'length);

      testInfo <= pad("Add, addr. 0x48", testInfo'length);
      checkProc("Add, addr. 0x48 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x48 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x48 - executeR", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Add, addr. 0x48 - aluWB", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Sw, addr. 0x4C", testInfo'length);
      checkProc("Sw, addr. 0x4C - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sw, addr. 0x4C - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sw, addr. 0x4C - memAdr", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Sw, addr. 0x4C - memWr", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      testInfo <= pad("Beq, addr. 0x50", testInfo'length);
      checkProc("Beq, addr. 0x50 - fetch", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Beq, addr. 0x50 - decode", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");
      checkProc("Beq, addr. 0x50 - BEQ", x"00000000", "---", "--", "--", '-', '-', '-', "--", '-', '-', "--");

      en <= '0';
      testInfo <= pad("Wait a bit, PC should be 0", testInfo'length);
      checkProc("Prog. loop", x"00000000", "000", "00", "10", '1', '1', '0', "10", '0', '0', "10");
      wait for 9.2*clockPeriod;
      wait until clk'event and clk = '1';
      wait for 0.1*clockPeriod;

      en <= '1';
      checkProc("Addi, addr. 0x00 - fetch", x"00000000", "000", "00", "10", '1', '1', '0', "10", '0', '0', "10");

    end loop;
  end process;

END ARCHITECTURE studentVersion;
