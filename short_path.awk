BEGIN {
	FS="/"
}
{
	original=$0;
	shortened=$0;
	if (length($0) > 14) {
		if (NF > 4) {
			shortened=$1 "/" $2 "/.../" $(NF-1) "/" $NF;
		} else if (NF > 3) {
			shortened=$1 "/" $2 "/.../" $NF;
		} else {
			shortened=$1 "/.../" $NF;
		}
	}
	if (length(shortened) < length(original)) {
		print shortened;
	} else {
		print original;
	}
}

