DBNAME=ngtms

TABLE=VendorCfg



FNAME=/home/crimsonfantasy/workspace2/ngtms/$(date +%Y.%m.%d)-$DBNAME.csv
TEMP=/var/tmp/$(date +%Y.%m.%d)-$DBNAME.temp



#(1)creates empty file and sets up column names using the information_schema

#sed 's/^/"/g;s/$/"/g' 
mysql -u root   -phwe03  $DBNAME -B -e "SELECT COLUMN_NAME FROM information_schema.COLUMNS C WHERE table_name = '$TABLE';" | awk '{print $1}' | grep -iv ^COLUMN_NAME$ |  tr '\n' ',' > $FNAME



#(2)appends newline to mark beginning of data vs. column titles

echo "" >> $FNAME



#(3)dumps data from DB into /var/mysql/tempfile.csv
# OPTIONALLY ENCLOSED BY '\"' 
mysql -u root -phwe03  $DBNAME -B -e "SELECT * INTO OUTFILE '$TEMP' FIELDS TERMINATED BY ','   FROM $TABLE;"



#(4)merges data file and file w/ column names

cat $TEMP >> $FNAME



#(5)deletes tempfile

rm -rf $TEMP
