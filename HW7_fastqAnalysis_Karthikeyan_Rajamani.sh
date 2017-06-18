#download SRR file 
#curl -O https://sra-download.ncbi.nlm.nih.gov/srapub/SRR203502

#extract 2 fastq files using SRA toolkit function fastq-dump --split-files 
fastq-dump --split-files -X 5000 SRR203502

#Count Reads in each file
Count_R1=$(awk 'END{print NR/4}' SRR203502_1.fastq)
Count_R2=$(awk 'END{print NR/4}' SRR203502_1.fastq)

#Run fastx_quality_stats from fastX toolkit
fastx_quality_stats -i SRR203502_1.fastq -o SRR203502_1_Qstats.txt
fastx_quality_stats -i SRR203502_2.fastq -o SRR203502_2_Qstats.txt

#Record 5 positions with smallest mean score and 5 positions with highest mean score for each stat file
grep -v 'column' SRR203502_1_Qstats.txt |cut -f1,6 | sort -n -k2| awk ' NR<6 {print}; NR>141 {print}' > Pos_Score_1.txt
grep -v 'column' SRR203502_2_Qstats.txt |cut -f1,6 | sort -n -k2| awk ' NR<6 {print}; NR>141 {print}' > Pos_Score_2.txt

#Run fastq_quality_filter
fastq_quality_filter -q15 -p70 -v -i SRR203502_1.fastq -o SRR203502_1_q15p70.fastq
fastq_quality_filter -q15 -p70 -v -i SRR203502_2.fastq -o SRR203502_2_q15p70.fastq

#Count Reads in each file
CountClean_R1=$(awk 'END{print NR/4}' SRR203502_1_q15p70.fastq)
CountClean_R2=$(awk 'END{print NR/4}' SRR203502_2_q15p70.fastq)

#Rerun fastx_quality_stats on clean files
fastx_quality_stats -i SRR203502_1_q15p70.fastq -o SRR203502_1_q15p70_Qstats.txt
fastx_quality_stats -i SRR203502_2_q15p70.fastq -o SRR203502_2_q15p70_Qstats.txt

#Record 5 positions with smallest mean score and 5 positions with highest mean score for each stat file
grep -v 'column' SRR203502_1_q15p70_Qstats.txt |cut -f1,6 | sort -n -k2| awk ' NR<6 {print}; NR>141 {print}' > Clean_Pos_Score_1.txt
grep -v 'column' SRR203502_2_q15p70_Qstats.txt |cut -f1,6 | sort -n -k2| awk ' NR<6 {print}; NR>141 {print}' > Clean_Pos_Score_2.txt

#Record results to Results.txt
awk 'BEGIN{print "Position\tScore"}' > header.txt
echo "SRR203502_1.fastq before quality filter: Total Reads: $Count_R1" > Results.txt
cat header.txt Pos_Score_1.txt >>Results.txt
echo "SRR203502_1.fastq after quality filter: Total Reads: $CountClean_R1" >> Results.txt
cat header.txt Clean_Pos_Score_1.txt >>Results.txt
echo "SRR203502_2.fastq before quality filter: Total Reads: $Count_R2" >> Results.txt
cat header.txt Pos_Score_2.txt >>Results.txt
echo "SRR203502_2.fastq after quality filter: Total Reads: $CountClean_R2" >> Results.txt
cat header.txt Clean_Pos_Score_2.txt >>Results.txt

mkdir -p $WORK/HW7
cp Results.txt $WORK/HW7

#Clean up
rm *.txt *.fastq