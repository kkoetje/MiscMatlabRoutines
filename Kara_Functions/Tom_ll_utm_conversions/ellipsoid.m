function [er, es, en] = ellipsoid(refellip)
%%function [er, es, en] = ellipsoid(refellip)

	if (refellip == 1),  en = ['Airy'];, er = 6377563; es = 0.00667054;
	else if (refellip == 2), en = ['Australian National']; er = 6378160; es = 0.006694542;
	else if (refellip == 3), en = ['Bessel 1841']; er = 6377397; es = 0.006674372;
	else if (refellip == 4), en = ['Bessel 1841 (Nambia) ']; er = 6377484; es = 0.006674372;
	else if (refellip == 5), en = ['Clarke 1866']; er = 6378206; es = 0.006768658;
	else if (refellip == 6), en = ['Clarke 1880']; er = 6378249; es = 0.006803511;
	else if (refellip == 7), en = ['Everest']; er = 6377276; es = 0.006637847;
	else if (refellip == 8), en = ['Fischer 1960 (Mercury) ']; er = 6378166; es = 0.006693422;
	else if (refellip == 9), en = ['Fischer 1968']; er = 6378150; es = 0.006693422;
	else if (refellip == 10), en = ['GRS 1967']; er = 6378160; es = 0.006694605;
	else if (refellip == 11), en = ['GRS 1980']; er = 6378137; es = 0.00669438;
	else if (refellip == 12), en = ['Helmert 1906']; er = 6378200; es = 0.006693422;
	else if (refellip == 13), en = ['Hough']; er = 6378270; es = 0.00672267;
	else if (refellip == 14), en = ['International']; er = 6378388; es = 0.00672267;
	else if (refellip == 15), en = ['Krassovsky']; er = 6378245; es = 0.006693422;
	else if (refellip == 16), en = ['Modified Airy']; er = 6377340; es = 0.00667054;
	else if (refellip == 17), en = ['Modified Everest']; er = 6377304; es = 0.006637847;
	else if (refellip == 18), en = ['Modified Fischer 1960']; er = 6378155; es = 0.006693422;
	else if (refellip == 19), en = ['South American 1969']; er = 6378160; es = 0.006694542;
	else if (refellip == 20), en = ['WGS 60']; er = 6378165; es = 0.006693422;
	else if (refellip == 21), en = ['WGS 66']; er = 6378145; es = 0.006694542;
	else if (refellip == 22), en = ['WGS-72']; er = 6378135; es = 0.006694318;
	else if (refellip == 23), en = ['WGS-84']; er = 6378137; es = 0.00669438;
	end; end; end; end; end; end; end; end; end; end; end; end;
	end; end; end; end; end; end; end; end; end; end; end;
