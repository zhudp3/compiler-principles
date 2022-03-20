%{
#include <stdio.h>
#include <string.h>


const int key_num=32;
const char* keySet[]={
    "auto", "break", "case", "char", "const", "continue",
	"default", "do", "double", "else", "enum", "extern",
	"float", "for", "goto", "if", "int", "long", "register",
	"return", "short", "signed", "sizeof", "static", "struct",
	"switch", "typedef", "union", "unsigned", "void", "volatile",
	"while"
};



int iskey(char* str);




%}

letter [A-Za-z]
char '[^']*'
digit [0-9]
preprocess ^#.*
string \"[^\"]*\"
id  ({letter}|_)({letter}|_|{digit})* 
operater "!"|"%"|"^"|"&"|"*"|"("|")"|"-"|"+"|"="|"=="|"{"|"}"|"["|"]"|"\\"|"|"|":"|";"|"<"|">"|","|"."|"/"|"?"|"!="|"<="|">="|"&&"|"||"|"+="|"-="|"*="|"/="|"|%="|"<<="|">>="|"^="|"&=" 
int {digit}+ 
float ([+\-]?){digit}*(\.{digit}+)?((e|E)[+\-]?{digit}+)?
errorID {digit}({letter}|_|{digit})*({letter}|_)({letter}|_|{digit})* 
%x BLOCK_COMMENT 


%%

{preprocess} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"<%s,->\n",yytext);
    fclose(fp);
}

{string} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"<$string,%s>\n",yytext);
    fclose(fp);
}

{char} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"<$char,%s>\n",yytext);
    fclose(fp);
}

{id} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    if(!iskey(yytext))
        fprintf(fp,"<$ID,%s>\n",yytext);
    else 
        fprintf(fp,"<%s,->\n",yytext);
    fclose(fp);
}

{operater} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"<$operater,%s>\n",yytext);
    fclose(fp);
}

{int} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"<$int,%s>\n",yytext);
    fclose(fp);
}

{float} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"<$float,%s>\n",yytext);
    fclose(fp);
}

{errorID} {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"There is a wrong id: %s.\n",yytext);
    fclose(fp);
}

"//".*\n {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"single line comment.\n");
    fclose(fp);
}

"/*" {
    FILE *fp=NULL;
    fp=fopen("token.txt","a+");
    fprintf(fp,"multiple lines comment.\n");
    fclose(fp);
    BEGIN(BLOCK_COMMENT);
}

<BLOCK_COMMENT>"*/" {
    BEGIN(INITIAL);
}

%%

int iskey(char* str){
    for(int i=0;i<key_num;i++){
        if(strcmp(keySet[i],str)==0){
            return i+1;
        }
    }
    return 0;
}

int main(){
    FILE *fp=NULL;
    fp=fopen("token.txt","w+");
    fprintf(fp,"Hello, this is a Lexer degisned by zhudp3.\n");
    fclose(fp);
    yylex();
    return 0;
}
