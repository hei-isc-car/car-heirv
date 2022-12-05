-- Reduces the address to handle 2**10 data/instr
-- Also shifts the address twice, since it goes +4 each clock (and we do not handle half-address access)
ARCHITECTURE rtl OF bramAddrReducer IS
BEGIN
	-- +2 to srr(2) the address (as it makes +4)
	addrOut <= std_ulogic_vector(addrIn(addrOut'high+2 downto addrOut'low+2));
END ARCHITECTURE rtl;
