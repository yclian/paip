#!/usr/bin/env bash

echo "checknric.sh v0.1"
echo "Released to the public domain"
echo

if [ $# -ne 1 ]; then

	echo "About: 	this script connects to the SPR website and "
	echo "	retrieves voter registration data. Use it wisely."
	echo
	echo "Usage:	checknric.sh [nric]"
	echo
	exit 1

fi

echo -n "Scrapping SPR site ..."

OUTPUT=`wget --quiet --post-data "txtIC=${1}&Semak=CHECK&__EVENTVALIDATION=%2FwEWAwLGiua8AgKp%2B5bqDwKztY%2FNDosH1kCpgDPjGkh83TAYSyF%2Fo1TL&__VIEWSTATE=%2FwEPDwUJNDUxNTQzMDcwD2QWAgIBD2QWCAIIDxYCHgdWaXNpYmxlaGQCCQ8WAh8AZxYYAgEPDxYCHgRUZXh0BQw4MDAyMjcwNzU2MDFkZAIDDw8WBB8BBQEvHwBoZGQCBQ8PFgIfAWVkZAIHDw8WAh8BBRtESVRFU0ggS1VNQVIgQS9MIFNIQVNISUtBTlRkZAIJDw8WAh8BBQsyNyBGZWIgMTk4MGRkAgsPDxYCHwEFBkxFTEFLSWRkAg0PDxYCHwEFSDEyMSAvIDAwIC8gMDIgLyAwMTIgLSBMT1JPTkcgTUFBUk9GICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRkAg8PDxYCHwEFHDEyMSAvIDAwIC8gMDIgLSBKQUxBTiBNQUFST0ZkZAIRDw8WAh8BBQsxMjEgLyAwMCAtIGRkAhMPDxYCHwEFEzEyMSAtIExFTUJBSCBQQU5UQUlkZAIVDw8WAh8BBRBXLlAgS1VBTEEgTFVNUFVSZGQCGw8PFgIfAQUBLWRkAgoPZBYUAgEPDxYCHwFlZGQCBQ8PFgIfAWVkZAIHDw8WAh8BZWRkAgkPDxYCHwFlZGQCCw8PFgIfAWVkZAINDw8WAh8BZWRkAg8PDxYCHwFlZGQCEQ8PFgIfAWVkZAITDw8WAh8BZWRkAhUPDxYCHwFlZGQCCw9kFhQCAQ8PFgIfAWVkZAIFDw8WAh8BZWRkAgcPDxYCHwFlZGQCCQ8PFgIfAWVkZAILDw8WAh8BZWRkAg0PDxYCHwFlZGQCDw8PFgIfAWVkZAIRDw8WAh8BZWRkAhMPDxYCHwFlZGQCFQ8PFgIfAWVkZGQqm4kK4ufoLM9dSi3qdrCmBHnsdg%3D%3D&__EVENTTARGET&__EVENTARGUMENT" --output-document=- http://daftarj.spr.gov.my/NEWDAFTARJ/DaftarjBI.aspx`

echo -n " done."

if [ $? -ne 0 ]; then

	echo " wget error, bailing."
	echo
	exit 2

fi


GREPOUT=`echo $OUTPUT | grep "Record not found"`

if [ $? -eq 0 ]; then

	echo " No record found."
	echo
	exit 3 

fi

NRIC=`echo "$OUTPUT" | sed -rne 's|.*IC">([^<]+).*|\1|p'`
NAME=`echo "$OUTPUT" | sed -rne 's|.*nama">([^<]+).*|\1|p'`
DOB=`echo "$OUTPUT" | sed -rne 's|.*Tlahir">([^<]+).*|\1|p'`
GENDER=`echo "$OUTPUT" | sed -rne 's|.*jantina">([^<]+).*|\1|p'`
LOCALITY=`echo "$OUTPUT" | sed -rne 's|.*lokaliti">([^<]+).*|\1|p'`
DM=`echo "$OUTPUT" | sed -rne 's|.*dm">([^<]+).*|\1|p'`
DUN=`echo "$OUTPUT" | sed -rne 's|.*dun">([^<]+).*|\1|p'`
PARLIMENTARY=`echo "$OUTPUT" | sed -rne 's|.*par">([^<]+).*|\1|p'`
STATE=`echo "$OUTPUT" | sed -rne 's|.*negeri">([^<]+).*>|\1|p'`

echo " Record found:"
echo
echo "NRIC: $NRIC"
echo "NAME: $NAME"
echo "DOB: $DOB"
echo "GENDER: $GENDER"
echo "LOCALITY: $LOCALITY"
echo "POLLING DISTRICT: $DM"
echo "STATE ASSEMBLY: $DUN"
echo "PARLIMENTARY: $PARLIMENTARY"
echo "STATE: $STATE"

exit 0
