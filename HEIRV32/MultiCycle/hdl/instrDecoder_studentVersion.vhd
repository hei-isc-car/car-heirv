-- Defines extend type based on instruction
ARCHITECTURE studentVersion OF instrDecoder IS
BEGIN

  -- The following is DUMMY code
  -- Change it according to your needs
  decode : process(op)
  begin
    case op is
      when "0000000" => immSrc <= "--";
      when "0000001" => immSrc <= "--";
      when "0000010" => immSrc <= "--";
      when others    => immSrc <= "--";
    end case;
  end process decode;

END ARCHITECTURE studentVersion;
