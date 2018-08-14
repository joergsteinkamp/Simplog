function waterDepth(p, p0, rho, g) {
	var depth = (p - p0) / rho / g;
	return(depth);
}