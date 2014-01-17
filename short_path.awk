BEGIN {
	FS="/"
}
{
	if (length($0) > 14) {
	   	if (NF>4) {
			print $1 "/" $2 "/.../" $(NF-1) "/" $NF;
		} else if (NF>3) {
			print $1 "/" $2 "/.../" $NF;
		} else {
			print $1 "/.../" $NF;
		}
   	} else {
   		print $0;
	}
}

