#include <stdio.h>
#include <string.h>
char *diskimage;//disk image
char buffer[512];//buffer to hold data
int emptytableindex[4096];
int FATTABLE[4096];

struct FileList
{
    char FileName[248];//name of file
    int FirstBlock;// first data block number
    int FileSize;// total size in bytes
};


struct Data//struct for each block with size 512 byte
{
    char data[512];
};

struct FileList FileList[128];//temp file list
struct Data Data[4096];// temp data

//prototypes




void ListPrint();//Print List into file
void PrintFat();// Print fat table to file
void DeFragmentation();// defragmentation
void List();// list in cmd
void Delete(char *filename);// delete
void Write(char *srcPath, char *destFileName);//write
void Format();//Format






void Write( char *srcPath, char *destFileName)//Write file
{
    

    //file pointers
    FILE *FilePointer;
    FILE *srcPtr;
    

    FilePointer = fopen(diskimage, "r+");//open to read
    srcPtr = fopen(srcPath, "r+");// open to write

    //read fat and filelist
    fread(FATTABLE, sizeof(FATTABLE), 1, FilePointer);
    fread(FileList, sizeof(FileList), 1, FilePointer);
    fread(Data, sizeof(Data), 1, FilePointer);

    int i;
    int firstfind=0;
    int firstempty=-1;
    //find the file
    for (i = 0; i < 128; i++)
    {
        //if the file is found
		if(strcmp(FileList[i].FileName,destFileName) == 0)
        {
            printf("The same name already exists!\n");
            return;
        }

        if((firstfind== 0) && (FileList[i].FirstBlock == 0 )&&  (FileList[i].FileSize==0)){
            firstfind = 1;
            firstempty=i;
        }


    }

    if(!firstfind){
    printf("No space in list");
    return;
    }


    fseek(srcPtr, 0L, SEEK_END);
    int sizefile = ftell(srcPtr);//fint file size
    fseek(srcPtr, 0, SEEK_SET);

    int blockcount=sizefile/512;
    if((sizefile%512)!=0)
    blockcount++;// neccessary amount of blocks
    
    


    int emptyblockcount=0;
    for (i = 1; i < 4096 && blockcount>=emptyblockcount; i++)
            if (FATTABLE[i]== 0){
                emptytableindex[emptyblockcount]=i;
                emptyblockcount++;
                
            }

    if(emptyblockcount<blockcount){// if number of empty blocks are not enough, return error
        printf("Not enough space\n");
        return;
    }

    //printf("size :%d empty %d: blockcount. %d index %d\n",sizefile, firstempty,blockcount,emptytableindex[0]);//debugging
    int readcount=0;
    strcpy(&FileList[firstempty].FileName[0], destFileName);
    FileList[firstempty].FirstBlock = emptytableindex[0];
    FileList[firstempty].FileSize=sizefile;

    //printf("FileList[firstempty].FirstBlock :%d \n",FileList[firstempty].FirstBlock);//debugging
    for(i=0;i<blockcount;i++){
        //clear buffer 
        memset(&buffer[0], 0, sizeof(buffer));
        readcount=fread(buffer, sizeof(char), sizeof(buffer), srcPtr);//read into buffet
        fseek(FilePointer, emptytableindex[i] * sizeof(int), SEEK_SET);
        
       
        
        if(blockcount==(i+1)){//if this is the last write
        //printf("burada");/debugging
        
        FATTABLE[emptytableindex[i]]=0XFFFFFFFF;

        }
        else{
            FATTABLE[emptytableindex[i]]=emptytableindex[i+1];
        }
        //printf("readcound %d \n",readcount);
        fseek(FilePointer, 4096 * sizeof(int) + 128 * sizeof(struct FileList) + emptytableindex[i] * sizeof(struct Data), SEEK_SET);//
        fwrite(&buffer, sizeof(char), readcount, FilePointer);  







    }
    fseek(FilePointer, 0, SEEK_SET);
    fwrite(FATTABLE, sizeof(FATTABLE), 1, FilePointer);
    fwrite(FileList, sizeof(FileList), 1, FilePointer);
    //yazdır
    fclose(FilePointer);
    fclose(srcPtr);


}

