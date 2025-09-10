-- Setup ALU operation based on instruction
ARCHITECTURE studentVersion OF aluDecoder IS
BEGIN

  -- The following is DUMMY code
  -- Change it according to your needs
  decode : process(op, funct3, funct7, ALUOp)
  begin
    case ALUOp is
      when "11" => ALUControl <= "---";
      when "10" => ALUControl <= "---";
      when "00" => ALUControl <= "---";
      when others =>
        if (funct3 = '1' and funct7 = '0') or funct3 = '0' then
          ALUControl <= "---";
        elsif funct7 = '1' then
          ALUControl <= "---";
        else
          ALUControl <= "---";
        end if;
    end case;
  end process decode;

END ARCHITECTURE studentVersion;
