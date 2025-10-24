ARCHITECTURE RTL OF bufferStdULog IS
BEGIN

    buffering:process(rst, clk)
	begin
		if rst = '1' then
			out1 <= (others=>'0');
		elsif rising_edge(clk) then
			out1 <= in1;
		end if;
	end process buffering;
	
END ARCHITECTURE RTL;