void Read(char *SourceFile, char *DestinationFile)//Read the data
{
    
    

    //file pointers
    FILE *FilePointer;
    FILE *fileRead;
    

    FilePointer = fopen(diskimage, "r+");//open disk image

    //read fat and filelist
    fread(FATTABLE, sizeof(FATTABLE), 1, FilePointer);//Read the table
    fread(FileList, sizeof(FileList), 1, FilePointer);//read the list
    fread(Data, sizeof(Data), 1, FilePointer);//Read data

    int filenumber=0;
    int found=0;

    for (int i = 0; i < 128; i++)
    {
        //if the file is found
		if(strcmp(FileList[i].FileName,SourceFile) == 0){
            found=1;
            filenumber=i;
			break;
        }
    }
    
    //print error if not found
    if (!found)
    {
        printf("File does not exist\n");
        fclose(FilePointer);
        return;
    }

    
    fileRead = fopen(DestinationFile, "w+");// create a new file 

    int index = FileList[filenumber].FirstBlock;
    int size = FileList[filenumber].FileSize;

    //read until the 0xffffffff fat table value is reached
    while (1)
    {
        //reset memory
        memset(&buffer[0], 0, sizeof(buffer));
        //copy data into temp data
        memcpy(&buffer, &Data[index], sizeof(Data[index]));
        
        if (size > 512)
        {//read all if size is larger than 512
            size = size - 512;
            fwrite(buffer, 512 * sizeof(char), 1, fileRead);
        }
       
        else// read reamaning
            fwrite(buffer, size * sizeof(char), 1, fileRead);
       
        if (FATTABLE[index] == 0xFFFFFFFF) 
            break;
        //find the next fat index
        index = (FATTABLE[index]);
    }

    fclose(FilePointer);
    fclose(fileRead);
}


void Format( )
{
   
    

    //file pointer
    FILE *FilePointer;
    FilePointer = fopen(diskimage, "r+");

   
    FATTABLE[0]= 0xFFFFFFFF;

    
    
    int i;
    
    
    for (i = 1; i < 4096; i++)//reset fat table
        FATTABLE[i]=0;
    //format the list
    for (i = 0; i < 128; i++){//reset filelist
        FileList[i].FirstBlock = 0;
        FileList[i].FileSize = 0;
    }
    fseek(FilePointer, 0, SEEK_SET);
    fwrite(FATTABLE, sizeof(FATTABLE), 1, FilePointer);
    fwrite(FileList, sizeof(FileList), 1, FilePointer);
    fclose(FilePointer);

}
void List()
{
    //data structures
    struct FileList File;

    //file pointers
    FILE *FilePointer;
    FilePointer = fopen(diskimage,"r");

    //set the cursor to the beginning of the file list
    fseek(FilePointer, 4096 * sizeof(int), SEEK_SET);

    printf("file name\t\tfile size\n");
    for (int i = 0; i < 128; i++)
    {
        fread(&File, sizeof(File), 1, FilePointer);
        //print if there is a file in the corresponding list location
        if ((File.FileSize != 0) && File.FileName[0] != '.')
            printf("%s\t\t%d\n", File.FileName, File.FileSize);
    }

    fclose(FilePointer);
}
void Delete( char *filename)
{

    //file pointers
    FILE *FilePointer;
    FilePointer = fopen(diskimage, "r+");

    //read fat and filelist
    fread(FATTABLE, sizeof(FATTABLE), 1, FilePointer);
    fread(FileList, sizeof(FileList), 1, FilePointer);
    fread(Data, sizeof(Data), 1, FilePointer);

    //find the file
    int i;
    for (i = 0; i < 128; i++)
    {
        //if the file is found
		if(strcmp(FileList[i].FileName, filename) == 0)
			break;
    }
    
    //if the file does not exist
    if (i == 128)
    {
        printf("File does not exist\n");
        fclose(FilePointer);
        return;
    }

    //delete file name
    memset(&FileList[i].FileName[0], 0, sizeof(FileList[i].FileName));
    
    //delete first block
    int index = FileList[i].FirstBlock;
    FileList[i].FirstBlock = 0;
    //delete file size
    int size = FileList[i].FileSize;
    FileList[i].FileSize = 0;

    int blocksize=size/512;
    if(size%512!=0)
    blocksize=blocksize+1;
    
    int tempEntry = -1;
    memset(&buffer[0], 0, sizeof(buffer));// load buffer with zeros

    for(int blockcounter=0;blockcounter<blocksize;blockcounter++)
    {
        fseek(FilePointer, 4096 * sizeof(int) + 128 * sizeof(struct FileList) + index * sizeof(struct Data), SEEK_SET);
        fwrite(&buffer, sizeof(char), 512, FilePointer);//write zeros to data
    
        tempEntry = FATTABLE[index];
        //delete FATTABLE index
        FATTABLE[index] = 0; 
        index = tempEntry;
    }
    
    
    fseek(FilePointer, 0, SEEK_SET);//write to file and close
    fwrite(FATTABLE, sizeof(FATTABLE), 1, FilePointer);
    fwrite(FileList, sizeof(FileList), 1, FilePointer);
    fclose(FilePointer);  
}

