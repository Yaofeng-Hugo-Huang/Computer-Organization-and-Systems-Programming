//Name: Yaofeng(Hugo) Huang, Student ID: A16571330, Date: Nov 04, 2020
//This program is to output a csv file of the selcted columns in a inputed csv file
//The input file allow use quoation mark for the element in each Record. 

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include "converter.h"

char *tokens = NULL;
int main(int argc, char **argv){

    int opt, c_flag=0, err_opt=0;//detecting the "-c" command
    while((opt = getopt(argc, argv, "+c")) != -1){
        switch(opt){
        case 'c':
            c_flag=1;
            break;
        default:
            err_opt=1;
            break;
        }
    }
    
    int in_tableColumn=0, in_tableRow=0, out_tableColumn=0;
    size_t bufcap = 0;
    char *buf = NULL;

    if(stdin!=NULL && stdout!=NULL){
        getline(&buf, &bufcap, stdin);//read the first line of file
        int len = strlen(buf);
        in_tableColumn = calculateCol(buf,len);
    }else{
        err_opt=1;
    }
        
    //Build a array for output processing
    out_tableColumn=argc-3; 
    int *out_table=NULL;
    out_table=malloc(out_tableColumn*sizeof(int*));
    
    //Check if selecting colomns are in the range
    int indexOf_out_table=0;
    for(int i=3; i<argc;++i){
        if(argv[i]!=NULL && atoi(argv[i])>in_tableColumn){
            err_opt=1;
        }else{//Processing 2：
            out_table[indexOf_out_table] = atoi((argv[i]));
            ++indexOf_out_table;
        }
    }

    //Exit when colomns number is invalid or without -c
    if(err_opt==1||c_flag!=1||(atoi(argv[2])!= in_tableColumn 
        || atoi(argv[2])<1)){ 
        if(buf!=NULL){
            free(buf);
            buf = NULL;
        }
        if(out_table!=NULL){ 
            free(out_table);
            out_table = NULL;
        }
        print_usage(argv[0]);
    }

    //Build a array for input processing
    char **in_table = NULL;
    in_table = malloc(in_tableColumn*sizeof(int*));
    
    do{//Processing 1:
        in_tableRow ++;
        //check each row has the same columns 
        if(calculateCol(buf,strlen(buf))!=in_tableColumn){
            fprintf(stderr, "%s: dropping record# %lu\n", argv[0],in_tableRow);
        }else{
            int len = strlen(buf);
            int index = split(buf,0,len);
            //copy a Record to buf
            for(int col_in_table=0;col_in_table<in_tableColumn;++col_in_table){
                in_table[col_in_table]=malloc(strlen(tokens)+1);
                strcpy(in_table[col_in_table],tokens);
                index=split(buf,index+1,len);
            }

            //standard out the required columns
            if(buf[strlen(buf)-1]=='\n')
                output(in_table,out_table,indexOf_out_table);
            else{
                int i;
                for(i=0; i<indexOf_out_table-1; ++i)
                    fprintf(stdout,"%s,",in_table[out_table[i]-1]);
                fprintf(stdout,"%s",in_table[out_table[i]-1]);
            }
        }
    }while(getline(&buf, &bufcap, stdin)>0);//Processing 3
    
    if(tokens!=NULL){
        free(tokens);
        tokens =NULL;
    }
    if(buf!=NULL){
        free(buf);
        buf = NULL;
    }
    if(in_table!=NULL){
        free(in_table);
        in_table = NULL;
    }
    if(out_table!=NULL){
        free(out_table);
        out_table = NULL;
    }
    if(err_opt==1)
        exit(EXIT_FAILURE); 

    return EXIT_SUCCESS;
    
}

//print the usage of the program when the inpute is invalid 
void print_usage(char *name){
    fprintf(stderr,"usage: %s [-c] [arg ...]\n",name);
    exit(EXIT_FAILURE);
}

//calculate the number of elements of a record
int calculateCol(char *dataRecord, int len){
    int colomnFile=0;
    for(int i=0; i<len;i++){//get the colomn number
        if(dataRecord[i]==','){
            colomnFile+=1;
            if(dataRecord[i+1]=='"'){//Deal with "
                for(int j=i+2;j<len;j++){
                    if(dataRecord[j]=='"'){
                        i=j;
                        break;
                    }
                }
            }
        }
    }
    return colomnFile+1;
}

//splict the , 
int split(char* buf, int index, int len){
    int token_length=0, j;
     //deal with the "
    if(buf[index]=='"'&& (index==0||buf[index-1]==',')){
        for(j=index;j<len;++j){
            if(buf[j]=='"' && (buf[j+1]==','||buf[j+1]=='\n')){
                j++;
                break;
            }
        }  
    }else if(buf[index-1]==','||index==0){//deal with normal ,
        for(j=index;j<=len;++j){
            if(buf[j]==','|| buf[j]=='\n')
                break;
        }
    }
    token_length = j-index+1;
    tokens=malloc(token_length);
    if(token_length==1){
        tokens[0] = '\0';
    }else{
        int i;
        for(i=0;i<token_length-1;i++){
            if(index<len){
                tokens[i] = buf[index];
            }
            ++index;
        }
    }
    return j;
}

//Output string
void output(char** in_table, int* out_table, int len){
    int i;
    for(i=0; i<len-1; ++i){
        fprintf(stdout,"%s,",in_table[out_table[i]-1]);
    }
    fprintf(stdout,"%s\n",in_table[out_table[i]-1]);
}

