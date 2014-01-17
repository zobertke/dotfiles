BEGIN {
	FS="/"
}

function printMiddlePart(start, end) {
	result=""
	for (i=start; i<=end; ++i) {
		result=result "/" substr($i, 0, 1);
	}
	return result;
}

{
	original=$0;
	shortened=$0;
	if (length($0) > 20 && NF > 3) {
		if (NF > 4) {
			shortened=$1 "/" $2 printMiddlePart(3, NF-2) "/" $(NF-1) "/" $NF;
		} else { #NF == 3
			shortened=$1 "/" $2 printMiddlePart(3, NF-1) "/" $NF;
		}
	}
	if (length(shortened) < length(original)) {
		print shortened;
	} else {
		print original;
	}
}