void ListPrint()
{
    //data structures
   

    //file pointers
    FILE *FilePointer;
    FilePointer = fopen(diskimage, "r");
    FILE *destinationPtr=fopen("filelist.txt","w");
    
    //read fat and filelist
    fseek(FilePointer, 4096 * sizeof(int), SEEK_SET);
    fread(FileList, sizeof(FileList), 1, FilePointer);
    //find the file
    fprintf(destinationPtr,"%s\t%s\t%s\n","Filename","Firstblock","Filesize(Bytes)");// print table context
    for (int i = 0; i < 128; i++)
    {   

        if(FileList[i].FileSize!=0){
        fprintf(destinationPtr,"%s\t%d\t\t%d\n",FileList[i].FileName, FileList[i].FirstBlock,FileList[i].FileSize);//print table row
        }
        else{
            fprintf(destinationPtr,"%s\t%d\t\tF%d\n","NULL      ", FileList[i].FirstBlock,FileList[i].FileSize);

        }
        /*
        if(FileList[i].FileSize!=0){
        for(int a=0;a<257;a++){
        if(FileList[i].FileName[a]=='\0'){
        fwrite("\n",1,1,destinationPtr);
        break;
        }
        fwrite(&FileList[i].FileName[a],1,1,destinationPtr);
        
        }
        
        
        }
        */
    }
    
    fclose(FilePointer);
}

void PrintFat()
{
    int FATHEX[4096];
    FILE *FilePointer;
    FilePointer = fopen(diskimage, "r");
    FILE *destinationPtr=fopen("fat.txt","w");//create fat.txt
    
    //read fat and filelist
    fread(FATHEX, 4, 4096, FilePointer);
    fprintf(destinationPtr,"Entry\tValue \tEntry\tValue \tEntry\tValue \tEntry\tValue\n");//printcontext
    for(int i=0;i<1024;i++)
        //print fat table row
        fprintf(destinationPtr,"%d\t0x%x \t%d\t0x%x \t%d\t0x%x \t%d\t0x%x \n",i*4,FATHEX[i*4],i*4+1,FATHEX[i*4+1],i*4+2,FATHEX[i*4+2],i*4+3,FATHEX[i*4+3]);
    
}

void DeFragmentation(){

 //file pointers
    FILE *FilePointer;
    struct Data NData[4096];//old fat table
    int NFAT[4096];//new fat table
    FilePointer = fopen(diskimage, "r+");

    //read fat and filelist
    fread(FATTABLE, 4, 4096, FilePointer);
    fread(FileList, sizeof(FileList), 1, FilePointer);
    fread(Data, sizeof(Data), 1, FilePointer);
    int datacounter=1;
    NFAT[0]=0XFFFFFFFF;//set the first element to ff
    for(int i=0;i<128;i++){// loop for all filelist elements which are not NULL
        if(FileList[i].FileSize !=0){
           
            int tempsize=FileList[i].FileSize;//get filesize
            int index= FileList[i].FirstBlock;// get firstblock
            FileList[i].FirstBlock=datacounter;//change the first block
            while(datacounter<4096&&(tempsize>0)){// loop until all data is relocated
                memcpy(&NData[datacounter],&Data[index],sizeof(Data[index]));//copy data to new data
                index=FATTABLE[index];// get the next index
                if(tempsize>512){// if file size is larger than 512, end is not reached
                NFAT[datacounter]=datacounter+1;
                }
                else {NFAT[datacounter]=0XFFFFFFFF;}// if the file size is 512, end is reached
                tempsize=tempsize-512;
                datacounter=datacounter+1;
            }





        }




    }
    memset(&buffer[0], 0, sizeof(buffer));// load buffer with zeros
    while(datacounter<4096){
    NFAT[datacounter]=0;
    memcpy(&NData[datacounter],buffer,512);// load the remeanin data with zeros
    datacounter=datacounter+1;
    }
    fseek(FilePointer, 0, SEEK_SET);//write to file and close
    fwrite(NFAT, sizeof(FATTABLE), 1, FilePointer);
    fwrite(FileList, sizeof(FileList), 1, FilePointer);
    fwrite(&NData,512,4096,FilePointer);
    //yazdır
    fclose(FilePointer);
    




}


int main(int argc, char *argv[])
{
    diskimage=argv[1];// get the diskimage or disk
	if(strcmp(argv[2], "-read") == 0)
		Read(argv[3], argv[4]);
    
    else if(strcmp(argv[2], "-write") == 0)
		Write(argv[3], argv[4]);
    else if(strcmp(argv[2], "-format") == 0)
		Format();
    else if(strcmp(argv[2], "-list") == 0)
		List();
    else if(strcmp(argv[2],"-delete") == 0)
		Delete(argv[3]);
    else if(strcmp(argv[2],"-printfilelist") == 0)
		ListPrint();
    else if(strcmp(argv[2],"-printfat") == 0)
		PrintFat();
    else if(strcmp(argv[2],"-defragment") == 0)
		DeFragmentation();
    else
        printf("command not found.\n");

	return 0;
}