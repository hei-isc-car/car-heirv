-- Wrapper around sd_file_reader.v, written in verilog.

-- Library SDCard;
--   Use SDCard.sd_file_reader;

ARCHITECTURE RTL OF sdFileReader_VhdlWrapper IS

  COMPONENT sd_file_reader
    GENERIC (
      FILE_NAME_LEN : integer := 11;
      FILE_NAME     : std_logic_vector(52*8 - 1 downto 0)  := (others => '0');
      CLK_DIV       : std_logic_vector(2 downto 0) := "010";
      SIMULATE      : integer := 0
    );
    PORT (
      clk            : IN    std_logic;
      rstn           : IN    std_logic;
      sdclk          : OUT   std_logic;
      sdcmd          : INOUT std_logic;
      sddat          : INOUT std_logic_vector(3 downto 0);
      card_stat      : OUT   std_logic_vector(3 downto 0);
      card_type      : OUT   std_logic_vector(1 downto 0);
      filesystem_type: OUT   std_logic_vector(1 downto 0);
      file_found     : OUT   std_logic;
      outen          : OUT   std_logic;
      outbyte        : OUT   std_logic_vector(7 downto 0)
    );
  END COMPONENT;

  -- A procedure to convert an input string into an array of std_ulogic_vector of FILE_NAME size
  function string_to_file_name(
    constant str : string;
    constant len : integer
  ) return std_logic_vector is
    variable result : std_logic_vector(52*8 - 1 downto 0) := (others => '0');
  begin
    for i in 0 to len - 1 loop
      --result(i*8 + 7 downto i*8) := std_logic_vector(to_unsigned(character'pos(str(i + 1)), 8)); -- little-endian, LSB
      result((len - 1 - i)*8 + 7 downto (len - 1 - i)*8) := std_logic_vector(to_unsigned(character'pos(str(i + 1)), 8));  -- big-endian, LSB
      -- result((52*8 - 1) - (i*8) downto (52*8 - 8) - (i*8)) := std_logic_vector(to_unsigned(character'pos(str(i + 1)), 8)); -- big-endian, MSB
    end loop;
    return result;
  end function;

BEGIN

      -- assert false report "g_FILE_NAME is " & g_FILE_NAME
      --   & " / length is " & integer'image(g_FILE_NAME'length)
      --   & " / resulting in vector " & to_hstring(string_to_file_name(g_FILE_NAME, g_FILE_NAME'length)) severity note;

  -- Instantiate the sd_file_reader module
  u_sd_file_reader: sd_file_reader
    GENERIC MAP (
      FILE_NAME_LEN => g_FILE_NAME'length,
      FILE_NAME     => string_to_file_name(g_FILE_NAME, g_FILE_NAME'length),
      CLK_DIV       => std_logic_vector(to_unsigned(g_CLK_DIV, 3)),
      SIMULATE      => 0
    )
    PORT MAP (
      clk            => clk,
      rstn           => rstn,
      sdcmd          => sdcmd,
      sddat          => sddat,
      sdclk          => sdclk,
      card_stat      => card_stat,
      card_type      => card_type,
      filesystem_type=> filesystem_type,
      file_found     => file_found,
      outen          => outen,
      outbyte        => outbyte
    );

END ARCHITECTURE RTL;
