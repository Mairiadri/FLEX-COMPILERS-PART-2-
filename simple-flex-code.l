/* Onoma arxeiou:       simple-flex-code.l
   Perigrafh:           Ypodeigma gia anaptyksh lektikou analyth me xrhsh tou ergaleiou Flex
   Syggrafeas:          Ergasthrio Metaglwttistwn, Tmhma Mhxanikwn Plhroforikhs kai Ypologistwn,
                        Panepisthmio Dytikhs Attikhs
   Sxolia:              To paron programma ylopoiei (me th xrhsh flex) enan aplo lektiko analyth
			pou anagnwrizei kena (space kai tab) kai akeraious (dekadikou systhmatos
			mono!) gia th glwssa Uni-C enw diaxeirizetai tous eidikous xarakthres
			neas grammhs '\n' (new line) kai 'EOF' (end of file). Yparxoun anafores
			gia thn anagnwrish metablhtwn, me ton pragmatiko kwdika na exei antikatastathei
			apo to lektiko FILL ME wste na symplhrwthei apo esas. Proairetika o lektikos
			analyths dexetai orismata arxeiwn gia eisodo kai eksodo.
   Odhgies ekteleshs:   Dinete "make" xwris ta eisagwgika ston trexonta katalogo. Enallaktika:
			flex -o simple-flex-code.c simple-flex-code.l
                        gcc -o simple-flex-code simple-flex-code.c
                        ./simple-flex-code
*/

/* H anagnwsh periorizetai se ena mono arxeio kai termatizei sto prwto EOF */
%option noyywrap 

/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Header file pou periexei lista me ola ta tokens */
#include "token.h"

/* Orismos metrhth trexousas grammhs */
int line = 1;

%}


/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makroskelwn kai dysnohtwn, kanonikwn ekfrasewn */

DELIMITER       [;]
IDENTIFIER      [a-zA-Z_][a-zA-Z0-9_]{0,31}
KEYWORD         (break|case|func|const|continue|do|double|else|float|for|if|int|long|return|short|sizeof|struct|switch|void|while)
STRING          \"[^\"]*\"
INTEGER         -*(0|0[xX][0-9a-fA-F]+|0[0-7]+|[1-9][0-9]*)
FLOAT           -?([0-9])+\.[0-9]*([eE][-+]?([0-9])+)?
OPERATOR        (\+|\-|\*|\/|%|==|!=|<=|>=|<|>|&&|\|\||\+=|-=|\*=|\/=|!|\+\+|\-\-|&|=)
COMMENT         \/\/.*|(\/\*[^*]*\*+([^/*][^*]*\*+)*\/)
WHITE_SPACES    [ \t]+
ERROR           [^;=\+\-\*/%\(\)\[\]\{\}\t\n ]+







/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias arithmhtikhs timhs mesw ths synarthshs yylex() */

%%

{DELIMITER}     { return DELIMITER; }   /*1.3 Λεκτικές μονάδες (tokens)*/
{KEYWORD}       { return KEYWORD;   }   /*1.3.2 Λέξεις κλειδιά         */
{IDENTIFIER}    { return IDENTIFIER;}   /*1.3.1 Αναγνωριστικά (ονόματα)*/
{STRING}        { return STRING;    }   /*1.3.3 Λεκτικά κυριολεκτικά   */
{INTEGER}       { return INTEGER;   }   /*1.3.4.1 Ακέραιοι             */
{FLOAT}         { return FLOAT;     }   /*1.3.4.2 Αριθμοί κινούμενης υποδιαστολής*/
{OPERATOR}      { return OPERATOR;  }   /*1.3.5 Τελεστές               */
{COMMENT}       { return COMMENT;   }   /*1.4 Σχολια                   */
{WHITE_SPACES}  { return WHITE_SPACES;} /*1.5 White_spaces χαρακτήρες  */
{ERROR}         { return ERROR;}        /*Κατηγορία λαθών*/

\n              { line++; printf("\n"); }
<<EOF>>		{ printf("#END-OF-FILE#\n"); exit(0); }

%%

/* Pinakas me ola ta tokens se antistoixia me tous orismous sto token.h */
char *tname[10] = {"WHITE_SPACES","INTEGER","KEYWORD","IDENTIFIER","FLOAT","COMMENT","STRING","OPERATOR","DELIMITER","ERROR"};

/* H synarthsh main: O kwdikas autos tha topotheththei autousios sto
   programma C pou tha dhmiourghsei to Flex kai tha apotelesei to arxiko
   shmeio ekteleshs ths efarmoghs tou lektikou analyth. */

int main(int argc, char **argv){
        int token;

        /* Ginetai o elegxos twn orismatwn ths grammhs entolwn. Ean ta
           orismata einai 3, to programma diabazei apo to arxeio tou 2ou
           orismatos kai grafei sto arxeio tou 3ou. Ean ta orismata einai
           2 diabazei apo to arxeio tou 2ou kai grafei sthn othonh.
           Ypenthymizetai oti to 1o orisma (argv[0]) sth C einai to onoma
           tou idiou tou ektelesimou arxeiou. */

        if(argc == 3){
                if(!(yyin = fopen(argv[1], "r"))) {
                        fprintf(stderr, "Cannot read file: %s\n", argv[1]);
                        return 1;
                }
                if(!(yyout = fopen(argv[2], "w"))) {
                        fprintf(stderr, "Cannot create file: %s\n", argv[2]);
                        return 1;
                }
        }
        else if(argc == 2){
                if(!(yyin = fopen(argv[1], "r"))) {
                        fprintf(stderr, "Cannot read file: %s\n", argv[1]);
                        return 1;
                }
        }

        /* H synarthsh yylex diabazei xarakthres apo thn eisodo kai prospathei
           na angnwrisei tokens. Ta tokens pou anagnwrizei einai auta pou exoun
           oristei sto paron arxeio, anamesa sta %% kai %%. An o kwdikas pou
           antistoixei se kapoio pattern periexei thn entolh 'return TIMH', h
           yylex() epistrefei thn timh auth h opoia kai apothhkeyetai sth
           metablhth token. */

        while( (token=yylex()) >= 0){
                /* Gia kathe token pou anagnwristhke, ektypwnetai h grammh pou auto
                   brethhke kathws kai to onoma tou mazi me thn timh tou. */
                fprintf(yyout, "\tLine=%d, token=%s, value=\"%s\"\n", line, tname[token-1], yytext);
        }
        return 0;
}
