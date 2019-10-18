# Mariana Suarez and Jake Fry
# Project 1

#Join all mcrA reference sequences into a combined file
for file in ../ref_sequences/mcrA*.fasta; do cat $file >> mcrAgene_all.fasta; done             
# Join all hsp70gene reference sequences into a combined file
for file in ../ref_sequences/hsp70gene*.fasta; do cat $file >> hsp70gene_all.fasta; done    

    
# Apply muscle to combined mcrAgene and hsp70gene files
/afs/crc.nd.edu/user/m/msuarez9/Private/Software/muscle -in mcrAgene_all.fasta -out mcrAgene_all.afa       
/afs/crc.nd.edu/user/m/msuarez9/Private/Software/muscle -in hsp70gene_all.fasta -out hsp70gene_all.afa
  
# Apply hmmerbuild for both mcrAgene and hsp70gene
/afs/crc.nd.edu/user/m/msuarez9/Private/Software/hmmer-3.2.1/bin/hmmbuild mcrAgene_all_out mcrAgene_all.afa  
/afs/crc.nd.edu/user/m/msuarez9/Private/Software/hmmer-3.2.1/bin/hmmbuild hsp70gene_all_out hsp70gene_all.afa

# Apply hmmersearch on each group of genes  hspgene and mrcAgene
for file in proteome*
do 
/afs/crc.nd.edu/user/m/msuarez9/Private/Software/hmmer-3.2.1/bin/hmmsearch --tblout $file.hsp hsp70gene_all_out $file 
/afs/crc.nd.edu/user/m/msuarez9/Private/Software/hmmer-3.2.1/bin/hmmsearch --tblout $file.mcrA mcrAgene_all_out $file 
done

# Determine the number of proteomes to be searched in order to have a flexible script that accepts any number of inputs
proteome_count=0
for file in proteome*
do 
proteome_count=$((proteome_count+1))
done


# Print the proteome number and its corresponding mcra and hsp70 gene hits

echo "proteome #, mcrAgene hits, hsp70gene hits" >> hits.txt

for i in {01..(proteome_count)}
do
a=$(cat proteome_$i.fasta.mcrA | grep -v "#" | wc -l)
b=$(cat proteome_$i.fasta.hsp | grep -v "#" | wc -l)
echo "$i, $a, $b" >> hits.txt
done
